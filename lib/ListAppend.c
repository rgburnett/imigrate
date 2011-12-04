/*
 * File		: ListAppend.c
 * 
 * Sccs		: @(#)ListAppend.c	1.2
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

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)ListAppend.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: ListAppend - append an item to the end of a list
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  ListAppend(listptr, data)
 *		  list       *listptr;
 *		  generic_ptr data;
 *
 * Arguments	: listptr - a pointer to a list structure
 *
 * 		  data	- pointer to the item to be appended
 *
 * Description	: ListAppend appends an item to the list  
 *
 * Returns	: IU_SUCCESS on success, IU_ERROR on failure.
 *
 * See Also	: The List Series of functions
 *
 */

PUBLIC
status
ListAppend(listptr, data)
list       *listptr;
generic_ptr data;
{
    list L;
    register list tmplist;

    if(ListAllocateNode(&L, data) != IU_SUCCESS)
	return IU_ERROR;

    if(IsEmptyList(*listptr) == 1)
	*listptr = L;
    else
    {
	for(tmplist = *listptr; NEXT(tmplist) != NULL; tmplist = NEXT(tmplist))
	    ;

	NEXT(tmplist) = L;
    }
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

printf("--------------\n");

    for (lptr = glist; DATA(lptr); lptr = NEXT(lptr))
    {
	struct fred *t;

	printf("%d lptr %d *lptr\n", lptr, *lptr);
	printf("%d\n", NEXT(lptr));

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

    for(i = 0; i < 3; i++)
    {

	if((ptr = (struct fred *)malloc(sizeof(struct fred))) == NULL)
	{
	    perror("malloc");
	    exit(0);
	}

	sprintf(ptr->text, "String 1 %d\n", i);
	sprintf(ptr->text1, "String 2 %d\n", i);
	sprintf(ptr->text3, "String 3 %d\n", i);
	
	if(ListAppend(glist, (generic_ptr) ptr) != IU_SUCCESS)
	    printf("Error %d", i);

    }
}

#endif
