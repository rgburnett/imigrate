/*
 * File		: IUTime.ec
 * 
 * Sccs		: @(#)IUTime.ec	1.2
 *
 * Dated	: 96/10/30 15:24:23 
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
EXEC SQL include "esql.incl.h";
#include "c.defs.h"
EXEC SQL include "esql.defs.h";
#include "c.class.h"
EXEC SQL include "esql.class.h";
#include "error.class.h"
#include "c.proto.h"
EXEC SQL include "esql.proto.h";
#include "global.h"

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)IUTime.ec	1.2 Continuus: %subsystem: % %filespec: %";

EXEC SQL BEGIN DECLARE SECTION; 

typedef struct _sysvpprof
{
    int	vpid;
    char class[ 51 ];
    float usercpu;
    float syscpu;
} sysvpprof;

EXEC SQL END DECLARE SECTION; 

/*{{ FUNCDOC
 *
 * Name 	: IUTime - print elapsed cpu usage
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  IUTime()
 *
 * Arguments	: none
 *
 * Description	: IUTime provides timing information from the Informix
 *		  system catalogs regarding the user and system cpu usage
 *		  of the various virtual processors. 
 *
 * Returns	: status values
 *
 * See Also	:
 *
 */

PUBLIC
status
IUTime()
{
    FINAL char *where = "IUTime";
    long t;
    long elapsed;
    long currenttime;
    static long lasttime = 0;
    static sysvpprof lastlot[ 100 ]; /* I hate hardcoding... but time is short */ 
    sysvpprof *lptr = (sysvpprof *)NULL;
    static int first = 1;
    double usertot = 0.0;
    double systot = 0.0;

    EXEC SQL BEGIN DECLARE SECTION; 

    sysvpprof currentprof, *ptr = &currentprof;

    EXEC SQL END DECLARE SECTION; 

    EXEC SQL DECLARE IUTimecursor CURSOR FOR SELECT 
	vpid,
        class,
        usercpu,
        syscpu
    into 
	:currentprof.vpid,
	:currentprof.class, 
	:currentprof.usercpu,
	:currentprof.syscpu
    FROM 
	sysmaster:sysvpprof;

    if(IUCheck("DECLARE CURSOR FOR SELECT") != IU_SUCCESS)
	return Error(IU_ERTERROR, "IUTime: DECLARE CURSOR", "103");

    EXEC SQL OPEN IUTimecursor;

    if(IUCheck("OPEN CURSOR") != IU_SUCCESS)
	return Error(IU_ERTERROR, "IUTime: OPEN CURSOR", "108");

    IUTransaction(BEGINWORK);

    time(&currenttime);

    if(lasttime == 0)
	elapsed = 0;
    else
	elapsed = currenttime - lasttime;

    lasttime = currenttime;

    printf("\nTime %s\nElapsed %d second%s\n\n",
	StripNewLine(ctime(&currenttime)), elapsed, ((elapsed != 1) ? "s" : "")); 

    printf("VP\nClass"); 
    printf("     user cpu      system cpu\n");
    printf("-----------------------------------\n");

    for(;;)
    {
	EXEC SQL FETCH IUTimecursor;

	if(IUCheck("IUTime: FETCH") != IU_SUCCESS)
	    break;

	printf("%-5s\t%10.3f\t%10.3f\n", strip(ptr->class), 
			ptr->usercpu - lastlot[ currentprof.vpid ].usercpu, 
				    ptr->syscpu - lastlot[ currentprof.vpid ].syscpu);

	usertot += (ptr->usercpu - lastlot[ currentprof.vpid ].usercpu);
	systot += ptr->syscpu - lastlot[ currentprof.vpid ].syscpu;

	lastlot[ ptr->vpid ] = currentprof;
    }

    printf("-----------------------------------\n");
    printf("Total\t%10.3f\t%10.3f\n\n",
									usertot, systot);

    IUTransaction(COMMITWORK);

    EXEC SQL CLOSE IUTimecursor;
    EXEC SQL FREE IUTimecursor;

    return IU_SUCCESS;
}
