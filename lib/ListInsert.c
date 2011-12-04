/*
 * File		: ListInsert.c
 * 
 * Sccs		: @(#)ListInsert.c	1.2
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
char *sccsid = "SCCS: @(#)ListInsert.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: ListInsert - insert a data item into a list
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  ListInsert(listptr, data)
 *		  list       *listptr;
 *		  generic_ptr data;
 *
 * Arguments	: listptr - a list 
 *
 *		  data - a pointer to a data item to insert
 *
 * Description	: ListInsert adds an item to a list. 
 *
 * Returns	: status of IU_SUCCESS or IU_ERROR on error
 *
 * See Also	: The List series of functions
 *
 * Examples
 *
 *	if(ListInsert(&alist, (generic_ptr *)ptr) == ERROR)
 *	   printf("Error %d", i);
 *
 */

PUBLIC
status
ListInsert(listptr, data)
list       *listptr;
generic_ptr data;
{
    list L;

    extern status ListAllocateNode();

    if(ListAllocateNode(&L, data) != IU_SUCCESS)
	return IU_ERROR;

    NEXT(L) = *listptr;

    *listptr = L;
    return IU_SUCCESS;
}


#ifdef TEST


#include <stdio.h>
#include <malloc.h>
#include "error.h"
#include "libproto.h"

struct fred {
    char text[ 100 ];
    char text1[ 100 ];
    char text3[ 100 ];
};

main()
{

    list glist = NULL, lptr;

    f(&glist);

    for (lptr = glist; NEXT(lptr); lptr = NEXT(lptr))
    {
	struct fred *t;

	printf("%s\n", ((struct fred *)DATA(lptr))->text);
	printf("%s\n", ((struct fred *)DATA(lptr))->text1);
	printf("%s\n", ((struct fred *)DATA(lptr))->text3);
    }

    exit(0);

}

f(glist)
list *glist;
{
    int i;
    struct fred *ptr;

    for(i = 0; i < 2; i++)
    {

	if((ptr = (struct fred *)malloc(sizeof(struct fred))) == NULL)
	{
	    perror("malloc");
	    exit(0);
	}

	sprintf(ptr->text, "String 1 %d\n", i);
	sprintf(ptr->text1, "String 2 %d\n", i);
	sprintf(ptr->text3, "String 3 %d\n", i);
	
	if(ListInsert(glist, (generic_ptr)ptr) != IU_SUCCESS)
	    printf("Error %d", i);

    }
}

#endif
