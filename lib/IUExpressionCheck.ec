/*
 * File		: IUExpressionCheck.ec
 * 
 * Sccs		: @(#)IUExpressionCheck.ec	1.2
 *
 * Dated	: 96/10/30 15:24:20 
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
char *sccsid = "SCCS: @(#)IUExpressionCheck.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUExpressionCheck - Full error checking of a dml statement
 *
 * Synopsis	: PUBLIC
 *		  char *IUExpressionCheck(statement, warn_flag)
 *		  char *statement;
 *		  int warn_flag;	
 *
 * Arguments	: statement - an sql statement
 *
 *		  warn_flag - whether warnings are required
 *
 * Description	: Full error checking of a dml statement. This produces a 
 *		  very verbose output and full diagnostics. Generally not used.
 *
 * Returns	: status value of IU_SUCCESS or IU_ERTERROR
 *
 * See Also	: IUDisplayException(), IUSQLStateError(), IUDisplayShortError()
 *
 * Sccs 	: @(#)IUExpressionCheck.ec	1.2 
 *
 * Continuus 
 * Project	: %subsystem% %filespec%";
 */

PUBLIC
status
IUExpressionCheck(statement, warn_flag)
char *statement;
int warn_flag;
{
    status sqlerr_code = IU_SUCCESS;

    extern void IUDisplayException();
    extern status IUSQLStateError();

    sqlerr_code = IUSQLStateError();

    IUDisplayException(statement, sqlerr_code, warn_flag);

    if(sqlerr_code == IU_ERTERROR)
	fprintf(stderr, "IUExpressionCheck: Aborted\n");

    return sqlerr_code;
}
