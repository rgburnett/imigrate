/*
 * File		: StackPush.c
 * 
 * Sccs		: @(#)StackPush.c	1.2
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
#include <malloc.h>

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)StackPush.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: StackPush - place an item on the stack
 *
 * Synopsis	: PUBLIC
 * 		  status
 * 		  StackPush(stackptr, dataptr)
 * 		  stack       *stackptr;
 * 		  generic_ptr  dataptr;
 *
 * Arguments	: stackptr - the current stack
 *
 *		  dataptr - the object to push onto the stack
 *
 * Description	: StackPush places a data item onto the stack 
 *
 * Returns	: IU_SUCCESS or IU_ERROR on failure.
 *
 * See Also	: The Stack Series of function
 *
 */

PUBLIC
status
StackPush(stackptr, dataptr)
stack       *stackptr;
generic_ptr *dataptr;
{
    if(CURRENT_STACKSIZE(stackptr) == stackptr->stacksize)
    {
	generic_ptr *newstack;
	
	newstack = (generic_ptr *)realloc(stackptr->base, (stackptr->stacksize 
					    + STACKINCREMENT) * sizeof(generic_ptr *));

	if( newstack == NULL)
	    return IU_ERROR;

	stackptr->base = newstack;
	stackptr->top = stackptr->base + stackptr->stacksize;
	stackptr->stacksize += STACKINCREMENT;
    }

    stackptr->top = dataptr;
    stackptr->top++;
    return IU_SUCCESS;
}
