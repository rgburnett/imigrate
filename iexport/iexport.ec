/*
 * File		: iexport.ec
 * 
 * Sccs		: %W% 
 *
 * Dated	: %D% %T% 
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

/*{{ TOOLDOC 1
 *
 * Name 	: iexport - capture a database snapshot for data migration 
 *
 * Synopsis	: iexport database
 *
 * Arguments	: database 	- name of a database
 *
 * Description	: iexport exports the contents of all tables within a database
 *		  to a series of compressed output files and a copy of the 
 *		  database schema withing a directory called 
 *		  <databasename>.cexp.
 *
 * Options	: none 
 *
 * Notes	: The name of the export directory is suffixed by .cexp to signify
 *		  a compressed export.
 *
 *		  The standard informix utility dbexport provides the same 
 *		  functionality with one large caveat: it cannot handle tables
 *		  where the size exceeds the current hard ulimit. As we are 
 *		  regularily dealing with volumes far in excess of this, the 
 *		  need for this tool becomes apparent.
 *
 *		  All exported files are held as compress(1) files and, if need
 *		  be, can be uncompress(1)ed.
 *
 * Status	: SUPPORTED 
 *
 * See Also	: iimport(1DB)
 *
 */

/*
 * Need to define MAIN both in the esql and C domains
 */

EXEC SQL define MAIN;
#define MAIN

#include <pthread.h>
#include <sys/stat.h>
#include <signal.h>

#include "c.incl.h"
#include "c.defs.h"
EXEC SQL include "esql.defs.h";
#include "c.class.h"
EXEC SQL include "esql.class.h";
#include "error.class.h"
#include "c.proto.h"
EXEC SQL include "esql.proto.h";
#include "global.h"

PRIVATE char *sccsid = "SCCS: %W% Continuus: %subsystem: % %filespec: %";

PRIVATE void  exportUsage();
PRIVATE status ExportDatabase();
PRIVATE status threadpairExportTable(char *table);
PRIVATE void *threadDbSchema(void *arg);
PRIVATE void *threadPipeWriter(void *arg);
PRIVATE void *threadPipeReader(void *arg);

#define ARGVAL() (*++(*argv) || (--argc && *++argv))

typedef struct _iexportglobals 
{
    char 	database[ INFORMIX_NAME_LEN ];
    int		threadcount;
    pthread_t	thread_id[ MAX_CONNECTIONS ];
    rwlock_t	nthreadsmutex;
}
global_vars;

global_vars global;


PRIVATE
void
iexportUsage()
{
    (void) fprintf(stderr, "Usage: iexport <existing database>\n");
    EXEC SQL DISCONNECT ALL;
    exit(1);
}

PUBLIC
int
main(argc, argv, envp)
int argc;
char *argv[];
char *envp[];
{
    struct stat sb;
    char dir[ PATH_MAX ];
    status retval;

    if(argc != 2)
	iexportUsage();

    /*IULog("iexport.log");*/

    strcpy(global.database, argv[ 1 ]);

    EXEC SQL DATABASE "sysmaster";

    if((retval = IUCheck("DATABASE sysmaster")) != IU_WARNING)
    {
	Error(retval, "iexport: Cannot connect to sysmaster!\n", "%C%");
	exit(1);
    }


    if(IUDBObjectExists("sysmaster", DATABASE, global.database) != IU_SUCCESS)
    {
	fprintf(stderr, "iexport: non-existant database [ %s ]\n", global.database);
	EXEC SQL DISCONNECT ALL;
	exit(1);
    }

    printf("Unloading Database [ %s ]\n", global.database);

    sprintf(dir, "%s.cexp", global.database);

    if(stat(dir, &sb) != 0)
    {
	if(mkdir(dir, 0755) == -1)
	{
	    char msg[ PATH_MAX ];
	    int saved_errno = errno;

	    sprintf(msg, "iexport: cannot create export directory %s", dir);

	    Error(saved_errno, msg, "%C%");

	    exit(1);
	}
    }

    chdir(dir);

    ExportDatabase();

    exit(0);
}

/*
 *
 * Name 	: ExportDatabase - export an Informix database.
 *
 * Synopsis	: PRIVATE
 *		  void
 *		  ExportDatabase()
 *
 * Arguments	: databasename - the name of the database to export
 *
 * Description	: ExportDatabase
 *
 * Returns	: status values of IU_SUCCESS or IU_ERTERROR
 *
 * See Also	: IUCompress(), IUListTables()
 *
 */

PRIVATE
status
ExportDatabase()
{
    int count;
    list tablelist, lptr;
    pthread_t thread_obj;
    status retval;
    int t;

    ListInitialise(&tablelist);
    rwlockInit(&global.nthreadsmutex);

    /*
     * Kick off a thread to run a dschema of the database
     */

    if(pthread_create(&thread_obj, NULL, threadDbSchema, (void *)global.database))
	return Error(errno, "iexport.ExportDatabase.pthread_create", "%C%");

    global.threadcount = 1; /* only one thread is running so don't worry */

    if((retval = IUListTables(&tablelist, (char *)NULL)) == IU_ERTERROR)
	return Error(retval, "iexport.ExportDatabase: can't build table list", "%C%");

    for(lptr = tablelist; DATA(lptr); lptr = NEXT(lptr))
	if((retval = threadpairExportTable((void *)DATA(lptr))) != IU_SUCCESS)
	    return retval;

    /*
     * All threads have been dispatched by now. We are waiting for the
     * last ten threads to finish 
     */

    for(;;)
    {
	int count;

	printf("Loopity loop\n");

	rwlockLockRead(&global.nthreadsmutex);

	count = global.threadcount;

	rwlockUnlockRead(&global.nthreadsmutex);

	if(count == 0);
	    return IU_SUCCESS;

	sleep(1);
    }
    /*NOTREACHED*/
}

