/*
 * File		: Error.ec
 * 
 * Sccs		: @(#)Error.c	1.1
 *
 * Dated	: 96/10/15 11:38:48 
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
char *sccsid = "SCCS: @(#)Error.c	1.1 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: Error - print error number and text 
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  Error(type, module, lineno)
 *		  int type;
 *		  int lineno;
 *
 * Arguments	: type - either an errno for Unix errors or an status code for
 *			 runtime esqlc/database errors.
 * 		  
 *		  module - the name of the calling module
 *
 *		  lineno - the line number of the module.
 *
 * Description	: Error is a general error handling routine which reports
 *		  both unix errors (via the errno mechanism) and runtime
 *		  sql messages.
 *
 *		  Error also reports the module and line number from where
 *		  the error was reported.
 *
 * Notes	: May add an optional  output stream - but you should really
 *		  either freopen or dup the fd earlier on.
 *
 * Error Codes	: returns status values as passed.
 *
 * See Also	: errno.h
 */

PUBLIC
status
Error(type, module, lineno)
status	type;
char *module;
char *lineno;
{
    char *error = (1000 <= type) ? "IU_ESQL/C_ERROR: " : "IU_UNIX_ERROR";
    char *msgptr;

    if( type < IU_MESGBASE )
    {
	fprintf(stderr, "%s: [ %s:%s ] [ %s %d ]\n", 
	    error, module, lineno, sys_errlist[ type ], type);
    }
    else
    {
	fprintf(stderr, "%s: [ %s:%s ] [ %s %d ]\n",
	    error, module, lineno, iu_errlist[ type - IU_MESGBASE ].iu_mesg, type);

	IUDisplayShortError();
    }

    return type;
}
