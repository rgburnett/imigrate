/*{{ FUNCDOC 3
 *
 * Name 	: hash - return a hash value for a string
 *
 * Synopsis	: PUBLIC
 *		  int
 *		  hash(string)
 *		  register char *string;
 *
 * Arguments	: string - the string to return a hash value for.
 *
 * Description	: hash returns a value between NBUCKETS - 1 and 0.
 *
 * Returns	: hash returns a value between NBUCKETS - 1 and 0.
 *
 * See Also	: 
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
char *sccsid = "SCCS @(#)hash.c	1.2 : Continuus Project: %subsystem% %filespec%";

PUBLIC
int
hash(word)
register char *word;
{
    register int len = strlen(word);
    return ((*word * 379 + *(word + (len - 1)) * 73 + len) & (NBUCKETS -1));
}
