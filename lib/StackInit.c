/*
 * File		: StackInit.c
 * 
 * Sccs		: @(#)StackInit.c	1.2
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
char *sccsid = "SCCS: @(#)StackInit.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: StackInitialise - Initialise a stack object
 *
 * Synopsis	: PUBLIC
 * 		  status
 * 		  StackInitialise(stackptr)
 * 		  stack *stackptr;
 *
 * Arguments	: stackptr - a pointer to a stack object
 *
 * Description	: StackInitialise allocates memory for a stack object and
 *		  sets the initial pointers to the top and base of the stack
 *
 * Returns	: IU_SUCCESS on successs or IU_ERTERROR on error
 *
 * See Also	: The Stack series of functions
 *
 */

PUBLIC
status
StackInitialise(stackptr)
stack *stackptr;
{
    stackptr->base = (generic_ptr *)malloc(STACKINCREMENT * sizeof(generic_ptr));

    if(stackptr->base == NULL)
	return IU_ERROR;

    stackptr->top = stackptr->base;
    stackptr->stacksize = STACKINCREMENT;

    return IU_SUCCESS;
}
