/*
 * File		: ListEmpty.c
 * 
 * Sccs		: @(#)ListEmpty.c	1.2
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
char *sccsid = "SCCS: @(#)ListEmpty.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IsEmptyList - is this list structure empty
 *
 * Synopsis	: PUBLIC
 *		  int
 *		  IsEmptyList(L)
 *		  list L;
 *
 * Arguments	: L	- a list
 *
 * Description	: test to see whether a list is empty.
 *
 * Returns	: 1|0
 *
 * See Also	: The list series of functions
 */

PUBLIC
int
IsEmptyList(listptr)
list listptr;
{
    return (listptr == NULL) ? 1 : 0;
}
