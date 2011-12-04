/*,
 * File		: IULoadTable.ec
 * 
 * Sccs		: @(#)IULoadTable.ec	1.2
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
char *sccsid = "SCCS: @(#)IULoadTable.ec	1.2 Continuus: %subsystem: % %filespec: %";

EXEC SQL BEGIN DECLARE SECTION; 

PRIVATE
int	column_type;

PRIVATE
char	column_name[19];

PRIVATE
int	column_length;

EXEC SQL define FIFO_NAME ".  ";

/*
 * Local query ids etc.
 */

PRIVATE
FINAL
char *select_sid = "IULTsel_id";

PRIVATE 
FINAL 
char *insert_sid = "IULTins_id";

PRIVATE 
FINAL 
char *sqlda_desc = "IULT_desc";

EXEC SQL END DECLARE SECTION;

PRIVATE status _mystrtok(char *buf, char *token, int c);
PRIVATE int CountColumns(char *table);
PRIVATE void BuildInsertStatement(char *buffer, char *table, int columns);

/*{{ FUNCDOC 3
 *
 * Name 	: IULoadTable - load a compressed series of files into a table
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  IULoadTable(table, commit_threshold, compressed)
 *		  char *table;
 *		  int commit_threshold;
 *		  int compressed;
 *
 * Arguements	: table - name of the tables series and the destination table to load
 *
 *		  commit_threshold - execute a COMMIT WORK when the number of records
 *				     is reached.
 *
 *		  compressed - is the load file for this table compressed? 0 is FALSE
 *			       otherwise TRUE;
 *
 * Description	: IULoadTable takes the compressed input files produced by iexport
 *		  and inserts them into the table.
 *
 * Returns	: IU_SUCCESS or IU_ERTERROR on error.
 *
 * See Also	: IUDecompress(3), iexport(1) 
 *
 */

