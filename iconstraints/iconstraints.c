#include <sqlhdr.h>
#include <sqlca.h>
extern _SQCURSOR *_iqnprep();

#if !defined(__STDC__)
#define const 
#endif

#line 1 "iconstraints.ec"























































/* 
 * EXEC SQL define MAIN;
 */
#line 56 "iconstraints.ec"
#define MAIN

/* 
 * EXEC SQL include "iconstraints.h";
 */
#line 59 "iconstraints.ec"
#line 59 "iconstraints.ec"
#line 1 "iconstraints.h"
#ifndef _ICONSTRAINTSH
#define _ICONSTRAINTSH





















#define ARGVAL() (*++(*argv) || (--argc && *++argv))

#include "c.incl.h"
#include "c.defs.h"
/* 
 * EXEC SQL include "esql.defs.h";
 */
#line 28 "iconstraints.h"
#line 28 "iconstraints.h"
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
#line 29 "iconstraints.h"
#include "c.class.h"
/* 
 * EXEC SQL include "esql.class.h";
 */
#line 30 "iconstraints.h"
#line 30 "iconstraints.h"
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
#line 31 "iconstraints.h"
#include "error.class.h"
#include "c.proto.h"
/* 
 * EXEC SQL include "esql.proto.h";
 */
#line 33 "iconstraints.h"
#line 33 "iconstraints.h"
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
#line 34 "iconstraints.h"
#include "global.h"





struct _globals
{

    char database[ 256 ];
    char **tables;
    int  optype;
    ConstraintOperation operation;
};

GLOBAL struct _globals global
#ifdef MAIN
=
{
    "",
    (char **)NULL,
    0,
    ENABLED
}
#endif
;





static status ParseArgs(int argc, char **argv, char **envp);
static void iconstraintsUsage();

#endif
#line 68 "iconstraints.h"
#line 60 "iconstraints.ec"

static
char *sccsid = "SCCS: %W% Continuus: %subsystem: % %filespec: %";

static
void
iconstraintsUsage()
{
    fprintf(stderr, "iconstraints <database> table ... [ -e | -d ] [ -c -i -t ]\n");
/*
 *     EXEC SQL DISCONNECT ALL;
 */
#line 69 "iconstraints.ec"
  {
#line 69 "iconstraints.ec"
  _iqdisconnect(2, (char *) 0, 0, 0);
#line 69 "iconstraints.ec"
  }
    exit(1);
}

extern char **environ;

main(argc, argv, envp)
int argc;
char **argv;
char **envp;
{
    char dbconn[ 10 ];
    char **ptr;

    ParseArgs(argc, argv, envp);

    if((IUDBConnect(global.database, dbconn)) == IU_SUCCESS)
    {
	fprintf(stderr, "iconstraints: couldn't connect to %s\n", global.database);
	exit(1);
    }

    for(ptr = global.tables; *ptr; ptr++)
	IUConstraints(*ptr, global.optype, global.operation);

    IUDBDisconnect(dbconn);

    exit(0);
}


























static
status
ParseArgs(argc, argv, envp)
int    argc;
char **argv;
char **envp;
{
    char **tbptr;
    int Tables = 0;

    if(argc <= 0 || (*argv == (char *)NULL) || (*envp == (char *)NULL))
	return Error(IU_EINVALIDARG, "iconstraints.ParseArgs", "%C%");

    if((global.tables = tbptr = (char **)(malloc(argc * sizeof(*argv)))) ==
	(char **)NULL)
	return Error(errno, "iconstraints.ParseArgs.malloc", "%C%");

    *global.tables = (char *)NULL;

    for (argc--, argv++; argc > 0; argc--, argv++)
    {
	if (**argv == '-')
	{
	    while (*++(*argv))
	    {
		switch (**argv)
		{
		    case 'E':
		    case 'e':
			    global.operation = ENABLED;
			break;

		    case 'D':
		    case 'd':
			    global.operation = DISABLED;
			break;
			
		    case 't':
		    case 'T':
			global.optype | 00000002;
			break;

		    case 'I':
		    case 'i':
			global.optype | 00000001;
			break;

		    case 'C':
		    case 'c':
			global.optype | 00000004;
			break;

		    default:
			iconstraintsUsage();
		}
	    }
	}
	else
	{
	    if(Tables)
	    {
		*tbptr++ = *argv;
		*tbptr = NULL;
	    }
	    else
	    {
		Tables = 1;
		strcpy(global.database, *argv);
	    }
	}
	nextarg:
	    continue;
    }
    return IU_SUCCESS;
}

#line 198 "iconstraints.ec"
