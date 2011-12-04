/*
 * File		: IUCheck.ec
 * 
 * Sccs		: @(#)IUCheck.ec	1.2
 *
 * Dated	: 96/10/30 15:24:17 
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


#include "c.incl.h"
#include "c.defs.h"
#include "c.class.h"
#include "error.class.h"
#include "c.proto.h"
#include "global.h"


PRIVATE
FINAL
char *sccsid = "SCCS: @(#)IUCheck.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUCheck - check an sql statement for errors
 *
 * Synopsis	: char *IUCheck(statement)
 *		  char *statement;
 *		  sqlerrors report;
 *
 * Arguments	: <statement>	a buffer into which the dml statment is placed
 *
 *		  <sqlerrors>   REPORT - report errors
 *				IGNORE - ignore errors
 *				REPORTWARNINGS - also report warnings.
 *
 * Description	: Short dbaccess type error checking routine. 
 *
 * See Also	: IURunSQL()
 *
 * Sccs 	: @(#)IUCheck.ec	1.2 
 *
 * Continuus 
 * Project	: %subsystem% %filespec%";
 */


PUBLIC
status
IUCheck(statement)
char *statement;
{
    char *ptr;
    status sqlerr_code = IU_ERTERROR;

    extern void IUDisplayShortError();
    extern status IUSQLStateError();

    sqlerr_code = IUSQLStateError();

    ptr = (statement == (char *)NULL) ? "IUCheck: unknown statement" : statement;

    if(sqlerr_code == IU_ERTERROR)
    {
	if( linecount > 0)
	    fprintf(stderr, "ERROR at line %d, Statement [ %s ]\n", 
		linecount, ptr);
	fprintf(stderr, "%s\n", ptr);
	IUDisplayShortError();
    }

    return sqlerr_code;
}