PUBLIC
status
IULoadTable(table, commit_threshold, compressed)
char *table;
int   commit_threshold;
int   compressed;
{
    FILE *cfp, *pfp;
    int child_pid;
    int records = 0;
    int child_status;
    char buf[ BUFFER_64K ];
    status ret_val = IU_SUCCESS;
    char table_unload[ PATH_MAX ];

    EXEC SQL BEGIN DECLARE SECTION; 

    int columns;
    int i;
    char statement[ BUFFER_4K ];
    char token[ BUFFER_64K ];
    int intrvl_len;

    EXEC SQL END DECLARE SECTION; 

    if((columns = CountColumns(table)) == 0)
	return IU_ERTERROR;

    BuildInsertStatement(statement, table, columns);

    EXEC SQL PREPARE :insert_sid FROM :statement;

    if(IUCheck(statement) != IU_SUCCESS)
	return IU_ERTERROR;

    /*
     * Now allocate space for the sqlda descriptor. No data space allocated yet.
     * If this succeeds, then we need to make sure that it is deallocated. No more
     * direct returns from now til end of function.
     */
    
    EXEC SQL ALLOCATE DESCRIPTOR :sqlda_desc;

    if(IUCheck("IULoadTable: ALLOCATE DESCRIPTOR")  != IU_SUCCESS)
	return IU_ERTERROR;

    /*
     * Allocate the space to hold the data which we will read from
     * the file. One per sqlvar_struct per column of this INSERT statement.
     */

    EXEC SQL DESCRIBE :insert_sid USING SQL DESCRIPTOR :sqlda_desc;

    if(IUCheck("IULoadTable: DESCRIBE statement")  != IU_SUCCESS)
    {
	ret_val = IU_ERTERROR;
	goto deallocate_sqlda;
    }


    /*
     * Start a child to decompress the data from the file series to
     * the other end of a pipe. Not particularly efficient but it works.
     * We don't go for our own process group with this child so that we
     * can still pass messages back to the controlling terminal.
     */

    switch(child_pid = fork())
    {
	case -1:
	    ret_val = errno;
	    Error(errno, "IULoadTable.fork", "175");
	    goto deallocate_sqlda;

	case 0: /* CHILD */

	    unlink(FIFO_NAME);

	    if(mkfifo(FIFO_NAME, (S_IRUSR | S_IWUSR)) == -1)
	    {
		Error(errno, "IULoadTable~{CHILD}.mkfifo", "184");
		exit(1);
	    }

	    if((cfp = fopen(FIFO_NAME, "w")) == (FILE *)NULL)
	    {
		Error(errno, "IULoadTable~{CHILD}.fopen", "190");
		exit(1);
	    }

	    strcpy(table_unload, table);
	    strcat(table_unload, ".unl");

	    /*
	     * Is this iimport or dbimport format
	     */

	    if(compressed)
	    {
		if(IUDecompress(table_unload, cfp) != IU_SUCCESS)
		{
		    fprintf(stderr,
			"IULoadTable~{CHILD}.IUDecompress: Decompress of %s failed\n", 
			    table_unload);
		    exit(1);
		}
	    }
	    else
	    {
		FILE *fp;

		if((fp = fopen(table_unload, "r")) == (FILE *)NULL)
		{
		    fprintf(stderr, "load of file %s into table %s failed\n", 
								table_unload, table);
		    exit(1);
		}

		while(fread(buf, BUFFER_64K, 1, fp) == 1)
		{
		    if(fwrite(buf, BUFFER_64K, 1, cfp) != 1)
		    {
			Error(errno, "IULoadTable~{CHILD}.fwrite\n", "226");
			exit(1);
		    }
		}
	    }

	    unlink(FIFO_NAME);

	    exit(0);
	    /*NOTREACHED*/

	default: /* PARENT */


	    /*
	     * Dad here. Wait a second for kiddy to get things going and
	     * hopefully block on write at the start of pipe.
	     */

	    if((pfp = fopen(".  ", "r")) == (FILE *)NULL)
	    {
		Error(errno, "IULoadTable~{PARENT}.fopen", "247");
		ret_val = IU_ERTERROR;
	    }

	    /* 
	     * We are now reading uncompressed data from the pipe, 
	     * one row at at time.
	     */

	    while(fgets(buf, BUFFER_64K, pfp) != (char *)NULL)
	    {
		char *ptr;
		
		for(i = 1, ptr = buf; i <= columns && 
				_mystrtok(ptr, token, '|') == IU_SUCCESS; i++) 
		{
		    ptr = (char *)NULL;


		    /*
		     * Find out the type of the column and it's name
		     */

		    EXEC SQL 
		    GET DESCRIPTOR 
			:sqlda_desc 
		    VALUE 
		        :i
			:column_type = TYPE, 
			:column_name = NAME,
			:column_length = LENGTH;

		    if(IUCheck("IULoadTable: GET DESCRIPTOR") != IU_SUCCESS)
		    {
			ret_val = IU_ERTERROR;
			goto deallocate_sqlda;
		    }

		    if (*token)
		    {
			if(column_type == SQLDTIME || column_type == SQLINTERVAL)
			{
			    EXEC SQL 
			    SET DESCRIPTOR 
				:sqlda_desc 
			    VALUE :i 
			    TYPE      = :column_type,
			    LENGTH    = :column_length, 
			    DATA      = :token, 
			    INDICATOR = 0;
			}
			else
			{
			    EXEC SQL 
			    SET DESCRIPTOR 
				:sqlda_desc 
			    VALUE :i 
			    TYPE      = :column_type,
			    LENGTH    = 0,
			    DATA      = :token, 
			    INDICATOR = 0;
			}
		    }
		    else /* NULL value, set indicator with no data */
			EXEC SQL SET DESCRIPTOR :sqlda_desc VALUE :i INDICATOR = -1;

		    if(IUCheck("IULoadTable: SET DESCRIPTOR") != IU_SUCCESS)
		    {
			ret_val = IU_ERTERROR; 
			goto deallocate_sqlda;
		    }
		}

		if((++records % commit_threshold) == 0)
		    IUTransaction(BEGINWORK);

		EXEC SQL EXECUTE :insert_sid USING SQL DESCRIPTOR :sqlda_desc;

		if(IUCheck("IULoadTable: EXECUTE INSERT") != IU_SUCCESS)
		{
		    ret_val = IU_ERTERROR; 
		    goto deallocate_sqlda;
		}

		if((records % commit_threshold) == 0)
		{
		    IUTransaction(COMMITWORK);
		    printf("%d inserted\n", records);
		}
	    }

	    (void) fclose(pfp);

	    (void) wait(&child_status);
    }

deallocate_sqlda:

    IUTransaction(COMMITWORK);

    printf("%d Records inserted into %s\n", records, table);

    EXEC SQL DEALLOCATE DESCRIPTOR :sqlda_desc;

    return ret_val;
}


/*
 * Return the number of columns in a table
 */

EXEC SQL BEGIN DECLARE SECTION; 

PRIVATE
FINAL
char *CC_count_sid = "IULTCC_sid";

PRIVATE 
FINAL
char *CC_sqlda = "IULTCC_da";

