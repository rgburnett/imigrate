/*
 * File		: IUDBConnect.ec
 * 
 * Sccs		: @(#)IUDBConnect.ec	1.2
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

#ifdef TEST
EXEC SQL define MAIN;
#define MAIN
#endif

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
char *sccsid = "SCCS: @(#)IUDBConnect.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUDBConnect - connect or reconnect to a database.
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  IUDBConnect(database, connection)
 *		  const char *database;
 *		  char connection[6];
 *
 * Arguments	: database 	- a database which you want to open; 
 *
 *		  connection	- name of the connection will be stored here
 *
 * Description	: IUDBConnect starts an explicit named connection to a database.
 *
 *		  There is a global array of MAX_CONNECTION dbconnection structures.
 *
 *		  If <connection> is NULL, a new connection is established. Otherwise
 *		  a connection is looked for and if exists, is set as the current 
 *		  connection. 
 *
 *		  If the database has logging, the global variable has_logging
 *		  is set to TRUE, FALSE otherwise.
 *
 *		  The IUDBDisconnect() is used to close the current connection.
 *
 * See Also	: IUDBDisconnect() 
 *
 * Returns	: status values of IU_SUCCESS or IU_ERTERROR on error.
 */

PUBLIC
status
IUDBConnect(database, conname)
EXEC SQL BEGIN DECLARE SECTION;    
const char *database;
char conname[6];
EXEC SQL END DECLARE SECTION;    
{

    register int i;
    register int len;
    enum _contype { CONNECT, RECONNECT } contype;
    char sqlcommand[ 128 ];
    
    contype = CONNECT;

    /*
     * Argument checking
     */

    if(database == (char *)NULL || *database == '\0')
    {
	contype = RECONNECT;
	
	if(conname == (char *)NULL || *conname == '\0')
	    return Error(IU_EINVALIDARG, 
		"IUDBConnect: database name OR connection required", "104");
    }

    
    /*
     * If we are requesting an existing connection, look it up
     * otherwise grab the first free connection.
     */

    if(*conname && (len = strlen(conname)))
    {
	for(i = 0; i < MAX_CONNECTIONS; i++)
	    if(!memcmp(conname, connection[ i ].name, len))
		break;

    }
    else
	for(i = 0; i < MAX_CONNECTIONS; i++)
	    if(connection[ i ].status != CONACTIVE)
	    {
		connection[ i ].status = CONACTIVE; 
		sprintf(connection[ i ].name, "con%02d", i); 
		sprintf(conname, "%s", connection[ i ].name);
		break;
	    }

    if( i == (MAX_CONNECTIONS - 1))
	return Error(IU_ERTERROR, "IUDBConnect: CONNECT failure", "131");

    if(contype == CONNECT)
    {
	sprintf(sqlcommand, "EXEC SQL CONNECT TO %s AS %s WITH CONCURRENT TRANSACTION",
		database, conname);

	EXEC SQL CONNECT TO :database AS :conname WITH CONCURRENT TRANSACTION;
    }
    else
    {
	sprintf(sqlcommand, "EXEC SQL SET CONNECTION %s", conname);

	EXEC SQL SET CONNECTION :conname;
    }

    if(IUCheck(sqlcommand) != IU_WARNING) 
	return IU_ERTERROR;

    database_is_ansi     = sqlca.sqlwarn.sqlwarn2 == 'W';
    database_has_logging = (sqlca.sqlwarn.sqlwarn1 == 'W') ? TRUE : FALSE;

    return IU_SUCCESS;
}

#ifdef TEST

main()
{
    list glist, lptr;
    char *db;
    char con[ 10 ];
    
    if(IUDBConnect("stores7", con) != IU_SUCCESS)
    {
	fprintf(stderr, "Cannot connect to stores7\n");
	exit(1);
    }

    if(IUListTables(&glist, "stores7") != IU_SUCCESS)
	exit(1);

    for (lptr = glist; NEXT(lptr); lptr = NEXT(lptr))
	printf("%s\n", (char *)DATA(lptr));

    ListDestroy(&glist);

    if(IUDBDisconnect((char *)NULL, con) != IU_SUCCESS)
    {
	fprintf(stderr, "Unsuccessful disconnection from stores7\n");
	exit(1);
    }

    exit(0);
}

#endif
