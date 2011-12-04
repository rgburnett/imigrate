#include <sqlhdr.h>
#include <sqlca.h>
extern _SQCURSOR *_iqnprep();

#if !defined(__STDC__)
#define const 
#endif

#line 1 "iexport.ec"

























































/* 
 * EXEC SQL define MAIN;
 */
#line 58 "iexport.ec"
#define MAIN

#include <pthread.h>
#include <sys/stat.h>
#include <signal.h>

#include "c.incl.h"
#include "c.defs.h"
/* 
 * EXEC SQL include "esql.defs.h";
 */
#line 67 "iexport.ec"
#line 67 "iexport.ec"
#line 1 "../incl/esql.defs.h"
#ifndef _ESQLDEFSINCLUDED
#define _ESQLDEFSINCLUDED

























/* 
 * EXEC SQL define PUBLIC;
 */
#line 28 "../incl/esql.defs.h"
/* 
 * EXEC SQL define FINAL	const;	
 */
#line 29 "../incl/esql.defs.h"
/* 
 * EXEC SQL define PRIVATE static;
 */
#line 30 "../incl/esql.defs.h"








/* 
 * EXEC SQL ifdef MAIN;
 */
#line 39 "../incl/esql.defs.h"
/* 
 * EXEC SQL 	define GLOBAL;
 */
#line 40 "../incl/esql.defs.h"
/* 
 * EXEC SQL else;
 */
#line 41 "../incl/esql.defs.h"
/* 
 * EXEC SQL endif;
 */
#line 43 "../incl/esql.defs.h"






/* 
 * EXEC SQL ifndef FALSE;
 */
#line 50 "../incl/esql.defs.h"
/* 
 * EXEC SQL 	define FALSE 0;
 */
#line 51 "../incl/esql.defs.h"
/* 
 * EXEC SQL endif;
 */
#line 52 "../incl/esql.defs.h"

/* 
 * EXEC SQL ifndef TRUE;
 */
#line 54 "../incl/esql.defs.h"
/* 
 * EXEC SQL 	define TRUE 1;
 */
#line 55 "../incl/esql.defs.h"
/* 
 * EXEC SQL endif;
 */
#line 56 "../incl/esql.defs.h"


/* 
 * EXEC SQL define STACKINCREMENT 100;
 */
#line 59 "../incl/esql.defs.h"





/* 
 * EXEC SQL define    INDEXES	  00000001;
 */
#line 65 "../incl/esql.defs.h"
/* 
 * EXEC SQL define    TRIGGERS	  00000002;
 */
#line 66 "../incl/esql.defs.h"
/* 
 * EXEC SQL define    CONSTRAINTS	  00000004;
 */
#line 67 "../incl/esql.defs.h"

/* 
 * EXEC SQL define MIGRATE_DEFAULT		"/export/database";
 */
#line 69 "../incl/esql.defs.h"
/* 
 * EXEC SQL define TABLENAMELEN		19;
 */
#line 70 "../incl/esql.defs.h"
/* 
 * EXEC SQL define MAX_SQL_BUF		4096;
 */
#line 71 "../incl/esql.defs.h"
/* 
 * EXEC SQL define INFORMIX_NAME_LEN	19;
 */
#line 72 "../incl/esql.defs.h"


/* 
 * EXEC SQL define DEBUG	printf;
 */
#line 75 "../incl/esql.defs.h"

/* 
 * EXEC SQL define NODEBUG (void);
 */
#line 77 "../incl/esql.defs.h"

/* 
 * EXEC SQL define WARNNOTIFY	1;
 */
#line 79 "../incl/esql.defs.h"
/* 
 * EXEC SQL define NOWARNNOTIFY	0;
 */
#line 80 "../incl/esql.defs.h"
/* 
 * EXEC SQL define MAX_CONNECTIONS	10;
 */
#line 81 "../incl/esql.defs.h"

/* 
 * EXEC SQL define CONFREE   0;
 */
#line 83 "../incl/esql.defs.h"
/* 
 * EXEC SQL define CONACTIVE 1;
 */
#line 84 "../incl/esql.defs.h"

