/*
 * File		: IUDBObjectExists.ec
 * 
 * Sccs		: @(#)IUDBObjectExists.ec	1.2
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
#include "c.defs.h"
EXEC SQL include "esql.defs.h";
#include "c.class.h"
#include "error.class.h"
#include "c.proto.h"
#include "global.h"

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)IUDBObjectExists.ec	1.2 Continuus: %subsystem: % %filespec: %";

PRIVATE
objectexists 
dbobjects[]=
{
    { COLUMN,	"select colname from %s:syscolumns where colname = ?" },
    { CONSTRAINT, 
	"select constrname from %s:sysconstraints where constrname = ?" },
    { INDEX,	"select idxname  from %s:sysindexes where idxname = ?" },
    { PROCEDURE,"select procname from %s:sysprocedures where procname = ?" },
    { SYNONYM,	"select synname  from %s:syssynonyms where synname = ?" },
    { TABLE,	"select tabname from %s:systables where tabname = ?" },
    { TRIGGER,	"select trigname from %s:systriggers where trigname = ?" },
    { USER,	"select username from %s:sysusers where username = ?" },
    { DBSPACE,	"select name from %s:sysdbspaces where name = ?" },
    { DBCHUNK,	"select fname from %s:syschunks where fname = ?" },
    { DATABASE,	"select name from %s:sysdatabases where name = ?" }

};

#define OBJECT_CLASSES 11

/*{{ FUNCDOC 3
 *
 * Name 	: IUDBObjectExists - check if an object within a database exists 
 *
 * Synopsis	: PUBLIC
 *		  int
 *		  IUDBObjectExists(database, class, objname)
 *		  char *database;
 *		  dbobjclass class;
 *		  char *objname;
 *
 * Arguments	: database - name of a database 
 *
 *		  class -  the type of database object you are looking for.
 *		  	       Valid types are: 
 *
 *			COLUMN
 *			CONSTRAINT
 *			INDEX
 *			PROCEDURE
 *			SYNONYM
 * 			TABLE
 *			TRIGGER
 *			USER
 *			DBSPACE
 *			DBCHUNK
 *			DATABASE
 *
 *
 *		  objname - the name of the object you seek.
 *
 * Description	: IUDBObjectExists performs a lookup in the relevant system
 *		  catalog for an object.
 *
 * Returns	: IU_SUCCESS on success, other status values on error.
 *
 * See Also	:
 *
 */

EXEC SQL BEGIN DECLARE SECTION; 

PRIVATE
FINAL char *iudbobid = "IUDBObj_id";

EXEC SQL END DECLARE SECTION; 

PUBLIC
int
IUDBObjectExists(database, class, objname)
EXEC SQL BEGIN DECLARE SECTION; 
char *database;
EXEC SQL END DECLARE SECTION; 
dbobjclass class;
EXEC SQL BEGIN DECLARE SECTION; 
char *objname;
EXEC SQL END DECLARE SECTION;
{
    EXEC SQL BEGIN DECLARE SECTION;  
    char result[ 19 ];
    char statement[ 2048 ];
    char *objstatement = "select %s into :object from %s where %s = ?";
    char *connection = (char *)NULL;
    EXEC SQL END DECLARE SECTION; 
    int retval = IU_SUCCESS;

    if(class < 0 || class > OBJECT_CLASSES)
	return Error(IU_EINVALIDARG, "IUDBObjectExists: unknown class", "127");

    if(objname == (char *)NULL || *objname == '\0')
	return Error(IU_EINVALIDARG, "IUDBObjectExists: missing objname", "130");

    if(database == (char *)NULL || *database == '\0')
	return Error(IU_EINVALIDARG, "IUDBObjectExists: missing database", "133");

    /*
     * Build our retrieval statement
     */

    sprintf(statement, dbobjects[ class ].retrieval, database);


    EXEC SQL PREPARE :iudbobid from :statement;

    if(IUCheck(statement) == IU_ERTERROR)
	return Error(IU_EPREPARE, "IUDBObjectExists:PREPARE", "145");

    IUTransaction(BEGINWORK);

    EXEC SQL EXECUTE :iudbobid USING :objname;

    switch(retval = IUCheck(statement))
    {
	case IU_NODATA:
	    retval = IU_NODATA;
	    break;

	case IU_WARNING:
	    retval = IU_SUCCESS;
	    break;

	default:
	    retval = IU_ERTERROR;
	    break;
    }

    IUTransaction(COMMITWORK);

    return retval; 
}

#ifdef TEST

main()
{
    char *db;

    EXEC SQL DATABASE "sysmaster";

    if(IUDBObjectExists("sysmaster", DATABASE, "stores7") == IU_SUCCESS)
    {
	printf("Found DATABASE stores7\n");

	printf("Searching for TABLE cust_calls in stores7\n");

	if(IUDBObjectExists("stores7", TABLE, "cust_calls") != IU_SUCCESS)
	{
	    printf("Error Table cust_calls does not exist in database stores7\n");
	    exit(1);
	}
	else
	    printf("Found TABLE cust_calls\n");


	if(IUDBObjectExists("stores7", TABLE, "fred") != IU_SUCCESS)
	    printf("Table fred does not exist in database stores7\n");
	else
	    printf("Error Found TABLE fred\n");

	if(IUDBObjectExists("stores7", TABLE, "customer") != IU_SUCCESS)
	    printf("Error - Table customer does not exist in database stores7\n");
	else
	    printf("Table customer found in stores7\n");

    }

    if(IUDBObjectExists("sysmaster", DBSPACE, "rootdbs") != IU_SUCCESS)
    {
	printf("Error - DBSPACE rootdbs not found in sysmaster - Error\n");
	exit(1);
    }
    else
	printf("Found DBSPACE rootdbs\n");


    if(IUDBObjectExists("sysmaster", INDEX, "syspaghdridx") != IU_SUCCESS)
    {
	printf("Error - INDEX syspaghdridx not found\n");
	exit(1);
    }
    else
	printf("Found INDEX syspaghdrid in sysmaster\n");

    IUDBDisconnect(db);

}

#endif
