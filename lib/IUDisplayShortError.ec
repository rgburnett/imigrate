/*
 * File		: IUDisplayShortError.ec
 * 
 * Sccs		: @(#)IUDisplayShortError.ec	1.2
 *
 * Dated	: 96/10/30 15:24:20 
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
char *sccsid = "SCCS: @(#)IUDisplayShortError.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUDisplayShortError - display a shortened error message 
 *
 * Synopsis	: void IUDisplayShortError()
 *
 * Arguments	: none 
 *
 * Description	: IUDisplayShortError  
 *
 * See Also	:
 *
 * Sccs 	: @(#)IUDisplayShortError.ec	1.2 
 *
 * Continuus 
 * Project	: %subsystem% %filespec%";
 */

PUBLIC
void
IUDisplayShortError()
{
    EXEC SQL BEGIN DECLARE SECTION;
    int	i;
    int	exception_count;
    char message[255];
    EXEC SQL END DECLARE SECTION; 

    extern char *strip();

    EXEC SQL get diagnostics :exception_count = NUMBER;

    for( i = 1; i <= exception_count; i++)
    {
	EXEC SQL get DIAGNOSTICS exception :i :message = MESSAGE_TEXT;

	(void) fprintf(stderr, "[ SQLCODE %d ] [ %s ]\n", 
	    SQLCODE, strip(message));
    }
}