EXEC SQL END DECLARE SECTION; 

PRIVATE
int
CountColumns(table)
char *table;
{
    EXEC SQL BEGIN DECLARE SECTION; 
    int count = 0;
    char query[ BUFFER_1K ];
    EXEC SQL END DECLARE SECTION; 

    sprintf(query, "SELECT * FROM %s;", table);

    EXEC SQL PREPARE :CC_count_sid FROM :query;   

    if(IUCheck(query) != IU_SUCCESS)
	return 0;

    EXEC SQL ALLOCATE DESCRIPTOR :CC_sqlda;

    if(IUCheck("IULoadTable.CountColumns: ALLOCATE DESCRIPTOR") != IU_SUCCESS)
	return 0;

    EXEC SQL DESCRIBE :CC_count_sid USING SQL DESCRIPTOR :CC_sqlda;

    if(IUCheck("IULoadTable.CountColumns: DESCRIBE DESCRIPTOR") != IU_SUCCESS)
	return 0;

    /* 
     * Now we can check how many columns we are 
     * dealing with. 
     */

    EXEC SQL GET DESCRIPTOR :CC_sqlda :count = COUNT;

    if(IUCheck("IULoadTable.CountColumns: GET DESCRIPTOR") != IU_SUCCESS)
	return 0;

    EXEC SQL DEALLOCATE DESCRIPTOR :CC_sqlda;

    return count;
}

/*
 * Name 	: BuildInsertStatement - construct a parameterised INSERT statement
 *
 * Synopsis	: PRIVATE
 *                void
 *                BuildInsertStatement(buffer, table, columns)
 *                char *buffer;
 *                char *table;
 *                int   columns;
 *
 * Arguments	: buffer - destination for the completed statement
 *
 *		  table - name of table for insert statement.
 *
 *		  columns - the number of columns in this table;
 *
 * Description	: 
 *
 * Returns	:
 *
 * See Also	:
 *
 */

PRIVATE
void
BuildInsertStatement(buffer, table, columns)
char *buffer;
char *table;
int   columns;
{
    int i;

    (void) sprintf(buffer, "INSERT INTO %s VALUES (", table);

    for( i = 1; i <= columns; i++)
    {
	(void) strcat(buffer, "?");

	if ( i != columns)
	    (void) strcat(buffer, ",");
    }

    (void) strcat(buffer, ");");
}

/*
 * Name 	: _mystrtok - ESQL/C version of strtok  
 *
 * Synopsis	: PRIVATE
 *		  status
 *		  _mystrtok(buf, token, c)
 *		  char *buf;
 *		  char token[];
 *		  int c;
 *
 * Arguments	: buf - buffer containing line read from unload file 
 *
 *		  token - destination for the token 
 *
 *		  c - delimiting character 
 *
 * Description	: _mystrtok was needed because strtok does not return 
 *		  empty tokens, thus not allowing you to insert null
 *		  values into the column.
 *
 * Returns	:
 *
 */

PRIVATE 
status
_mystrtok(buf, token, c)
char *buf;
char token[];
int c;
{
    static char *held;
    static char *hptr;
    char *tptr = token;

    if(buf != (char *)NULL)
    {
	int len;

	free(held);

	if((held = (char *)malloc((len = strlen(buf)))) == (char *)NULL)
	    return Error(errno, "IULoadTable._mystrtok.malloc", "%C");

	memcpy(held, buf, len);
	hptr = held;
    }

    while(*hptr != '\0')
    {
	if(*hptr == c)
	{
	    hptr++;
	    *tptr = '\0';
	    return IU_SUCCESS;
	}

	*tptr++ = *hptr++;
	*tptr = '\0';
    }
    return IU_NODATA;
}
	
#ifdef TEST

main()
{
    char conname[ 10 ];
    struct stat sb;
    EXEC SQL BEGIN DECLARE SECTION; 
    int count;
    EXEC SQL END DECLARE SECTION; 

    if(IUDBConnect("migratedb", conname) != IU_SUCCESS)
    {
	fprintf(stderr, "Cannot connect to store7");
	exit(1);
    }

    if(chdir("dbtarget.cexp") == -1)
    {
	fprintf(stderr, "No compressed export to work with\n");
	exit(1);
    }

    if(stat("manufact.unl.000.Z", &sb) == -1)
    {
	fprintf(stderr, "Cannot open compressed customer file\n");
	exit(1);
    }

    EXEC SQL DELETE FROM manufact where 1 = 1;

    IULoadTable("manufact");
}

#endif
