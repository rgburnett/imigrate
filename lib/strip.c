/*
 * File		: strip.c
 * 
 * Sccs		: @(#)strip.c	1.2
 *
 * Dated	: 96/10/30 15:24:30 
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
#include <ctype.h>

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)strip.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: strip - remove spaces at the end of a string
 *
 * Synopsis	: PUBLIC
 *		  char *
 *		  strip(s)
 *		  char *s;
 *
 * Arguments	: s - a string to strip
 *
 * Description	: s strips spaces at the end of a string 
 *
 * Returns	: the string passed.
 *
 * See Also	:
 *
 */

PUBLIC
char *
strip(s)
char *s;
{
    register char *ptr = s;

    while(*ptr)
	ptr++;
    ptr--;

    while(isspace(*ptr))
	ptr--;
    
    *++ptr = '\0';

    return s;
}
