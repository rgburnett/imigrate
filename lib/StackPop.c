/*
 * File		: StackPop.c
 * 
 * Sccs		: @(#)StackPop.c	1.2
 *
 * Dated	: 96/10/30 15:24:27 
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
char *sccsid = "SCCS: @(#)StackPop.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: StackPop - pop (get) the top value from the stack
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  StackPop(stackptr, dataptr)
 *		  stack       *stackptr;
 *		  generic_ptr *dataptr;
 *
 * Arguments	: stackptr - the stack
 *
 *		  dataptr - the returned stack value
 *
 * Description	: StackPop retrievies the top value from the stack.
 *
 * Notes	: A Stack can be "visualised" as a plate feeder in a 
 *		  restaurant.
 *
 * Returns	: status values of IU_SUCCESS or IU_ERROR on error.
 *
 * See Also	: The Stack series of functions
 *
 */

PUBLIC
status
StackPop(stackptr, dataptr)
stack       *stackptr;
generic_ptr *dataptr;
{
    if(IsEmptyStack((stack *)dataptr) == TRUE)
	return IU_ERROR;

    stackptr->top--;
    *dataptr = *stackptr->top;
    return IU_SUCCESS;
}