/* 
 * EXEC SQL define CREATEDATABASE 1;
 */
#line 86 "../incl/esql.defs.h"
/* 
 * EXEC SQL define DROPDATABASE 2;
 */
#line 87 "../incl/esql.defs.h"

/* 
 * EXEC SQL define CREATEDBSPACE 0x1;
 */
#line 89 "../incl/esql.defs.h"
/* 
 * EXEC SQL define DROPDBSPACE   0x2;
 */
#line 90 "../incl/esql.defs.h"
/* 
 * EXEC SQL define ADDCHUNK      0x8;
 */
#line 91 "../incl/esql.defs.h"
/* 
 * EXEC SQL define DROPCHUNK     0x10;
 */
#line 92 "../incl/esql.defs.h"
/* 
 * EXEC SQL define STARTMIRROR   0x20;
 */
#line 93 "../incl/esql.defs.h"
/* 
 * EXEC SQL define ENDMIRROR     0x40;
 */
#line 94 "../incl/esql.defs.h"
/* 
 * EXEC SQL define CHUNKDOWN     0x80;
 */
#line 95 "../incl/esql.defs.h"
/* 
 * EXEC SQL define CHUNKONLINE   0x100;
 */
#line 96 "../incl/esql.defs.h"
/* 
 * EXEC SQL define DATASKIPOFF   0x200;
 */
#line 97 "../incl/esql.defs.h"
/* 
 * EXEC SQL define DATASKIPON    0x400;
 */
#line 98 "../incl/esql.defs.h"

/* 
 * EXEC SQL define TRANSBEGIN	20983;
 */
#line 100 "../incl/esql.defs.h"
/* 
 * EXEC SQL define TRANSEND	213658;
 */
#line 101 "../incl/esql.defs.h"

#endif
#line 103 "../incl/esql.defs.h"
#line 68 "iexport.ec"
#include "c.class.h"
/* 
 * EXEC SQL include "esql.class.h";
 */
#line 69 "iexport.ec"
#line 69 "iexport.ec"
#line 1 "../incl/esql.class.h"
#ifndef _ESQLCLASSINCLUDED
#define _ESQLCLASSINCLUDED























/*
 * EXEC SQL BEGIN DECLARE SECTION;
 */
#line 26 "../incl/esql.class.h"

#line 27 "../incl/esql.class.h"
typedef struct _connectioninfo
  {
    char informix_server[19];
    char connection_type[19];
    char host[ PATH_MAX ];
    char server_ent[19];
  }  connectioninfo;
typedef struct _columninfo
  {
    int type;
    int len;
    int nullable;
    int is_null;
    char name[19];
  }  columninfo;
typedef struct _dbspace
  {
    int op;
    char spacename[18];
    int pagesize;
    char path[ PATH_MAX ];
    int offset;
    int size;
    int tmp;
    char mirror_path[ PATH_MAX ];
    int mirror_offset;
  }  dbspace;
/*
 * EXEC SQL END DECLARE SECTION;
 */
#line 65 "../incl/esql.class.h"


#endif
#line 67 "../incl/esql.class.h"
#line 70 "iexport.ec"
#include "error.class.h"
#include "c.proto.h"
/* 
 * EXEC SQL include "esql.proto.h";
 */
#line 72 "iexport.ec"
#line 72 "iexport.ec"
#line 1 "../incl/esql.proto.h"
#ifndef _ESQLPROTOINCLUDED
#define _ESQLPROTOINCLUDED





















