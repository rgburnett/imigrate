/*
 * File		: IURenameTable.ec
 * 
 * Sccs		: @(#)IURenameTable.ec	1.2
 *
 * Dated	: 96/10/30 15:24:23 
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
#include "c.class.h"
#include "error.class.h"
#include "c.proto.h"
#include "global.h"

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)IURenameTable.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IURenameTable - rename a table 
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  IURenameTable(from, to)
 *		  char *from;
 *		  char *to;
 *
 * Arguments	: from - original table name
 *
 *		  to   - destination table name
 *
 * Description	: IURenameTable renames a table to  a different name, checking whether
 *		  the target and source tables exist.
 *
 * Notes	: Bit noddy - but useful  
 *
 * Returns	: IU_SUCCESS on success, status values and diagnostics on error
 *
 * See Also	: 
 *
 */

PUBLIC
status
IURenameTable(database, from, to)
char *database;
char *from;
char *to;
{
    char rename_cmd[ 256 ];
    status retval;

    if((retval = IUDBObjectExists(database, TABLE, from)) != IU_SUCCESS)
	return Error(IU_EEXISTS, "IURenameTables: Source Table Does not exist", "74"); 

    if((retval = IUDBObjectExists(database, TABLE, to)) == IU_SUCCESS)
	return Error(IU_EOBJECTEXISTS, "IURenameTable: Destination table exists", "77");

    sprintf(rename_cmd, "RENAME TABLE %s TO %s;", from, to);

    return IURunSQL(rename_cmd, NULL, REPORT);
}

#ifdef TEST

main()
{
    char *db;

    db = IUDBConnect("stores7", NORMAL);

    if(db == (char *)NULL)
	fprintf(stderr, "Connect failed\n");

    printf("db = %s\n", db);

    if(IURenameTable("stores7", "cust_calls", "fred") != IU_SUCCESS)
	printf("Rename from cust_calls to fred failed\n");

    if(IURenameTable("stores7", "fred", "cust_calls") != IU_SUCCESS)
	printf("Rename from cust_calls to fred failed\n");

    if(IURenameTable("stores7", "bert", "ted") != IU_SUCCESS)
	printf("Rename from bert to ted failed\n");

    exit(1);
}

#endif