/*
 * Start off two threads to export this table
 *
 */

PRIVATE
status
threadpairExportTable(table)
char *table;
{
    int i;

    for(;;)
    {
	int count = 0;

	rwlockLockRead(&global.nthreadsmutex);

	count = global.threadcount;

	rwlockUnlockRead(&global.nthreadsmutex);


	/*
	 * We need to start up in pairs
	 */

	if( count >= (MAX_CONNECTIONS - 2))
	{
	    sleep(1);
	    continue;
	}
	else 
	    break;
    }
    sleep(1);

    rwlockLockWrite(&global.nthreadsmutex);

    if(pthread_create(&global.thread_id[ global.threadcount ], NULL, 
						threadPipeWriter, (void *)table))
    {
	rwlockUnlockWrite(&global.nthreadsmutex);
	return Error(errno, "iexport.threadpairExporTable.pthread_create", "%C%");
    }

    sleep(1);


    if(pthread_create(&global.thread_id[ global.threadcount + 1 ], NULL, 
							threadPipeReader, (void *)table))
    {
	pthread_kill(global.thread_id[ global.threadcount ], SIGTERM);
	rwlockUnlockWrite(&global.nthreadsmutex);

	return Error(errno, "iexport.threadpairExportTable", "%C%");
    }

    global.threadcount += 2;

    rwlockUnlockWrite(&global.nthreadsmutex);

    return IU_SUCCESS;
}

PRIVATE 
void *
threadPipeWriter(arg)
void *arg;
{
    char *dbconn;
    char *pipename;
    char *tablename = (char *)arg;
    FILE *sendfp = (FILE *)NULL;
    status retval = IU_SUCCESS;


    if((dbconn = (char *)malloc(10)) == (char *)NULL)
    {
	Error(errno, "iexport.threadPipeWriter.malloc: dbconn", "%C%");
	goto shutdown;
    }

    if((pipename = (char *)malloc(PATH_MAX)) == (char *)NULL)
    {
	Error(errno, "iexport.threadPipeWriter.malloc: pipename", "%C%");
	goto shutdown;
    }

    if((retval = IUDBConnect(global.database, dbconn)) != IU_SUCCESS)
    {
	Error(IU_EDBCONNECT, "iexport.threadPipeWriter.IUDBConnect", "%C%");
	goto shutdown;
    }

    pause();

    (void) sprintf(pipename, ".%s.pipe", tablename);

    if(mkfifo(pipename, 0600))
    {
	Error(errno, "iexport.threadPipeWriter.mkfifo", "%C%");
	goto shutdown;
    }

    if((sendfp = fopen(pipename, "w")) == (FILE *)NULL)
    {
	Error(errno, "iexport.threadPipeWriter.fopen", "%C%");
	goto shutdown;
    }

    pause();

    if(IUUnloadTable(tablename, sendfp) == IU_ERTERROR)
	Error(IU_ERTERROR, "iexport.threadPipeWriter.IUUnloadTable", "%C%");

shutdown:

    /*unlink(pipename);*/

    free(dbconn);
    free(pipename);

    fflush(sendfp);
    fclose(sendfp);

    pthread_exit(NULL);
}


PRIVATE
void *
threadPipeReader(arg)
void *arg;
{
    char *pipename;
    char *tablename = (char *)arg;
    FILE *recvfp = (FILE *)NULL;

    if((pipename = (char *)malloc(PATH_MAX)) == (char *)NULL)
    {
	Error(errno, "iexport.threadPipeReader.malloc: pipename", "%C%");
	goto shutdown;
    }

    (void) sprintf(pipename, ".%s.pipe", tablename);

    if((recvfp = fopen(pipename, "r")) == (FILE *)NULL)
    {
	Error(errno, "iexport.threadPipeReader.fopen", "%C%");
	goto shutdown;
    }

    if(IUCompress(recvfp, tablename) != IU_SUCCESS)
	Error(IU_ERTERROR, "iexport.threadPipeReader.IUCompress", "%C%");

shutdown:

    /*unlink(pipename);*/

    free(pipename);

    pthread_exit(0);
}

/*
 * Name 	: threadDbSchema - thread to perform a dbschema
 *
 * Synopsis	: PRIVATE
 *		  void
 *		  threadDbSchema(databasename)
 *		  char *databasename;
 *
 * Arguments	: databasename - name of the database to dbschema
 *
 * Description	: threadDbSchema will perform a dbschema of a database and output
 *		  the stuff to a file called database.sql 
 *
 * Notes	: There is a small problem with using dbschema: the first four
 *		  lines are not needed, so we do a naughty call to sed within
 *		  the execution of dbschema
 *
 * Returns	: void 
 *
 * See Also	: dbschema(1INF)
 *
 */

PRIVATE
void *
threadDbSchema(arg)
void *arg;
{
    char cmd[ PATH_MAX ];
    char *databasename = (char *)arg;

    printf("UID is %d\n", getuid());

    sprintf(cmd, "dbschema -d %s | sed '1,4d' > %s.sql", databasename, databasename); 
    system(cmd);

    pthread_exit(0);
}
