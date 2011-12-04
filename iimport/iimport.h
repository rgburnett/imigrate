/*
 * Sccs id	: @(#)iimport.h	1.4
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
#include "c.defs.h"
EXEC SQL include "esql.defs.h";
#include "c.class.h"
#include "error.class.h"
EXEC SQL include "esql.class.h";
#include "c.proto.h"
EXEC SQL include "esql.proto.h";
#include "global.h"

#define ARGVAL() (*++(*argv) || (--argc && *++argv))

#define COMPRESSED_IEXPORT_DIR	".cexp"
#define DBEXPORT_DIR		".exp"
#define OCCUPANCY 90
#define DEFAULT_DBSPACE "migratedbs"
#define DEFAULT_DBNAME  "migratedb"
#define PAGE_SIZE 4096

#define COMMIT_THRESHOLD	1000

/*
 * Global Program Variables
 */

struct _globals
{
    char database[ INFORMIX_NAME_LEN ];	
    int	 occupancy;
    char preprocessfile[ PATH_MAX ];
    int  max_chunk_size;
    int max_vio_rows;
    char migrate_dir[ PATH_MAX ];
    char source_dir[ PATH_MAX ];
    int compressed;
    int commit_threshold;
    int has_violations;
};


struct _sqlstatment
{
    int type;
    char *tablename;
    char *statement;
};

typedef struct _TargetTable 
{
    char tablename[ 256 ];		/* Name of the current "live" table */
    char table_vio[ 256 ];		/* name of the violations table for above */
    char table_dia[ 256 ];		/* name of the diagnostics table for above */
    char shortname[ TABLENAMELEN ];	/* name without the "owner". bit in front */
}
TargetTable;

typedef struct _MigrateTable 
{
    char tablename[ 256 ];		/* Name of the current "live" table */
    char table_vio[ 256 ];		/* name of the violations table for above */
    char table_dia[ 256 ];		/* name of the diagnostics table for above */
    char shortname[ TABLENAMELEN ];	/* name without the "owner". bit in front */
    char sqlbuf[ MAX_SQL_BUF ];		/* the sql statement to create it */
}
MigrateTable;

/*
 * Macro to access the elements of this structure
 */

#define MigrateTableAttr(ptr, member)	((MigrateTable *)DATA(ptr))->member
#define TargetTableAttr(ptr, member)	((TargetTable *)DATA(ptr))->member

/*
 * All global variables are clearly marked by storing them in a global structure
 * which is initialised in the MAIN function
 */

GLOBAL struct _globals global 
#ifdef MAIN
=
{
    "",
    OCCUPANCY,
    "preprocess.sql",
    0,
    50000,
    "/export/database",
    ".",
    1,
    1000,
    0
}
#endif
;

GLOBAL int linecount
#ifdef MAIN
= 0
#endif
;


/*
 * Function prototypes for iimport
 */

PUBLIC void   MigrateTableName(MigrateTable *mptr, char *sqlbuf);
PUBLIC status TargetTableName(TargetTable *tptr, char *tablename);
PUBLIC status CreateTableDDL(list *alist, char *database); 
PUBLIC status CreateViolations(char *tablename); 
PUBLIC status ParseArgs(int argc, char **argv, char **envp);
PUBLIC status MigrateDatabase(char *database);
PUBLIC status CreateViolations();
PUBLIC void   RmConstraintName(char *sqlbuf);
PUBLIC void   iimportUsage();
