/*
 * File		: IUListTables.ec
 * 
 * Sccs		: @(#)IUListTables.ec	1.2
 *
 * Dated	: 96/10/30 15:24:21 
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
char *sccsid = "SCCS: @(#)IUListTables.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUListTables - construct a sorted list of tables in the database
 *
 * Synopsis	: PUBLIC
 * 		  status
 * 		  IUListTables(alist, dbname)
 *		  list *alist;
 *		  char *dbname;
 *
 * Arguments	: alist - a that address of a "list" structure to hold the linked
 *		          list of tables
 *
 *		  dbname - the name of the database.
 *
 * Description	: Build a "list" (a linked list) of tablenames
 *
 * Returns	: IU_SUCCESS or IU_ERTERROR on failure
 *
 * See Also	: ListInsert(), strip(), IUDBClose, IUDBDisconnect() 
 *
 */

EXEC SQL BEGIN DECLARE SECTION;

PRIVATE
char *IULT_id = "list_tables_id";

EXEC SQL END DECLARE SECTION;

PUBLIC
status
IUListTables(alist, dbname)
list *alist;
char *dbname;
{
    EXEC SQL BEGIN DECLARE SECTION; 
    /*
     * We don't want views and diagnostic tables listed in
     * the output.
     */
    char *query = "SELECT 				\
                       tabname 				\
                   FROM 				\
                       systables			\
                   WHERE 				\
                       tabid > 99 			\
                   AND tabtype = 'T' 			\
                   AND tabid NOT IN (			\
                           SELECT			\
	                       viotid AS tabid 		\
			   FROM 			\
			       sysviolations		\
                   )					\
                   AND tabid NOT IN (			\
                            SELECT			\
	                        diatid AS tabid 	\
			    FROM 			\
				sysviolations		\
                   )					\
                   ORDER BY 				\
                       tabname ";

    char tablename [ 19 ];
    char dbconnection[ 10 ];
    EXEC SQL END DECLARE SECTION;
    status retval;

    extern char *strip();

    if(dbname != (char *)NULL)
	if(IUDBConnect(dbname, dbconnection) != IU_SUCCESS)
	    return IU_ERTERROR;


    EXEC SQL PREPARE :IULT_id FROM :query;
	
    if(IUCheck(query) == IU_ERTERROR)
	return Error(IU_EPREPARE, "IUListTables", "119");

    EXEC SQL DECLARE IULTcursor CURSOR FOR :IULT_id; 

    if(IUCheck(query) == IU_ERTERROR)
	return Error(IU_EDECLARE, "IUListTables", "124");


    EXEC SQL OPEN IULTcursor;

    if(IUCheck(query) == IU_ERTERROR)
	return Error(IU_EOPENCURSOR, "IUListTables", "130");

    ListInitialise(alist);

    IUTransaction(BEGINWORK);

    for(;;)
    {
	char *ptr;

	EXEC SQL FETCH IULTcursor INTO :tablename;

	retval = IUCheck("fetch IULTcursor");

	if ( retval == IU_NODATA || retval ==  IU_ERTERROR )
	    break;

	if((ptr = (char *)malloc(sizeof(tablename))) == (char *)NULL)
	    return Error(errno, "IUListTables.malloc", "148");

	(void) strcpy(ptr, strip(tablename));
	
	if(ListAppend(alist, (generic_ptr)ptr) == IU_ERROR)
	    return Error(IU_ELISTINSERT, "IUListTables.ListInsert", "153");; 
    }

    IUTransaction(COMMITWORK);

    EXEC SQL CLOSE :IULT_id;
    EXEC SQL FREE :IULT_id;

    if(dbname != (char *)NULL)
    {
	IUDBDisconnect(dbconnection);

	EXEC SQL SET CONNECTION DEFAULT;

	retval = IU_NODATA;
    }

    return ( retval == IU_NODATA ) ? IU_SUCCESS : IU_ERTERROR;
}

#ifdef TEST

main()
{
    list glist, lptr;
    status retval;

    if((retval = IUListTables(&glist, "dbtarget")) != IU_SUCCESS)
    {
	printf("List tables failed %d\n", retval);
	exit(1);
    }

    for (lptr = glist; DATA(lptr); lptr = NEXT(lptr))
    {

	printf("%s\n", (char *)DATA(lptr));
    }

    ListDestroy(&glist);
}

#endif