PUBLIC status	Error(status type, char *module, char *lineno);
PUBLIC status   IUDBConnect(char *database, char *conname);
PUBLIC status   IUCheck(char *statement);
PUBLIC status   IUCheckSQLCode(char *statement);
PUBLIC status   IUColumnInfo(columninfo *colobj, int index);
PUBLIC status	IUCompress(FILE *instream, char *fileseries);
PUBLIC status 	IUConstraints(char *tablename, int type, ConstraintOperation operation);
PUBLIC status	IUDatabase(int op, char *dbname, char *which_space);
PUBLIC status 	IUDBDisconnect(char *conname);
PUBLIC int	IUDBObjectExists(char *database, dbobjclass objtype, char *objname);
PUBLIC status	IUDecompress(char *fileseries, FILE *outstream);
PUBLIC status	IUDirectory(list *alist, char *path);
PUBLIC void	IUDisplayError(char *statement);
PUBLIC void	IUDisplayException(char *statement, int sqlerr_code, int warn_flag);
PUBLIC void	IUDisplaySQLStateError();
PUBLIC void	IUDisplayShortError();
PUBLIC void	IUDisplayWarning(char *statement);
PUBLIC status	IUExpressionCheck(char *statement, int warn_flag);
PUBLIC status	IUListTables(list *alist, char *dbname);
PUBLIC status	IUMasterTableList(char *tablename, list *alist);
PUBLIC status	IURenameTable(char *database, char *from, char *to);
PUBLIC status	IURunSQL(char *dmlstatement, FILE *output, sqlerrors report);
PUBLIC status	IUSQLStateError();
PUBLIC status	IUUnloadTable(char *table, FILE *outstream);
PUBLIC status	IULoadTable(char *tableseries, int commit_threshold, int compress);
PUBLIC status	IUTransactin(int op);
PUBLIC status	IUTime();

#endif
#line 52 "../incl/esql.proto.h"
#line 73 "iexport.ec"
#include "global.h"

static char *sccsid = "SCCS: %W% Continuus: %subsystem: % %filespec: %";

static void  exportUsage();
static status ExportDatabase();
static status threadpairExportTable(char *table);
static void *threadDbSchema(void *arg);
static void *threadPipeWriter(void *arg);
static void *threadPipeReader(void *arg);

#define ARGVAL() (*++(*argv) || (--argc && *++argv))

typedef struct _iexportglobals
{
    char 	database[ 19 ];
    int		threadcount;
    pthread_t	thread_id[ 10 ];
    rwlock_t	nthreadsmutex;
}
global_vars;

global_vars global;


static
void
iexportUsage()
{
    (void) fprintf(stderr, "Usage: iexport <existing database>\n");
/*
 *     EXEC SQL DISCONNECT ALL;
 */
#line 103 "iexport.ec"
  {
#line 103 "iexport.ec"
  _iqdisconnect(2, (char *) 0, 0, 0);
#line 103 "iexport.ec"
  }
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



    strcpy(global.database, argv[ 1 ]);

/*
 *     EXEC SQL DATABASE "sysmaster";
 */
#line 125 "iexport.ec"
  {
#line 125 "iexport.ec"
  _iqdbase("sysmaster", 0);
#line 125 "iexport.ec"
  }

    if((retval = IUCheck("DATABASE sysmaster")) != IU_WARNING)
    {
	Error(retval, "iexport: Cannot connect to sysmaster!\n", "%C%");
	exit(1);
    }


    if(IUDBObjectExists("sysmaster", DATABASE, global.database) != IU_SUCCESS)
    {
	fprintf(stderr, "iexport: non-existant database [ %s ]\n", global.database);
/*
 * 	EXEC SQL DISCONNECT ALL;
 */
#line 137 "iexport.ec"
  {
#line 137 "iexport.ec"
  _iqdisconnect(2, (char *) 0, 0, 0);
#line 137 "iexport.ec"
  }
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



















static
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





    if(pthread_create(&thread_obj, NULL, threadDbSchema, (void *)global.database))
	return Error(errno, "iexport.ExportDatabase.pthread_create", "%C%");

    global.threadcount = 1;

    if((retval = IUListTables(&tablelist, (char *)NULL)) == IU_ERTERROR)
	return Error(retval, "iexport.ExportDatabase: can't build table list", "%C%");

    for(lptr = tablelist; DATA(lptr); lptr = NEXT(lptr))
	if((retval = threadpairExportTable((void *)DATA(lptr))) != IU_SUCCESS)
	    return retval;






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

}






static
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


	



	if( count >= (10 - 2))
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

static
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



    free(dbconn);
    free(pipename);

    fflush(sendfp);
    fclose(sendfp);

    pthread_exit(NULL);
}


static
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



    free(pipename);

    pthread_exit(0);
}
























static
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

#line 441 "iexport.ec"
