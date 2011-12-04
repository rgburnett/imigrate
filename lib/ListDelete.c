/*{{ FUNCDOC
 *
 * Name 	: ListDelete - Delete an item from a list
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  ListDelete(listptr, dataptr)
 *		  list *listptr;
 *		  generic_ptr *dataptr;
 *
 * Arguments	: listptr - the list you are deleting from
 *
 *		  dataptr - data area of item to delete
 *
 * Description	: ListDelete deletes an item from a list
 *
 * Returns	: status of IU_SUCCESS or IU_ERROR on failure
 *
 * See Also	: The List Series of functions
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
char *sccsid = "SCCS @(#)ListDelete.c	1.2 : Continuus Project: %subsystem% %filespec%";

PUBLIC
status
ListDelete(listptr, dataptr)
list *listptr;
generic_ptr *dataptr;
{
    extern status ListDeleteNode();

    if(IsEmptyList(*listptr))
	return IU_ERROR;

    *dataptr = DATA(*listptr);

    return ListDeleteNode(listptr, *listptr);
}
