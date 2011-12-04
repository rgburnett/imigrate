/*
 * File		: MakeMigrateSpace.ec
 * 
 * Sccs		: @(#)MakeMigrateSpace.ec	1.4
 *
 * Dated	: 96/10/24 14:43:50 
 *
 * Owner	: Graeme Burnett
 *
 * Continuus
 * 
 * Type		: %cvtype: %
 * Created by	: %created_by: %
 * Date Created	: %date_created: %
 * Date Modified: %date_modified: %
 * Derived by	: %derived_by: %
 * File/Version	: %filespec: %
 *
 */

/*
 *
 * Name 	: MakeMigrateSpace - find space to create a migration space. 
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  MakeMigrateSpace(spacename)
 *		  char *spacename;
 *
 * Arguments	: spacename	- destination for the migration database 
 *
 * Description	: MakeMigrateSpace constructs a new dbspace and adds 
 *		  chunks to it, made from Unix file space in /export/database
 *		  up to the global.occupancy percentage of the file system.
 *
 * Returns	: status values
 *
 * See Also	:
 *
 */

EXEC SQL include "iimport.h";

PRIVATE
char *sccsid = "SCCS: @(#)MakeMigrateSpace.ec	1.4 Continuus: %subsystem: % %filespec: %";

EXEC SQL include "sys/mode.h";
EXEC SQL include "sys/stat.h";
EXEC SQL include "sys/time.h";
EXEC SQL include "sys/resource.h";
EXEC SQL include "sys/statfs.h";
EXEC SQL include "fcntl.h";
EXEC SQL include "pwd.h";

