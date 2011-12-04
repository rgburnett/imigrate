/*
 * File		: StackTop.c
 * 
 * Sccs		: @(#)StackTop.c	1.2
 *
 * Dated	: 96/10/30 15:24:28 
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
char *sccsid = "SCCS: @(#)StackTop.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: StackTop - retrieve the top item on the stack and leave it intact
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  StackTop(stackptr, dataptr)
 *		  stack       *stackptr;
 *		  generic_ptr *dataptr;
 *
 * Arguments	: stackptr - the current stack
 *
 *		  dataptr - destination for the stack value
 *
 * Description	: StackTop looks at the top of the stack
 *
 * Returns	: IU_SUCCESS or IU_ERROR on error.
 *
 * See Also	: The Stack Series of functions
 *
 */

PUBLIC
status
StackTop(stackptr, dataptr)
stack       *stackptr;
generic_ptr *dataptr;
{
    extern status StackPush();
    extern status StackPop();

    if(StackPop(stackptr, dataptr) == IU_ERROR)
	return IU_ERROR;

    return StackPush(stackptr, dataptr);
}
