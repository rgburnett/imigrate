
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

main()
{
    EXEC SQL BEGIN DECLARE SECTION;  
    char bert[ 100 ];
    EXEC SQL END DECLARE SECTION; 

    EXEC SQL CONNECT TO "stores7" AS :bert WITH CONCURRENT TRANSACTION;

    printf("%d \n", SQLSTATE[0]);

    pause();
}
