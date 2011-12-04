/*
 * File		: IUUnloadTable.ec 
 * 
 * Sccs		: @(#)IUUnloadTable.ec	1.2
 *
 * Dated	: 96/10/30 15:24:24 
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
EXEC SQL include "esql.class.h";
#include "error.class.h"
#include "c.proto.h"
#include "global.h"


PRIVATE
FINAL
char *sccsid = "SCCS: @(#)IUUnloadTable.ec	1.2 Continuus: %subsystem: % %filespec: %";

EXEC SQL BEGIN DECLARE SECTION; 

PRIVATE
FINAL
char *IUUTid = "IUUTid";

EXEC SQL END DECLARE SECTION; 

/*{{ FUNCDOC 3
 *
 * Name 	: IUUnloadTable - perform and unload of a table to an output stream
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  IUUnloadTable(table, outstream)
 *		  char *table;
 *		  FILE *outstream;
 *
 * Arguments	: table - the name of the table which you want to unload 
 * 		  
 *
 * 		  outstream - a FILE pointer for the output;
 *
 * Description	: IUUnloadTable is and Informix Utility which unloads a table
 *		  to a file.. or a pipe.
 *
 * Notes	: This version seems to include the currency symbol on money
 * 		  values though this works ok.
 *
 * Error Codes	: returns status values of
 *
 * See Also	:
 *
 */

PUBLIC
status
IUUnloadTable(table, outstream)
EXEC SQL BEGIN DECLARE SECTION;
char *table;
EXEC SQL END DECLARE SECTION;
FILE *outstream;
{
    EXEC SQL BEGIN DECLARE SECTION;
    int		desc_count;
    char	colquery[ 100 ];
    int		i;
    char	*result;
    EXEC SQL END DECLARE SECTION;
    int		maxlen = -1;
    columninfo  cib;
    columninfo *g = &cib;
    status	retval;

    if(outstream == (FILE *)NULL)
	return Error(IU_EINVALIDARG, "IUUnloadTable.outstream", "95");

    (void) sprintf(colquery, "SELECT * FROM %s;", table);

    EXEC SQL PREPARE :IUUTid from :colquery;

    if(IUCheck(colquery) == IU_ERTERROR)
	return Error(IU_EPREPARE, "IUUnloadTable", "102");

    EXEC SQL DECLARE IUUTcursor CURSOR FOR :IUUTid;

    if(IUCheck(colquery) == IU_ERTERROR)
    {
	retval = Error(IU_EDECLARE, "IUUnloadTable", "108");
	goto deallocate_descriptor;
    }

    EXEC SQL ALLOCATE DESCRIPTOR 'IUUTdesc';

    if(IUCheck(colquery) == IU_ERTERROR)
    {
	retval = Error(IU_EALLOCDESC, "IUUnloadTable", "116");
	goto deallocate_descriptor;
    }

    EXEC SQL OPEN IUUTcursor;

    if(IUCheck(colquery) == IU_ERTERROR)
    {
	retval = Error(IU_EOPENCURSOR, "IUUnloadTable", "124");
	goto deallocate_descriptor;
    }

    EXEC SQL DESCRIBE :IUUTid USING SQL DESCRIPTOR 'IUUTdesc';

    if(IUCheck(colquery) == IU_ERTERROR)
    {
	retval = Error(IU_EDESCRIBE, "IUUnloadTable", "132");
	goto deallocate_descriptor;
    }

    EXEC SQL GET DESCRIPTOR 'IUUTdesc' :desc_count = COUNT;

    if(IUCheck(colquery) == IU_ERTERROR)
    {
	retval = Error(IU_EGETDESC, "IUUnloadTable", "140");
	goto deallocate_descriptor;
    }

    IUTransaction(BEGINWORK);


    for (;;)
    {  
	EXEC SQL FETCH IUUTcursor USING SQL DESCRIPTOR 'IUUTdesc';

	if((retval = IUCheck(colquery)) == IU_ERTERROR)
	{
	    retval = Error(IU_EFETCH, "IUUnloadTable", "153");
	    goto deallocate_descriptor;
	}

	if(retval == IU_NODATA)
	    break;

	for (i = 1; i <= desc_count; i++)
        {
	    if(IUColumnInfo(&cib, i) != IU_SUCCESS)
	    {
		retval = Error(IU_ERTERROR, "IUUnloadTable.IUColumnInfo", "164");
		goto deallocate_descriptor;
	    }

	    if(maxlen == -1)
	    {
		maxlen = g->len;

		if((result = (char *)malloc(g->len + 1)) == (char *)NULL)
		{
		    retval = Error(errno, "IUUnloadTable", "174");
		    goto deallocate_descriptor;
		}
	    }
	    else if (g->len > maxlen)
	    {
		maxlen = g->len;

		if((result = (char *)realloc(result, g->len + 1)) == (char *)NULL)
		{
		    retval = Error(errno, "IUUnloadTable", "184");
		    goto deallocate_descriptor;
		}
	    }

	    if (g->is_null)
	    {
		strcpy(result, "");
	    }
	    else
	    {
		EXEC SQL get descriptor 'IUUTdesc' VALUE :i :result = DATA ;

		if(IUCheck(colquery) == IU_ERTERROR)
		{
		     retval = Error(IU_EGETDESC, "IUUnloadTable", "199");
		     goto deallocate_descriptor;
		}
	    }

            fprintf(outstream, "%s|", strip(result));
	}

        fprintf(outstream, "\n");
    }

    retval = IU_SUCCESS;

deallocate_descriptor:

    IUTransaction(COMMITWORK);
 
    free(result);

    EXEC SQL close IUUTcursor;
    EXEC SQL free IUUTcursor;
    EXEC SQL free IUUTid;
    EXEC SQL DEALLOCATE DESCRIPTOR 'IUUTdesc';

    return retval; 
}

#ifdef TEST

main()
{

    system("dbaccessdemo7");

    setbuf(stdout, (char *)NULL);

    EXEC SQL connect to "stores7";

    IUUnloadTable("orders", stdout);
}

#endif

