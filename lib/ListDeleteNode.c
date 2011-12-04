/*
 * File		: ListDeleteNode.c
 * 
 * Sccs		: @(#)ListDeleteNode.c	1.2
 *
 * Dated	: 96/10/30 15:24:25 
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
char *sccsid = "SCCS: @(#)ListDeleteNode.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: ListDeleteNode - Delete a node from a list
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  ListDeleteNode(listptr, nodetodelete)
 *		  list *listptr;
 *		  list nodetodelete;
 *
 * Arguments	: listptr - the list to delete the node from
 *
 *		  nodetodelete - the node to delete
 *
 * Description	: ListDeleteNode deletes a node from a list structure. 
 *
 * Returns	: status of IU_SUCCESS or IU_ERROR on failure.
 *
 * See Also	: The List series of functions
 *
 */

PUBLIC
status
ListDeleteNode(listptr, nodetodelete)
list *listptr;
list nodetodelete;
{
    if(IsEmptyList(*listptr) == 1)
	return IU_ERROR;

    if( *listptr == nodetodelete )
	*listptr = NEXT(*listptr);
    else
    {
	list L;

	/*
	 * Traverse the list looking for the node
	 */

	for(L = *listptr; L != NULL && NEXT(L) != nodetodelete; L = NEXT(L))
	    ;

	if(L == NULL)
	    return IU_ERROR;
	else
	    NEXT(L) = NEXT(nodetodelete);
    }

    free(&nodetodelete);

    return IU_SUCCESS;
}
