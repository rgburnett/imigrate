/*
 * File		: ListDestroy.c
 * 
 * Sccs		: @(#)ListDestroy.c	1.2
 *
 * Dated	: 96/10/30 15:24:26 
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
char *sccsid = "SCCS: @(#)ListDestroy.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: ListDestroy - destroy a linked list of objects
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  ListDestroy(listptr)
 *		  list *listptr;
 * 
 * Arguments	: listptr - The list you wish to destroy
 *
 * Description	: ListDestroy is a recursive function for enabling the correct
 *		  deallocation of resources held by a list
 *
 * Returns	: status of IU_SUCCESS or IU_ERTERROR on error
 *
 * See Also	: ListDestroy(), ListFreeNode()
 *
 * Examples	:
 *		  list alist;
 *
 *		  ListDestroy(&alist);
 */

PUBLIC
status
ListDestroy(listptr)
list *listptr;
{
    if(IsEmptyList(*listptr) == FALSE)
    {
	ListDestroy(&NEXT(*listptr));
	(void) free(DATA(*listptr));
	ListFreeNode(listptr);
    }
    return IU_SUCCESS;
}
