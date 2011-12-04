/*
 * File		: MigrateTableName.ec
 * 
 * Sccs		: @(#)MigrateTableName.ec	1.2
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
 * Name 	: MigrateTableName - populate the MigrateTable structure 
 *
 * Synopsis	: PUBLIC
 *		  void
 *		  MigrateTableName(mptr, tablename)
 *		  MigrateTable *mptr;
 *		  char         *sqlbuf;
 *
 * Arguments	: mptr		- A MigrateTableName structure.
 *
 *		  sqlbuf	- a buffer containing the sql to create this
 *				  table.
 *
 * Description	: MigrateTableName parses the sql which creates 
 *		  a table and extracts the tablename. This is used to 
 *		  populate a MigrateTableName structure.
 *
 * Returns	: void
 *
 * See Also	: ancestors
 *
 */

EXEC SQL include "iimport.h";

PRIVATE
char *sccsid = "SCCS: @(#)MigrateTableName.ec	1.2 Continuus: %subsystem: % %filespec: %";

PUBLIC
void
MigrateTableName(mptr, sqlbuf)
MigrateTable *mptr;
char         *sqlbuf;
{
    FINAL char *where = "iimport.MigrateDatabase.SourceTablesProcess.MigrateTableName";
    char *ptr;
    char *dot;
    char *token;
    char buf[ MAX_SQL_BUF ];
    enum _tokenstatus {SCAN, CREATE, TABLE, TABLENAME} tokenstatus = SCAN;

	DEBUG("\nMODULE [ %s ]\n\n", where);

    (void) strcpy(buf, sqlbuf);

    ptr = buf;

    while((token = strtok(ptr, " 	\n")) != (char *)NULL)
    {
	ptr = (char *)NULL;

	if(!strcmp(token, "create"))
	{
	    tokenstatus = CREATE;
	    continue;
	}
	else if (!strcmp(token, "table") && tokenstatus == CREATE)
	{
	    tokenstatus = TABLE;
	    continue;
	}

	if(tokenstatus == TABLE)
	    break;
    }

    (void) strcpy(mptr->tablename, token);
    (void) strcpy(mptr->sqlbuf, sqlbuf);


    if((dot = strrchr(token, '.')) != (char *)NULL)
	strcpy(mptr->shortname, ++dot);
    else
	strcpy(mptr->shortname, token);


    DEBUG("TableName [ %s ]\n", mptr->tablename);
    DEBUG("SQL Buff  [ %s ]\n", mptr->sqlbuf );
}
