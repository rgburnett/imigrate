/*
 * File		: IUMasterTableList.ec
 * 
 * Sccs		: @(#)IUMasterTableList.ec	1.2
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
char *sccsid = "SCCS: @(#)IUMasterTableList.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUMasterTableList - Build a list of Master tables from a detail table.
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  IUMasterTableList(tablename, alist)
 *		  char *tablename
 *		  list alist;
 *
 * Arguments	: tablename - name of a table in the database.
 *
 *		  alist	- a list object to contain the Master tables.
 *
 * Description	: IUMasterTableList will return a list of tables which have
 *		  a FOREIGN KEY (i.e. a Master/Detail relationship) constraint
 *		  to the <table> arguement. This is useful when trying to 
 *		  turn off CONSTRAINTS in the right order.  
 *
 * Returns	: IU_SUCCESS on success, status values on error.
 *
 * See Also	: IUConstraintsDisable
 *
 */

EXEC SQL BEGIN DECLARE SECTION;

PRIVATE
FINAL char *mast_id = "Metal_id";

EXEC SQL END DECLARE SECTION;

PUBLIC
status
IUMasterTableList(tablename, alist)
EXEC SQL BEGIN DECLARE SECTION; 
char *tablename;
EXEC SQL END DECLARE SECTION; 
list *alist;
{
    EXEC SQL BEGIN DECLARE SECTION; 
    char detailquery[ 512 ];
    char detailtable[ 256 ];
    EXEC SQL END DECLARE SECTION; 
    char *ptr;
    list lptr;
    status retval;


    if( tablename == (char *)NULL)
	return Error(IU_EINVALIDARG, "IUMasterTableList.tablename", "86");

    sprintf(detailquery, "%s",  
       "SELECT 				\
	    tabname			\
	FROM				\
	    systables t,		\
	    sysconstraints c		\
	WHERE				\
	    t.tabid = c.tabid		\
	AND c.constrid 			\
	IN				\
	(				\
	    SELECT			\
		r.constrid 		\
	    FROM 			\
		systables t,		\
		sysreferences r		\
	    WHERE 			\
		t.tabname = ?		\
	    AND r.ptabid = t.tabid)"
    );

			
    EXEC SQL PREPARE :mast_id FROM :detailquery;

    if(IUCheck("IUMasterTableList: PREPARE MaTaLiCurs") != IU_SUCCESS)
	return IU_ERTERROR;

    EXEC SQL DECLARE MaTaLiCurs CURSOR FOR :mast_id;

    if(IUCheck("IUMasterTableList: DECLARE MaTaLiCurs") != IU_SUCCESS)
	return IU_ERTERROR;

    IUTransaction(BEGINWORK);

    EXEC SQL OPEN MaTaLiCurs USING :tablename;

    if(IUCheck("IUMasterTableList: OPEN MaTaLiCurs") != IU_SUCCESS)
	return IU_ERTERROR;

    for (;;)
    {
        EXEC SQL FETCH MaTaLiCurs INTO :detailtable;

	retval = IUCheck("IUMasterTableList: FETCH");

	if (retval == IU_NODATA || retval ==  IU_ERTERROR )
	    break;

	if((ptr = (char *)malloc(sizeof(detailtable))) == (char *)NULL)
	{
	    retval = errno;
	    Error(errno, "IUMasterTableList.malloc", "139");
	    break;
	}

	(void) strcpy(ptr, strip(detailtable));

	if(ListInsert(alist, (generic_ptr)ptr) != IU_SUCCESS)
	{
	    retval = IU_ELISTINSERT;
	    Error(IU_ELISTINSERT, "IUMasterTableList.ListInsert", "148");; 
	    break;
	}
    }

    IUTransaction(COMMITWORK);

    EXEC SQL CLOSE MaTaLiCurs;
    EXEC SQL FREE MaTaLiCurs;
    EXEC SQL FREE :mast_id;

    return (retval == IU_NODATA) ? IU_SUCCESS : retval;
}