PUBLIC
status
MakeMigrateSpace(spacename)
char *spacename;
{
    char dir[ PATH_MAX ];
    char chunk_path[ PATH_MAX ];
    struct rlimit rl;
    struct statfs sb;
    long inf_chunk_blocks;
    int total_fs_blocks;
    int blocks_used;
    uid_t informix_uid;
    gid_t informix_gid;
    struct passwd pw, *pwptr = &pw;
    char *where = "iimport.MakeMigrateSpace:";

    /*
     * chown call further down needs to be run as root, so must check for
     * effective privilige.
     */

    DEBUG("\nMODULE [ %s ]\n\n", where);

    if(geteuid() != 0)
	return Error(IU_EPERM, where, "80");

    if((pwptr = getpwnam("informix")) == (struct passwd *)NULL)
	return Error(errno, where, "83");

    informix_uid = pwptr->pw_uid;
    informix_gid = pwptr->pw_gid;

    /*
     * Find out our current resource limits and set the limit to the
     * hard limit if necessary
     */

    if(getrlimit(RLIMIT_FSIZE, &rl))
	return Error(errno, "iimport.MakeMigrateSpace: cannot retrieve ulimit", "94");

    DEBUG("Maximum UNIX file size [ %dK ]\n", rl.rlim_max/1024);

    if(rl.rlim_cur < rl.rlim_max)
    {
	rl.rlim_cur = rl.rlim_max;

	if(setrlimit(RLIMIT_FSIZE, &rl))
	    return Error(errno, "iimport.MakeMigrateSpace: cannot set ulimit", "103");
    }

    /*
     * Create the migrate chunks directory (usually in /export/database)
     * If it iexists, carry on.
     */


    strcpy(dir, global.migrate_dir);
    strcat(dir, "/migrate_chunks");

    if(mkdir(dir, S_IRWXU) == -1)
	if( errno != EEXIST)
	    return Error(errno, where, "117");

    /*
     * Find out how much space we have on the export directory and how much
     * to use.
     */

    if(statfs(global.migrate_dir, &sb) == -1)
	return Error(errno, where, "125");

    DEBUG("Migrate dbspace Directory [ %s ] \n", dir);

    global.max_chunk_size = rl.rlim_max;


    /*
     * How many file system blocks it takes to make up the largest 
     * Informix chunk? This will be our chunk size divided by the 
     * native file system block size.
     */

    inf_chunk_blocks = global.max_chunk_size / sb.f_fsize;

    DEBUG("%d Blocks of %d bytes [ %dK ] available on file system\n", sb.f_bavail, 
					sb.f_fsize, (sb.f_bavail * sb.f_fsize)/1024);


    /*
     * How many blocks are available in total. Calculate what percentage 
     * of the total available we will occupy.
     */

    total_fs_blocks = sb.f_bavail * (double)global.occupancy/100;

	DEBUG("%d Blocks available. ", sb.f_bavail);
	DEBUG("Occupancy of %d%% will use %d File system blocks [ %dK ]\n", 
		global.occupancy, total_fs_blocks, (total_fs_blocks * sb.f_fsize)/1024);

    /*
     * Now create enough chunks
     */

    for(blocks_used = 0; blocks_used <= total_fs_blocks; blocks_used += inf_chunk_blocks)
    {
	int first = 1;
	int objtype = DBSPACE;
	int fd;
	int chunk_count = 0;
	dbspace db, *ptr = &db;


	/* 
	 * Construct the path of this chunk and create the UNIX
	 * file if necessary
	 */

	sprintf(chunk_path, "%s/migrate_chunk%03d",  dir, chunk_count++);

	if((fd = open(chunk_path, (O_CREAT | O_RDWR | O_TRUNC), 0660)) == -1)
	    return Error(errno, "iimport.MakeMigrateSpace", "176");

	close(fd);

	if(chmod(chunk_path, 0660) == -1)
	    return Error(errno, where, "181");

	if(chown(chunk_path, informix_uid, informix_gid) == -1)
	    return Error(errno, where, "184");

	DEBUG("Changing ownership and mode of [ %s ]\n", chunk_path);

	bzero(ptr, sizeof(dbspace));

	if(first)
	{
	    first = 0;
	    objtype = DBSPACE;

	    /*
	     * First time through? then drop the migrate dbspace
	     */

	    if(IUDBObjectExists("sysmaster", objtype, spacename) == IU_SUCCESS)
	    {

		DBSPACEOP(ptr, DROPDBSPACE);
		DBSPACENAME(ptr, spacename);

		DEBUG("Dropping existing migrate space [ %s ]\n", spacename);

		if(IUOnspaces(ptr) != IU_SUCCESS)
		    return Error(IU_ERTERROR, "iimport.MakeMigrateSpace: DROPDBSPACE", 
						"%C");
	    }

	    bzero(ptr, sizeof(dbspace));

	    DBSPACEOP(ptr, CREATEDBSPACE);
	    DEBUG("Creating Migrate space [ %s ]\n", spacename);
	}
	else
	{
	    DBSPACEOP(ptr, ADDCHUNK);
	    DEBUG("Adding Chunk [ %s ]\n", spacename);
	}

	DBSPACENAME(ptr, spacename);
	DBSPACEPATH(ptr, chunk_path);
	DEBUG("Chunk Path [ %s ]\n", chunk_path);

	DBSPACEOFFSET(ptr, 0);
	DBSPACESIZE(ptr, DbSpaceSize(global.max_chunk_size/sb.f_fsize, PAGE_SIZE));

	DEBUG("Size %dK\n", DbSpaceSize(global.max_chunk_size/sb.f_fsize, PAGE_SIZE));
	DBSPACETMP(ptr, 0);
	DBSPACEMIRROR(ptr, (char *)NULL);
	DBSPACEMIRROROFFSET(ptr, 0);

	if(IUOnspaces(ptr) != IU_SUCCESS)
	    return Error(IU_ERTERROR, "iimport.MakeMigrateSpace.IUOnspaces", "%C");

	(void) bzero(ptr, sizeof(dbspace));
    }

    return IU_SUCCESS;
}

/*
 * Name 	: DbSpaceSize - return a the correct size for a dbspace.
 *
 * Synopsis	: PRIVATE
 *		  long
 *		  DbSpaceSize(total, pagesize)
 *		  long total;
 *		  register int pagesize;
 *
 * Arguments	: total - total amount of space available
 *
 *		  pagesize - native page size of Informix
 *
 * Description	: DbSpaceSize iteratively reduces the amount of space 
 *		  allocate to a dbspace until it is divisable by the
 *		  native page size.
 *
 * Returns	: size of the dbspace 
 *
 * See Also	: envbuild(1DB) - this is a direct copy of the bc(1)
 *		  function written in envbuild.
 *
 */

PRIVATE
long
DbSpaceSize(total, pagesize)
long total;
register int pagesize;
{
    register long remainder;

    pagesize /= 1024;
    total /= pagesize;

    for(remainder = (total - 53); (remainder % pagesize) != 0; remainder -= 1) 
		;

    return remainder * pagesize;
}
