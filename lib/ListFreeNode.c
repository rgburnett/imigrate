/*
 * File		: ListFreeNode.c
 * 
 * Sccs		: @(#)ListFreeNode.c	1.2
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

#include <malloc.h>

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)ListFreeNode.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: ListFreeNode - free a node on a list
 *
 * Synopsis	: PUBLIC
 *		  void
 *		  ListFreeNode(listptr)
 *		  list *listptr;
 *
 * Arguments	: listptr - a list
 *
 * Description	: ListFreeNode frees a node on a list
 *
 * Returns	: void
 *
 * See Also	: The list series of functions
 *
 */

PUBLIC
void
ListFreeNode(listptr)
list *listptr;
{
    free(*listptr);
    *listptr = NULL;
}
