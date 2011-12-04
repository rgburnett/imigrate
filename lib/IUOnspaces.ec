/*
 * File		: IUOnspaces.ec 
 * 
 * Sccs		: @(#)IUOnspaces.ec	1.2 
 *
 * Dated	: 96/10/30 15:24:22 
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

#ifdef TEST
EXEC SQL define MAIN;
#define MAIN
#endif

#include "c.incl.h"
#include "c.defs.h"
EXEC SQL include "esql.defs.h";
#include "c.class.h"
EXEC SQL include "esql.class.h";
#include "error.class.h"
#include "c.proto.h"
EXEC SQL include "esql.proto.h";
#include "global.h"

#include <sys/types.h>
#include <sys/limits.h>
#include <pwd.h>

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)IUOnspaces.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUOnspaces - C interface to onspaces 
 *
 * Synopsis	: char *IUOnspaces(spaceobj)
 *		  dbspace spaceobj;
 *
 * Arguments	: <dbspace>	a dbspace object (see c.class.h) having the
 *			 	following fields:
 *
 *		  spaceobj.op
 *
 *		  CREATEDBSPACE create a database space
 *		  DROPDBSPACE   drop a databse space
 *		  ADDCHUNK	add a chunk
 *		  DROPCHUNK	drop a chunk
 *		  STARTMIRROR   start mirroring on a chunk/dbspace
 *   		  ENDMIRROR     stop mirroring on a chunk/dbspace
 *   		  CHUNKDOWN     mark a chunk as down
 *   		  CHUNKONLINE   mark a chunk as online
 *   		  DATASKIPON    turn dataskip 
 *   		  DATASKIPOFF   turn dataskip 
 *
 *		  spaceobj.spacename
 *	
 *		  	The name of the blobspace or dbspace you are 
 *		 	operating on or creating
 *		  
 *		  spaceobj.pagesize
 *
 *		  	number of disk pages per blobpage.
 *
 *		  spaceobj.path
 *
 *			path of the device/file of the chunks/dbspace you are
 *			deleting/adding.
 *
 *		  spaceobj.offset
 *
 *			any initial offset for this file.
 *
 *		  spaceobj.size
 *
 *			the size in K bytes of this chunk/dbspace
 *
 * 		  spaceobj.tmp
 *
 *			boolean if this is a temporary space.
 *
 *		  spaceobj.mirror_path
 *
 *			a mirroring path if applicable.
 *
 *		  spaceobj.mirror_offset
 *
 *			an offset for this mirror chunk.
 *
 * Description	: IUOnspaces allows you to call onspaces from a C program based
 *		  on the operation parameters in the spaceobj structure passed.
 *
 *		  You must have root or informix privilige to run this routine.
 *
 * Notes	: There are a set of macros define to ease the interface to
 *		  IUOnspaces:
 *
 *		    #define DBSPACEOP(ptr, x)		ptr->op = x
 *		    #define DBSPACENAME(ptr, x)		strcpy(ptr->spacename, x)
 *		    #define DBSPACEPATH(ptr, x)		strcpy(ptr->path, x)
 *		    #define DBSPACEOFFSET(ptr, x)	ptr->offset = x
 *		    #define DBSPACESIZE(ptr, x)		ptr->size = x
 *		    #define DBSPACETMP(ptr, x)		ptr->tmp = x
 *		    #define DBSPACEMIRROR(ptr, x)	strcpy(ptr->mirror_path, x)
 *		    #define DBSPACEMIRROROFFSET(ptr, x)	ptr->mirror_offset = x
 *
 *
 * See Also	: system(3) 
 *
 * Sccs 	: @(#)IUOnspaces.ec	1.2 
 *
 * Continuus 
 * Project	: %subsystem% %filespec%";
 */

