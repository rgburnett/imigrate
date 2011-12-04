/*
 * File		: IUDirectory.c
 * 
 * Sccs		: @(#)IUDirectory.c	1.2
 *
 * Dated	: 96/10/30 15:24:19 
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

#include <sys/dir.h>

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)IUDirectory.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUDirectory - return a directory listing
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  IUDirectory(alist, path)
 *		  list *alist;
 *		  char *path;
 *
 * Arguments	: alist - pointer to a list structure
 *
 * 		  path - the name of the directory you wish to list
 *
 * Description	: 
 *
 * Notes	: It would have been nice to use the scandir(3) routine
 *		  to perform this but I couldn't get it to work with a
 *		  variable number of directory entries.
 *
 *		  Eventually sorting will be added into this.
 * Returns	:
 *
 * See Also	:
 *
 */

PUBLIC
status
IUDirectory(alist, directory)
list *alist;
char *directory;
{
    DIR *sourcedir;
    struct dirent *dp;
    struct dirent *ptr;

    if((sourcedir = opendir(directory)) == (DIR *)NULL)
	return Error(errno, directory, "40");

    for (dp = readdir(sourcedir); dp != (struct dirent *)NULL; 
						    dp = readdir(sourcedir))
    {

	if((ptr = (struct dirent *)malloc(sizeof(struct dirent))) 
						== (struct dirent *)NULL)
	    return Error(errno, "IUDirectory: malloc", "48");

	strcpy(ptr->d_name, dp->d_name);
	
	if(ListInsert(alist, (generic_ptr)ptr) == IU_ERROR)
	    return Error(IU_ERROR, "IUListTables: List Insertion failure\n", "53");
    }

    if(closedir(sourcedir) == -1)
	return Error(errno, directory, "57");

    return IU_SUCCESS;
}

#ifdef TEST

main()
{
    list glist, lptr;

    ListInitialise(&glist);

    IUDirectory(&glist, "/tmp");

    for (lptr = glist; NEXT(lptr); lptr = NEXT(lptr))
	printf("%s\n", ((struct dirent *)(DATA(lptr)))->d_name);

    IUDirectory(&glist, "/bert");
}

#endif
