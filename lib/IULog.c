/*
 * File		: IULog.c
 * 
 * Sccs		: @(#)IULog.c	1.1
 *
 * Dated	: 96/10/30 15:24:22 
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


/*
 *
 * Name 	: IULog - direct messages to a log file. 
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  IULog(filename)
 *		  char *filename;
 *
 * Arguments	: filename	- destination log file name. 
 *
 * Description	: IULog redirects stderr and stdout to a log file
 *
 * Returns	: status values
 *
 * See Also	:
 *
 */

#ifdef TEST
#define MAIN
#endif

#include "c.incl.h"
#include "c.defs.h"
#include "c.class.h"
#include "error.class.h"
#include "c.proto.h"
#include <fcntl.h>

PRIVATE
char *sccsid = "SCCS: @(#)IULog.c	1.1 Continuus: %subsystem: % %filespec: %";

PUBLIC
status
IULog(filename)
char *filename;
{
    static int first = 1;
    int fdstdout;
    int fdstderr;

    if(first)
    {
	first = 0;

	if((fdstdout = open(filename, (O_WRONLY | O_APPEND | O_CREAT), 0666)) == -1)
	    return Error(errno, "iimport.Log", "69");

	close(1);

	dup2(fdstdout, 1);
    }
    return IU_SUCCESS;
}

#ifdef TEST

main()
{
    IULog("test.log");

    fprintf(stdout, "stdout\n");
    fprintf(stderr, "stderr\n");
}

#endif
