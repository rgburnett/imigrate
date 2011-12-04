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
list glist;
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
	
	if(ListAppend(glist, (generic_ptr ) ptr) != IU_SUCCESS)
	    printf("Error %d", i);

    }
}
