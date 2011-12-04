/*
 * File		: ListInitialise.c
 * 
 * Sccs		: @(#)ListInitialise.c	1.2
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
char *sccsid = "SCCS: @(#)ListInitialise.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: ListInitialise - initialise a list object
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  ListInitialise(listptr)
 *		  list *listptr;
 *
 * Arguments	: listptr - a pointer to a list
 *
 * Description	: Set a list pointer to NULL
 *
 * Returns	: IU_SUCCESS
 *
 * See Also	: The List series of functions
 *
 */

PUBLIC
status
ListInitialise(listptr)
list *listptr;
{
    *listptr = NULL;
    return IU_SUCCESS;
}
