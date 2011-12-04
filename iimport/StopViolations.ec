/*
 * File		: StopViolations.ec 
 * 
 * Sccs		: @(#)StopViolations.ec	1.3
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
 * Name 	: StopViolations - stop violations and remove empty violations tables 
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  CreateViolations(tptr)
 *		  TableName *tptr;
 *
 * Arguments	: tptr 	- a TableName structure (see iimport.h)
 *
 * Description	: StopViolations checks if a table used for violations
 *		  and diagnostics contains rows, if not, the tables are
 *		  dropped. Otherwise, a report is generated with a rowcount
 *
 *
 * Returns	: IU_SUCCESS or status values on error
 *
 * See Also	: IURunSQL(3DB)
 *
 */

EXEC SQL include "iimport.h";

EXEC SQL BEGIN DECLARE SECTION;

PRIVATE
FINAL
char *select_id = "PPending";

PRIVATE
FINAL
char *select_cursor = "Ermintrude";

EXEC SQL END DECLARE SECTION; 

PUBLIC
status
StopViolations(tablename)
char *tablename;
{
    FINAL char *where = "iimport.MigrateDatabase.EnableRI.StopViolations";
    status retval;
    TargetTable t, *tptr = &t;

    EXEC SQL BEGIN DECLARE SECTION; 
    int count = 0;
    char sql_cmd[ MAX_SQL_BUF ];
    EXEC SQL END DECLARE SECTION;

    DEBUG("\nMODULE [ %s ]\n\n", where);

    if(tablename == (char *)NULL)
	return Error(IU_EINVALIDARG, "iimport.StopViolations:tablename", "74");

    if((retval = TargetTableName(tptr, tablename)) != IU_SUCCESS)
	return retval;

    sprintf(sql_cmd, "SELECT count(*) FROM %s", tptr->table_vio);

    EXEC SQL PREPARE :select_id  FROM :sql_cmd;

    if(IUCheck(sql_cmd) != IU_SUCCESS)
	return Error(IU_EPREPARE, "iimport.StopViolations.PREPARE", "84");

    EXEC SQL EXECUTE :select_id INTO :count;

    if(IUCheck(sql_cmd) != IU_SUCCESS)
	return Error(IU_EDECLARE, "iimport.StopViolations.EXECUTE", "89");

    EXEC SQL CLOSE :select_id;
    EXEC SQL FREE  :select_id;

    sprintf(sql_cmd, "STOP VIOLATIONS TABLE FOR %s", tablename); 

    retval = IURunSQL(sql_cmd, NULL, IGNORE);


    if(count == 0)
    {
	sprintf(sql_cmd, "DROP TABLE %s;", tptr->table_vio); 

	IURunSQL(sql_cmd, NULL, IGNORE);

	sprintf(sql_cmd, "DROP TABLE %s;", tptr->table_dia); 

	IURunSQL(sql_cmd, NULL, IGNORE);
    }
    else
    {
	global.has_violations += 1;

	printf("Violations Warning: Table %s has violations [ %d record%s",
	    tablename, (count == 1) ? "" : "s");
	
	printf(" in %s ]\n", tptr->table_vio);
    }

    return IU_SUCCESS;
}
