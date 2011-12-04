/*
 * File		: TargetTableName.ec
 * 
 * Sccs		: @(#)TargetTableName.ec	1.2
 *
 * Dated	: 96/10/24 14:43:51 
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
 * Name 	: TargetTableName - populate the MigrateTable structure 
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  TargetTableName(tptr, tablename)
 *		  TargetTable *tptr;
 *		  char	      *tablename;
 *
 * Arguments	: tptr		- A TargetTable structure.
 *
 *		  tablename	- name of a table.
 *
 * Description	: TargetTableName constructs the names of the tables which
 *		  will hold violations and diagnostics
 *
 * Returns	: void
 *
 * See Also	: ancestors.
 *
 */

EXEC SQL include "iimport.h";

PRIVATE
char *sccsid = "SCCS: @(#)TargetTableName.ec	1.2 Continuus: %subsystem: % %filespec: %";

PUBLIC
status
TargetTableName(tptr, tablename)
TargetTable *tptr;
char        *tablename;
{
    FINAL char *where = "iimport.MigrateDatabase.CreateViolations.TargetTableName";

	DEBUG("\nMODULE [ %s ]\n\n", where);

    if(tptr == (TargetTable *)NULL)
    {
	return Error(IU_EINVALIDARG, where, "61");
    }
    else if ( tablename == (char *)NULL || *tablename == '\0')
	return Error(IU_EINVALIDARG, where, "64");

    strcpy(tptr->shortname, tablename);

    if(strlen(tptr->shortname) > (TABLENAMELEN - 5))
    {
	sprintf(tptr->table_vio, "%.14s_vio", tptr->shortname);
	sprintf(tptr->table_dia, "%.14s_dia", tptr->shortname);
    }
    else
    {
	strcpy(tptr->table_vio, tptr->shortname);
	strcpy(tptr->table_dia, tptr->shortname);
	strcat(tptr->table_vio, "_vio");
	strcat(tptr->table_dia, "_dia");
    }

    DEBUG("TableName [ %s ] Violations [ %s ] Diagnostics [ %s ]\n",
	tptr->shortname, tptr->table_vio, tptr->table_dia);

    return IU_SUCCESS;
}
