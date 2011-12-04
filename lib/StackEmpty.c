/*
 * File		: StackEmpty.c
 * 
 * Sccs		: @(#)StackEmpty.c	1.2
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
char *sccsid = "SCCS: @(#)StackEmpty.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 * Name 	: IsEmptyStack - is a stack empty
 *
 * Synopsis	:  PUBLIC
 * 		   int
 * 		   IsEmptyStack(stackptr)
 * 		   stack *stackptr;
 *
 * Arguments	: stackptr - a pointer to a stack object
 *
 * Description	: IsEmpytStack returns true of a stack is empty 
 *
 * Returns	: 0|1
 *
 * See Also	: The Stack series of functions
 *
 */


PUBLIC
int
IsEmptyStack(stackptr)
stack *stackptr;
{
    return (stackptr->top == stackptr->base) ? 1 : 0;
}
