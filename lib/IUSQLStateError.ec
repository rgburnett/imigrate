/*
 * File		: IUSQLStateError.ec
 * 
 * Sccs		: @(#)IUSQLStateError.ec	1.2
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

#include "c.incl.h"
#include "c.defs.h"
#include "c.class.h"
#include "error.class.h"
#include "c.proto.h"
#include "global.h"

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)IUSQLStateError.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUSQLStateError - Check the SQLSTATE structure for an error 
 *
 * Synopsis	: int IUSQLStateError()
 *
 * Arguments	: none
 *
 * Description	: Checks the SQLSTATE array in sqlca for an error.
 *
 * Returns	: IU_SUCCESS, IU_ERTERROR on failure or IU_NODATA on no data
 * See Also	:
 *
 * Sccs 	: @(#)IUSQLStateError.ec	1.2 
 *
 * Continuus 
 * Project	: %subsystem% %filespec%";
 */

PUBLIC
status
IUSQLStateError()
{
    status err_code = IU_ERTERROR;

    if(SQLSTATE[0] == '0')
    {
	switch(SQLSTATE[1])
	{
	    case '0':
		err_code = IU_SUCCESS;
		break;
	    case '1':
		err_code = IU_WARNING;
		break;
	    case '2':
		err_code = IU_NODATA;
		break;
	    default:
		break;
	}
    }

    return err_code;
}
