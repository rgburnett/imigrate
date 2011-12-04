/*
 * File		: IURunSQL.ec
 * 
 * Sccs		: @(#)IURunSQL.ec	1.2
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

/*{{ FUNCDOC 3
 *
 * Name 	: IURunSQL - run an sql command 
 *
 * Synopsis	: char *IURunSQL(dmlstatement, output, report)
 *		  char *dmlstatement;	
 *		  sqlerrors report;
 *
 * Arguments	: dmlstatement	- a buffer into which contains a dml statment
 *
 *		  output	- optional echoing of data to a FILE stream.
 *
 *		  report	- whether to REPORT errors or IGNORE them
 *
 * Description	: IURunSQL executes an sql statement and optionally checks for errors.
 *
 *		  The statements can optionally be sent to a FILE stream, or NULL if
 *		  no echoing is required.
 *
 * Returns	: IU_SUCCESS or IU_ERTERROR on error.
 *
 * See Also	: IUCheck(3DB)
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
#include "error.class.h"
#include "c.proto.h"
#include "global.h"

EXEC SQL BEGIN DECLARE SECTION; 

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)IURunSQL.ec	1.2 Continuus: %subsystem: % %filespec: %";

PRIVATE
FINAL
char *statement_id = "iurun_id";

EXEC SQL END DECLARE SECTION; 

PUBLIC
status
IURunSQL(dmlstatement, output, report)
EXEC SQL BEGIN DECLARE SECTION;
char *dmlstatement;
EXEC SQL END DECLARE SECTION;
FILE *output;
sqlerrors report;
{
    status retval = IU_SUCCESS;

    if(output != (FILE *)NULL)
	fprintf(output, "%s\n", dmlstatement);

    EXEC SQL PREPARE :statement_id FROM :dmlstatement;

    if(report != IGNORE)
	if(IUCheck(dmlstatement) != IU_SUCCESS)
	    return IU_ERTERROR;

    IUTransaction(BEGINWORK);

    EXEC SQL EXECUTE :statement_id;

    if(report != IGNORE)
	if(IUCheck(dmlstatement) != IU_SUCCESS)
	    retval = IU_ERTERROR;

    IUTransaction(COMMITWORK);

    EXEC SQL FREE :statement_id;

    return retval;
}

#ifdef TEST

main()
{
    status retval;

    EXEC SQL DATABASE "stores7";

    if(( retval = IURunSQL("create table bert ( fred char(1) );", stdout, REPORT)) != IU_SUCCESS)
    {
	Error(retval, "main.IURunSQL: couldn't create table bert ", "116");
	EXEC SQL DISCONNECT ALL;
	exit(1);
    }

    pause();

    if(( retval = IURunSQL("drop table bert;", stdout, REPORT)) != IU_SUCCESS)
    {
	Error(retval, "main.IURunSQL: couldn't drop table bert ", "125");
	EXEC SQL DISCONNECT ALL;
	exit(1);
    }
    exit(0);
}

#endif
