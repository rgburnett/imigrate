/*
 * File		: Log.ec
 * 
 * Sccs		: @(#)Log.ec	1.4
 *
 * Dated	: 96/10/24 14:43:50 
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
 * Name 	: Log - direct messages to a log file. 
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  Log(filename)
 *		  char *filename;
 *
 * Arguments	: filename	- destination log file name. 
 *
 * Description	: Log messages 
 *
 * Returns	: status values
 *
 * See Also	:
 *
 */

#ifdef TEST
#define MAIN
EXEC SQL define MAIN;
#endif

EXEC SQL include "iimport.h";

#include <fcntl.h>

PRIVATE
char *sccsid = "SCCS: @(#)Log.ec	1.4 Continuus: %subsystem: % %filespec: %";

PUBLIC
status
Log(filename)
char *filename;
{
    static int first = 1;
    int fdstdout;
    int fdstderr;

    if(first)
    {
	first = 0;

	if((fdstdout = open(filename, (O_WRONLY | O_APPEND | O_CREAT), 0666)) == -1)
	    return Error(errno, "iimport.Log", "67");

	close(1);
	close(2);

	dup2(fdstdout, 1);
	dup2(fdstdout, 2);
    }
    return IU_SUCCESS;
}

#ifdef TEST

main()
{
    Log("test.log");

    fprintf(stdout, "stdout\n");
    fprintf(stderr, "stderr\n");
}

#endif
