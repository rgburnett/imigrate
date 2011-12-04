/*
 * File		: IUDBDisconnect.ec
 * 
 * Sccs		: @(#)IUDBDisconnect.ec	1.2
 *
 * Dated	: 96/10/30 15:24:18 
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
char *sccsid = "SCCS: @(#)IUDBDisconnect.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUDBDisconnect - close an active connection to a database.
 *
 * Synopsis	: PUBLIC
 *		  status 
 *		  IUDBDisconnect(conname)
 *		  char *conname;
 *
 * Arguments	: current - the connection to close; 
 *
 * Description	: Close an active connection to a database. This function looks
 *		  up the dbconnection global array for the currently active
 *		  transaction, closes the explicit connection and resets the
 *		  status in dbconnection to CONFREE;
 *
 * See Also	: IUDBConnect();
 *
 * Sccs 	: @(#)IUDBDisconnect.ec	1.2 
 *
 * Continuus 
 * Project	: %subsystem% %filespec%";
 */

PUBLIC
status
IUDBDisconnect(conname)
EXEC SQL BEGIN DECLARE SECTION;
PARAMETER char *conname;
EXEC SQL END DECLARE SECTION;
{
    register int i;
    register int len;

    if(conname == (char *)NULL || ((len = strlen(conname)) < 1))
	return Error(IU_EINVALIDARG, "IUDBDisconnect.conname", "67");

    for(i = 0; i < MAX_CONNECTIONS; i++)
	if(!memcmp(connection[ i ].name, conname, len))
	{
	    EXEC SQL DISCONNECT :conname;

	    if (IUCheck("IUDBDisconnect: DISCONNECT") == IU_ERTERROR)
		return IU_ERTERROR;

	    connection[ i ].status = CONFREE;
	    connection[ i ].name[0] = '\0';

	    return IU_SUCCESS;
	}

    return Error(IU_ERTERROR, "IUDBDisconnect: Non existant connection", "83");
}
