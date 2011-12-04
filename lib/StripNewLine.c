/*
 * File		: StripNewLine.c 
 * 
 * Sccs		: @(#)StripNewLine.c	1.1
 *
 * Dated	: 96/10/30 15:24:28 
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
char *sccsid = "SCCS: @(#)StripNewLine.c	1.1 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: StripNewLine - Strip new lines from end of a string 
 *
 * Synopsis	: PUBLIC
 *		  void
 *		  StripNewLine(string)
 *		  char *string;
 *
 * Arguments	: string - string to strip
 *
 * Description	: StripNewLine is used to strip the annoying new line at
 *		  the end of the string returned by ctime(3)
 *
 * Returns	: void 
 *
 * See Also	:
 *
 */

PUBLIC
char *
StripNewLine(string)
char *string;
{
    register char *ptr;
    int ch;

    if ( string == (char *)NULL || *string == '\0')
	return;

    for(ptr = string; *ptr; ptr++)
	;

    ptr--;

    while(isspace(*ptr))
	ptr--;

    *(ptr + 1) = '\0';

    return string;
}

#ifdef TEST

main()
{
    long t;
    char *string1 = "blah blah \n\n   \n\n";
    char *string2 = "blah blah";
    char *string3 = "   		   \n\n";

    time(&t);

    printf("Time [%s]\n", ctime(&t));
    printf("Time [%s]\n", StripNewLine(ctime(&t)));
    printf("String [%s]\n", StripNewLine(string1));
    printf("String [%s]\n", StripNewLine(string2));
    printf("String [%s]\n", StripNewLine(string3));
    printf("String [%s]\n", StripNewLine((char *)NULL));
    printf("String [%s]\n", StripNewLine(""));

    exit(1);
}

#endif
