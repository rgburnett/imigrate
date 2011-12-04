/*
 * File		: CreateViolations.ec
 * 
 * Sccs		: @(#)CreateViolations.ec	1.4
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

/*
 *
 * Name 	: CreateViolations - create violations and diagnostic tables 
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  CreateViolations(tablename)
 *		  char *tablename;
 *
 * Arguments	: tablename - name of the table to start violations for 
 *
 * Description	: CreateViolations prepares a table for the collection of
 *		  violations and diagnostics tables. It drops any existing
 *		  violations tables before attempting to start violations.
 *
 * Returns	: IU_SUCCESS or status values on error
 *
 * See Also	: IURunSQL(3DB), IUListTables(3DB)
 *
 */

PUBLIC
status
CreateViolations(tablename)
char *tablename;
{
    FINAL char *where = "iimport.MigrateDatabase.CreateViolations";
    TargetTable t, *tptr = &t;
    char sql_cmd[ MAX_SQL_BUF ];
    status retval;

    DEBUG("\nMODULE [ %s ]\n\n", where);

    bzero(tptr, sizeof(TargetTable));

    TargetTableName(tptr, tablename);

    sprintf(sql_cmd, "STOP VIOLATIONS TABLE FOR %s", tptr->shortname); 

    IURunSQL(sql_cmd, stdout, IGNORE);

    sprintf(sql_cmd, "DROP TABLE %s;", tptr->table_vio); 

    IURunSQL(sql_cmd, stdout, IGNORE);

    sprintf(sql_cmd, "DROP TABLE %s;", tptr->table_dia); 

    IURunSQL(sql_cmd, stdout, IGNORE);

    sprintf(sql_cmd, "START VIOLATIONS TABLE FOR %s MAX ROWS %d", tptr->shortname,
							global.max_vio_rows); 


    return IURunSQL(sql_cmd, stdout, REPORT);
}
