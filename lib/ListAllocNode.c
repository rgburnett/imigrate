/*
 * File		: ListAllocNode.c
 * 
 * Sccs		: @(#)ListAllocNode.c	1.2
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
#include "c.defs.h"
#include "c.class.h"
#include "error.class.h"
#include "c.proto.h"
#include "global.h"
#include <malloc.h>

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)ListAllocNode.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: ListAllocateNode - allocate space for a node in a linked list
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  ListAllocateNode(listptr, data)
 *		  list       *listptr;
 *
 * Arguments	: listptr - a pointer to a "list" structure
 *
 *		  data - a pointer to a data item. This could be a structure,
 *			 string, int etc etc.
 *
 * Description	: ListAllocateNode allocates the memory for a new node
 *		  in a linked list.
 *
 * Returns	: IU_SUCCESS on success or IU_ERROR on failure.
 *
 * See Also	: The List series of functions.
 *
 */

PUBLIC
status
ListAllocateNode(listptr, data)
list       *listptr;
generic_ptr data;
{
    list L;
    
    if((L = (list)malloc(sizeof(node))) == (list)NULL)
	return Error(errno, "ListAllocateNode.malloc", "66");

    *listptr = L;

    DATA(L) = data;
    NEXT(L) = NULL;

    return IU_SUCCESS;
}
