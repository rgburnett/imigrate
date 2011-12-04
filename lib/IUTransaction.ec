/*
 * File		: IUTransaction.ec
 * 
 * Sccs		: @(#)IUTransaction.ec	1.1
 *
 * Dated	: 96/10/30 15:24:24 
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
EXEC SQL include "esql.incl.h";
#include "c.defs.h"
EXEC SQL include "esql.defs.h";
#include "c.class.h"
EXEC SQL include "esql.class.h";
#include "error.class.h"
#include "c.proto.h"
EXEC SQL include "esql.proto.h";
#include "global.h"

PRIVATE
char *sccsid = "SCCS: @(#)IUTransaction.ec	1.1 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC
 *
 * Name 	: IUTransaction - begin or end a transaction. 
 *
 * Synopsis	: IUTransaction(op)
 *		  int	op;
 *
 * Arguments	: op - type of operation - BEGINWORK, ENDWORK or ROLLBACKWORK
 *
 * Description	: IUTransaction begins and ends transactions transparent
 *		  of the logging mode of the database.
 *		  
 * Returns	: status values
 *
 * See Also	:
 *
 */

PUBLIC
status
IUTransaction(op)
int op;
{
    if(database_has_logging == TRUE)
    {
	switch(op)
	{
	    case BEGINWORK:
		if(database_is_ansi)
		    return IU_SUCCESS;

		EXEC SQL BEGIN WORK;
		break;

	    case COMMITWORK:
		EXEC SQL COMMIT WORK;
		break;

	    case ROLLBACKWORK:
		EXEC SQL ROLLBACK WORK;
		break;

	    default:
		return Error(IU_EINVALIDARG, "IUTransaction.op", "78");
	}

	if(IUCheck("BEGIN/END/ROLLBACK WORK") != IU_SUCCESS)
	    return Error(IU_ESTARTTRANS, "IUTransaction: BEGIN", "82");
    }
    return IU_SUCCESS;
}
