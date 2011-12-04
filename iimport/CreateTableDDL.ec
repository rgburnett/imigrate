/*
 * File		: CreateTableDDL.ec
 * 
 * Sccs		: @(#)CreateTableDDL.ec	1.4
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

EXEC SQL include "iimport.h";

PRIVATE
char *sccsid = "SCCS: @(#)CreateTableDDL.ec	1.4 Continuus: %subsystem: % %filespec: %";

/*
 * Name 	: CreateTableDDL - create a list of CREATE TABLE from an export DDL file
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  CreateTableDDL(alist, database)
 *		  list alist;
 *		  char *database;
 *
 * Arguments	: alist	- an empty list.
 *
 *		  database - name of a database.
 *
 * Description	: CreateTableDDL parses DDL file statements, extracting 
 *		  all the CREATE TABLE statements and builds a list.
 *
 * Returns	: status values of IU_SUCCESS on successful completion.
 *
 * See Also	: ListAppend(3DB)
 *
 */

PUBLIC
status
CreateTableDDL(alist, database)
list *alist;
char *database;
{
    FINAL char *where = "iimport.MigrateDatabase.CreateTableDDL";
    char dbobj[ PATH_MAX ];
    char sqlbuf[ MAX_SQL_BUF ];
    char sqlfile[ PATH_MAX ];
    FILE *fp;


    DEBUG("\nMODULE [ %s ]\n\n", where);

    /*
     * First stage, make up the directory name. If the user 
     * has specified a directory for the source, then use
     * this, otherwise use the defaults
     */

    if(!strcmp(global.source_dir, ".")) /* No source directory specified */
    {
	(void) strcpy(dbobj, database);

	if(global.compressed == TRUE)
	    (void) strcat(dbobj, COMPRESSED_IEXPORT_DIR);
	else
	    (void) strcat(dbobj, DBEXPORT_DIR);
    }
    else
	(void) strcpy(dbobj, global.source_dir);
	
    DEBUG("Database export directory is [ %s ]\n", dbobj);

    /*
     * ... and try to access it. NB - the existence of this has 
     * been checkd in ParseArgs.
     */

    if(chdir(dbobj))
	return Error(errno, "iimport.CreateTableDDL.chdir: database export directory", 
										"90");

    /*
     * Now we are there, construct the DDL file name
     *
     * We are now in a /blah/blah/blah/dbname.[c]exp
     *				       ^^^^^^
     *                              we need this part
     */

    {
	char buf[ PATH_MAX ];
	char *ptr = strrchr(dbobj, '/');

	if(ptr != (char *)NULL)
	    strcpy(buf, ++ptr); 
	else
	    strcpy(buf, dbobj);

	ptr = strrchr(buf, '.');
	*ptr = '\0';

	strcpy(sqlfile, buf);
        strcat(sqlfile, ".sql");
	strcat(dbobj, "/");
	strcat(dbobj, sqlfile);
    }


    DEBUG("Database Export sql file [ %s ]\n", sqlfile);

    if((fp = fopen(sqlfile, "r")) == (FILE *)NULL)
	return Error(errno, 
	    "iimport.CreateTableDDL.fopen: Cannot open database.sql file",
		"124");

    /*
     * Loop throught the file, reading SQL statements.
     * If this is a create table statement, then add 
     * this statement to the list.
     */

    while(ReadSQL((char *)sqlbuf, fp) != (char *)NULL)
    {
	if(match(sqlbuf, "create table"))
	{
	    MigrateTable  *mptr = (MigrateTable *)NULL;

	    char *ptr = strstr(sqlbuf, "create table");

	    if((mptr = (MigrateTable *)malloc(sizeof(MigrateTable))) == 
								(MigrateTable *)NULL)
		return Error(errno, "iimport.CreateTableDDL.malloc", "142");

	    MigrateTableName(mptr, sqlbuf);

	    if(ListAppend(alist, (generic_ptr)mptr) != IU_SUCCESS)
		return Error(IU_ERTERROR, 
			"iimport.CreateTableDDL.ListAppend", "148");
	}
	bzero(sqlbuf, MAX_SQL_BUF);
    }

    free(dbobj);

    return IU_SUCCESS;
}
