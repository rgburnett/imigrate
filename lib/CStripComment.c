/*
 * File		: CStripComment.c
 * 
 * Sccs		: @(#)CStripComment.c	1.2
 *
 * Dated	: 96/10/30 15:24:17 
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
char *sccsid = "SCCS: @(#)CStripComment.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: CStripComment - strip C style comments from a file
 *
 * Synopsis	: PUBLIC
 *		  void
 *		  CStripComment(instream, outstream)
 *		  FILE *instream;
 *		  FILE *outstream;
 *
 * Arguments	: instream - input FILE
 *		  outstream - output FILE
 *
 * Description	: This program was taken from Nigel Horspool's excellent book
 *		  "C Programming in the Berkeley Unix Environment".
 *
 * Returns	: void
 *
 * See Also	:
 *
 */

PUBLIC
void
CStripComment(instream, outstream)
FILE *instream;
FILE *outstream;
{
    int c;
    int ch;

    for(;;)
    {
	c = fgetc(instream);

	while(ch != '/' && ch != EOF)
	{
	    fputc(c, outstream);
	    ch = fgetc(instream);
	}

	if (ch == EOF)
	    break;

	ch = fgetc(instream);

	if(ch == '*')
	{
	    fputc(' ', outstream);

	    do
	    {
		do
		{
		    ch = fgetc(instream);

		} while (ch != '*' && ch != EOF);

		if (ch == EOF)
		    break;

		do
		{
		    ch = fgetc(instream);
		}
		while(ch == '*');
	    }
	    while(ch != '/' && ch != EOF);
	}
	else
	    putchar('/');

	if(ch == EOF)
	    break;
    }
}
