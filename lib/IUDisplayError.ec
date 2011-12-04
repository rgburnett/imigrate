/*
 * File		: IUDisplayError.ec
 * 
 * Sccs		: @(#)IUDisplayError.ec	1.2
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
char *sccsid = "SCCS: @(#)IUDisplayError.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUDisplayError - print error message followed by sql state
 *
 * Synopsis	: PUBLIC
 *		  void
 *		  IUDisplayError(statement)
 *		  char *statement;
 *
 * Arguments	: statement - the offending sql statement
 *
 * Description	: IUDisplayError 
 *
 * Returns	: void
 *
 * See Also	: IUDisplaySQLStateError()
 *
 */

PUBLIC
void
IUDisplayError(statement)
char *statement;
{
    extern void IUDisplaySQLStateError();

    fprintf(stderr, "ERROR: %s\n", statement);
    IUDisplaySQLStateError();
}