PUBLIC
status
IUOnspaces(spaceobj)
dbspace	*spaceobj;
{
    struct passwd pw, *pwptr = &pw;
    char itoabuf[ 256 ];
    char command[ PATH_MAX ];
    int euid;

    if(spaceobj == (dbspace *)NULL)
	return Error(IU_EINVALIDARG, "IUOnspaces", "138");

    if((pwptr = getpwnam("informix")) == (struct passwd *)NULL)
	return Error(errno, "IUOnspaces", "141");

    if(((euid = geteuid()) != pwptr->pw_uid) && euid != 0) 
	return Error(IU_EPERM, "IUOnspace", "144");

    strcpy(command, "onspaces ");

    switch(spaceobj->op)
    {
	/*
	 * -c {-d DBspace [-t] | -b BLOBspace -g pagesize}
         *           -p pathname -o offset -s size [-m path offset]
	 */

	case CREATEDBSPACE:

	    if(IUDBObjectExists("sysmaster", DBSPACE, spaceobj->spacename) == IU_SUCCESS)
		return Error(IU_EOBJECTEXISTS, 
		    "IUOnspaces: dbspace already exists", "159");

	    strcat(command, " -c ");


	    if(spaceobj->pagesize > 0)
	    {
		strcat(command, " -b ");
		strcat(command, spaceobj->spacename);
		sprintf(itoabuf, " %d ", spaceobj->pagesize);
		strcat(command, itoabuf);
	    }
	    else
	    {
		strcat(command, " -d ");
		strcat(command, spaceobj->spacename);
		if(spaceobj->tmp)
		    strcat(command, " -t ");
	    }

	    strcat(command, " -p ");
	    strcat(command, spaceobj->path);
	    strcat(command, " -o ");
	    sprintf(itoabuf, " %d ", spaceobj->offset);
	    strcat(command, itoabuf);

	    strcat(command, " -s ");
	    sprintf(itoabuf, " %d ", spaceobj->size);
	    strcat(command, itoabuf);

	    if(*spaceobj->mirror_path != '\0')
	    {
		if(IUDBObjectExists("sysmaster", DBSPACE, spaceobj->mirror_path) 
									== IU_SUCCESS)
		    return Error(IU_EOBJECTEXISTS,
				    "IUOnspaces: mirror chunk already exists", "194");

		strcat(command, " -m ");
		strcat(command, spaceobj->mirror_path);

		sprintf(itoabuf, " %d ", spaceobj->mirror_offset);
		strcat(command, itoabuf);
	    }
	    break;


	/*
         * -d spacename [-p pathname -o offset] [-y] |
	 */
	    
	case DROPCHUNK:
	case DROPDBSPACE:

	    if(IUDBObjectExists("sysmaster", DBSPACE, spaceobj->spacename) != IU_SUCCESS)
		return Error(IU_EEXISTS, "IUOnspaces: CHUNKS/SPACE non-existant", "213");

	    strcat(command, " -d ");

	    strcat(command, spaceobj->spacename);

	    /*
	     * This bit for specific chunks
	     */

	    if(*spaceobj->path != '\0')
	    {
		if(IUDBObjectExists("sysmaster", DBCHUNK, spaceobj->path) != IU_SUCCESS)
		    return Error(IU_EEXISTS, "IUOnspaces: CHUNKS/SPACE non-existant", "226");
		strcat(command, " -p ");
		strcat(command, spaceobj->path);
		strcat(command, " -o ");
		sprintf(itoabuf, " %d ", spaceobj->offset);
		strcat(command, itoabuf);
	    }
	    strcat(command, " -y");
	    break;

	/*
	 * -a spacename -p pathname -o offset -s size [-m path offset]
	 */

	case ADDCHUNK:

	    if(IUDBObjectExists("sysmaster", DBSPACE, spaceobj->spacename) != IU_SUCCESS)
		return Error(IU_EEXISTS, "IUOnspaces: DBSPACE non-existant", "243");

	    if(IUDBObjectExists("sysmaster", DBCHUNK, spaceobj->path) == IU_SUCCESS)
		return Error(IU_EOBJECTEXISTS, "IUOnspaces: CHUNK already exists ", "246");

	    strcat(command, " -a ");
	    strcat(command, spaceobj->spacename);
	    strcat(command, " -p ");
	    strcat(command, spaceobj->path);
	    strcat(command, " -o ");
	    sprintf(itoabuf, " %d ", spaceobj->offset);
	    strcat(command, itoabuf);
	    strcat(command, " -s ");
	    sprintf(itoabuf, " %d ", spaceobj->size);
	    strcat(command, itoabuf);

	    if(*spaceobj->mirror_path != '\0')
	    {
		if(IUDBObjectExists("sysmaster", DBCHUNK, spaceobj->mirror_path) 
									== IU_SUCCESS)
		    return Error(IU_EOBJECTEXISTS,
				    "IUOnspaces: mirror chunk already exists", "264");

		strcat(command, " -m ");
		strcat(command, spaceobj->mirror_path);

		sprintf(itoabuf, " %d ", spaceobj->mirror_offset);
		strcat(command, itoabuf);
	    }

	    break;

	/*
	 * -m spacename {-p pathname -o offset -m path offset [-y] | 
         *                  -f filename} |
	 */
	case STARTMIRROR:

	    if(IUDBObjectExists("sysmaster", DBSPACE, spaceobj->spacename) != IU_SUCCESS)
		return Error(IU_EEXISTS, "IUOnspaces: DBSPACE non-existant", "282");

	    strcat(command, " -m ");
	    strcat(command, spaceobj->spacename);

	    if(*spaceobj->path != '\0')
	    {
		if(IUDBObjectExists("sysmaster", DBCHUNK, spaceobj->path) != IU_SUCCESS)
		    return Error(IU_EOBJECTEXISTS,
				"IUOnspaces: DBSPACE non-existant", "291");

		if(IUDBObjectExists("sysmaster", DBCHUNK, 
						    spaceobj->mirror_path) == IU_SUCCESS)
		    return Error(IU_EOBJECTEXISTS,
				"IUOnspaces: mirror DBSPACE already exists", "296");

		strcat(command, " -p ");
		strcat(command, spaceobj->path);
		strcat(command, " -o ");
		sprintf(itoabuf, " %d ", spaceobj->offset);
		strcat(command, itoabuf);
		strcat(command, " -m ");
		strcat(command, spaceobj->mirror_path);
		sprintf(itoabuf, " %d ", spaceobj->mirror_offset);
		strcat(command, itoabuf);
		strcat(command, " -y");
	    }
	    else
	    {
		strcat(command, " -f ");
		strcat(command, spaceobj->path);
	    }
	    break;
	/*
	 * -r spacename [-y]
	 */

	case ENDMIRROR:

	    if(IUDBObjectExists("sysmaster", DBSPACE, spaceobj->spacename) != IU_SUCCESS)
		return Error(IU_EEXISTS, "IUOnspaces: DBSPACE non-existant", "322");

	    strcat(command, " -r ");
	    strcat(command, spaceobj->spacename);
	    strcat(command, " -y");

	    break;
	/*
	 * -s spacename -p pathname -o offset {-O | -D} [-y]
	 */
	case CHUNKDOWN:
	case CHUNKONLINE:

	    if(IUDBObjectExists("sysmaster", DBSPACE, spaceobj->spacename) != IU_SUCCESS)
		return Error(IU_EEXISTS, "IUOnspaces: DBSPACE non-existant", "336");

	    if(IUDBObjectExists("sysmaster", DBCHUNK, spaceobj->path) != IU_SUCCESS)
		return Error(IU_EEXISTS, "IUOnspaces: DBCHUNK non-existant", "339");

	    strcat(command, " -s ");
	    strcat(command, spaceobj->spacename);
	    strcat(command, " -p ");
	    strcat(command, spaceobj->path);
	    strcat(command, " -o ");
	    sprintf(itoabuf, " %d ", spaceobj->offset);
	    strcat(command, itoabuf);
	    strcat(command, (spaceobj->op == CHUNKDOWN) ? " -D " : " -O ");
	    strcat(command, " -y");

	    break;

	case DATASKIPON:
	case DATASKIPOFF:

	    if(IUDBObjectExists("sysmaster", DBSPACE, spaceobj->spacename) != IU_SUCCESS)
		return Error(IU_EEXISTS, "IUOnspaces: DBSPACE non-existant", "357");

	    strcat(command, " -fy ");
	    strcat(command, (spaceobj->op == DATASKIPON) ? " on " : " off ");
	    strcat(command, spaceobj->spacename);

	    break;

	default:
	    return Error(IU_EINVALIDARG, "IUOnspaces", "366");
    }

    printf("Executing onspaces(1INF) command [ %s ]\n", command);

    return (system(command) == 0) ? IU_SUCCESS : IU_ERTERROR;
}

#ifdef TEST

main()
{

    dbspace	db, *ptr = &db;

    DBSPACEOP(ptr, CREATEDBSPACE);
    DBSPACENAME(ptr, "fred");
    DBSPACEPATH(ptr, "/dev/bert");
    DBSPACEOFFSET(ptr, 10);
    DBSPACESIZE(ptr, 100);

    IUOnspaces(ptr);

    bzero(ptr, sizeof(db));

    DBSPACEOP(ptr, DROPDBSPACE);
    DBSPACENAME(ptr, "rootdbs");

    IUOnspaces(ptr);

}

#endif    
