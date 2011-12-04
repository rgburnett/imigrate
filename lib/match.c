/*
 * File		: match.c
 * 
 * Sccs		: @(#)match.c	1.2
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
#include <regex.h>

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)match.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: match - check if a string contains a regular expression 
 *
 * Synopsis	: PUBLIC
 *		  int 
 *		  match(string, pattern)
 *		  char *string;
 *		  char *pattern;
 *
 * Arguments	: string - the string in which you are searching
 *
 *		  pattern - the regular expression you are matching.
 *
 * Description	: match checks whether a string contains a user defined regular
 *		  expression.
 *
 * Notes	: Not very efficient.
 *
 * See Also	: 
 *
 */

PUBLIC
int
match(string, pattern)
char *string;
char *pattern;
{
    int     status;
    regex_t re;

    if (regcomp(&re, pattern, REG_EXTENDED|REG_NOSUB) != 0)  
    {
	return 0;
    }

    status = regexec(&re, string, (size_t) 0, NULL, 0);

    regfree(&re);

    return (status != 0) ? 0 : 1;
}

#ifdef TEST

main()
{
    if(match("\n\nasdf asdf\ncreate procedure blah \n\nasdf asdf \n\nend procedure;\nasdf", "end procedure;"))
    {
	printf("Matched hello");
    }
    else
    {
	printf("Cannot find hello\n");
    }
}

#endif
