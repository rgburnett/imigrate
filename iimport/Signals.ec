/*
 * File		: Signals.ec
 * 
 * Sccs		: @(#)Signals.ec	1.1
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
 * Name 	: iimportSignalhandle - close the db connection and exit cleanly
 *
 * Synopsis	: 
 *
 * Arguments	:
 *
 * Description	: 
 *
 * Returns	:
 *
 * See Also	:
 *
 */

EXEC SQL include "iimport.h";

EXEC SQL include "signal.h";

PRIVATE
char *sccsid = "SCCS: @(#)Signals.ec	1.1 Continuus: %subsystem: % %filespec: %";

PUBLIC void iimportSetSignals();
PRIVATE void iimportSighandle(int signo);

PRIVATE
void
iimportSignalHandler(signo)
int signo;
{
    long t = time(&t);

    sighold(signo);

    EXEC SQL DISCONNECT ALL;
    printf("iimport Aborting...\nCaught Signal [ %d ] at %s\n", signo, ctime(&t));

    /*
     * Don't bother about killing any kids - init will pick them up soon enough
     */
    exit(1);
}

/*{{ FUNCDOC
 *
 * Name 	: iimportSetSignals - signal handling for iimport
 *
 * Synopsis	: PUBLIC
 *		  void
 *		  iimportSetSignals()
 *
 * Arguments	: none
 *
 * Description	: iimportSetSignals deals with all the signal handling. 
 *
 * Returns	: void
 *
 * See Also	: iimportSignalHandle()
 *
 */

PUBLIC
void
iimportSetSignals()
{
    void iimportSignalHandler();

    signal(SIGHUP,	 iimportSignalHandler);
    signal(SIGINT,	 iimportSignalHandler);
    signal(SIGQUIT,	 iimportSignalHandler);
    signal(SIGTERM,	 iimportSignalHandler);
}
