/*
 * File		: IUCreateDatabase.ec 
 * 
 * Sccs		: @(#)IUDatabase.ec	1.2 
 *
 * Dated	: 96/10/30 15:24:19 
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
#include "c.defs.h"
#include "c.class.h"
#include "error.class.h"
#include "c.proto.h"
#include "global.h"

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)IUDatabase.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUDatabase - create or drop a database 
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  IUDatabase(op, dbname, which_space)
 *		  int	op;
 *		  char   *dbname;
 *		  char   *which_space;
 *
 * Arguments	: op		either CREATEDATABASE or DROPDATABASE
 *
 *		  dbname	Name of the database to create/drop
 *
 *		  which_space	which space to create the database in.
 *
 * Description	: IUDatabase allows the creation/deletion of a database. It
 *		  creates a child process to do this because of the implicit 
 *		  database connections;
 *
 * Notes	: NB, the first line of you code should establish an implicit
 *		  connection using DATABASE sysmaster statement. 
 *
 * See Also	: DISCONNECT, CONNECT statements.
 *
 * Sccs 	: 
 *
 * Continuus 
 * Project	: %subsystem% %filespec%";
 */

PUBLIC
status
IUDatabase(op, dbname, which_space)
int	op;
char   *dbname;
char   *which_space;
{
    EXEC SQL BEGIN DECLARE SECTION;
    char cmd[ 256 ];
    char *con;
    EXEC SQL END DECLARE SECTION;

    status ret_val;
    char *dbop;
    pid_t pid;
    int stat;

    switch(op)
    {
	case CREATEDATABASE:
	    dbop = "CREATE";
	    break;

	case DROPDATABASE:
	    which_space = (char *)NULL;
	    dbop = "DROP";
	    break;

	default:
	    return Error(IU_EINVALIDARG, "IUCreateDatabase: op", "98");
    }

    if(dbname == (char *)NULL)
	return Error(IU_EINVALIDARG, "IUCreateDatabase: dbname", "102");

    if(which_space != (char *)NULL && *which_space)
	sprintf(cmd, "%s DATABASE %s IN %s", dbop, dbname, which_space);
    else
	sprintf(cmd, "%s DATABASE %s", dbop, dbname);

    IUTransaction(BEGINWORK);

    EXEC SQL EXECUTE IMMEDIATE :cmd;

    ret_val = IUSQLStateError();

    IUTransaction(COMMITWORK);

    return (ret_val == IU_WARNING) ? IU_SUCCESS : ret_val;
}

#ifdef TEST

main()
{

    status ret_val;
    char fred[10];

    EXEC SQL DATABASE "sysmaster";

    if(IUCheck("DATABASE sysmaster") != IU_WARNING)
	exit(1);

    IUDBConnect("sysmaster", fred);

    if(IUCheck("Call to IUDBConnect") != IU_WARNING)
	exit(1);

    IUDBDisconnect(fred);

    if(IUCheck("Call to IUDBConnect") != IU_SUCCESS)
	exit(1);

    EXEC SQL SET CONNECTION DEFAULT;

    printf("%d -->\n", IUDatabase(DROPDATABASE, "fred", (char *)NULL));

    if(IUCheck("Call to drop database fred") != IU_SUCCESS)
	exit(1);

    printf("%d -->\n", IUDatabase(CREATEDATABASE, "fred", (char *)NULL));

    if(IUCheck("Call to create database fred") != IU_SUCCESS)
	exit(1);

    EXEC SQL DISCONNECT ALL;
}

#endif
