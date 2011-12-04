/*
 * File		: IUDisplayException.ec
 * 
 * Sccs		: @(#)IUDisplayException.ec	1.2
 *
 * Dated	: 96/10/30 15:24:19 
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
char *sccsid = "SCCS: @(#)IUDisplayException.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUDisplayException - check SQLCODE for success/warning or error
 *
 * Synopsis	: PUBLIC
 *		  void
 *		  IUDisplayException(statement, sqlerr_code, warn_flag)
 *		  char *statement;
 *		  int sqlerr_code;
 *		  int warn_flag;
 *
 * Arguments	: statement - the SQL statement being checked
 *
 *		  sqlerr_code - the sql code from SQLCODE
 *
 *		  warn_flag - boolean - if we want warnings displayed 
 *
 * Description	: IUDisplayException is called after a call to IUSQLStateError
 *		  which sets the sqlerr_code parameter. If there are any
 *		  errors the IUDisplayError is called.
 *
 *		  If we want to display warnings (for example if no rows were
 *		  returned) then we set warn_flag to non zero and call 
 *		  IUDisplayWarning()
 *
 * Returns	: void
 *
 * See Also	: IUDisplayError(), IUDisplayWarning(), IUSQLStateError()
 *
 */

PUBLIC
void
IUDisplayException(statement, sqlerr_code, warn_flag)
char *statement;
int sqlerr_code;
int warn_flag;
{
    switch(sqlerr_code)
    {
	case IU_SUCCESS:
	case IU_NODATA:
	    break;

	case IU_WARNING:
	    if(warn_flag)
		IUDisplayWarning(statement);
	    break;

	case IU_ERTERROR:
	    IUDisplayError(statement);
	    break;

	default:
	    printf("INVALID EXCEPTION FOR STATE %s\n", statement);
	    break;
    }	
}
