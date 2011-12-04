/*
 * File		: IUDisplayWarning.ec
 * 
 * Sccs		: @(#)IUDisplayWarning.ec	1.2
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
char *sccsid = "SCCS: @(#)IUDisplayWarning.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUDisplayWarning - Display a warning message from a statement
 *
 * Synopsis	: void IUDisplayWarning(statement)
 *
 * Arguments	: statement	- the statement that already caused the warning.
 *
 * Description	: IUDisplayWarning calls IUDisplaySQLStateError, prefixing the
 *		  call by a "warning"
 *
 * See Also	: IUDisplaySQLStateError(3DB); 
 *
 * Sccs 	: @(#)IUDisplayWarning.ec	1.2 
 *
 * Continuus 
 * Project	: %subsystem% %filespec%";
 */

PUBLIC
void
IUDisplayWarning(statement)
char *statement;
{
    extern void IUDisplaySQLStateError();

    fprintf(stderr, "Warning: %s\n", statement);
    IUDisplaySQLStateError();
}
