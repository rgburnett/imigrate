#ifndef _ESQLDEFSINCLUDED
#define _ESQLDEFSINCLUDED

/*
 * File		: esql.defs.h
 * 
 * Sccs		: @(#)esql.defs.h	1.3 
 *
 * Dated	: 96/10/30 15:38:38 
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

/*
 * PUBLIC is an empty definition - just for neatness
 */

EXEC SQL define PUBLIC;
EXEC SQL define FINAL	const;	/* more Java less C */
EXEC SQL define PRIVATE static;

/*
 * All global variables are initialised once in MAIN - all other references
 * are external to the file which includes the reference so define GLOBAL
 * appropriately
 *
 */

EXEC SQL ifdef MAIN;
EXEC SQL 	define GLOBAL;
EXEC SQL else;
EXEC SQL 	define GLOBAL extern;
EXEC SQL endif;

/*
 * This is usually defined in several places in the usual UNIX header files
 * notably stdio.h
 */

EXEC SQL ifndef FALSE;
EXEC SQL 	define FALSE 0;
EXEC SQL endif;

EXEC SQL ifndef TRUE;
EXEC SQL 	define TRUE 1;
EXEC SQL endif;


EXEC SQL define STACKINCREMENT 100;

/*
 * The following bitmaps are used by IUConstraints
 */

EXEC SQL define    INDEXES	  00000001;
EXEC SQL define    TRIGGERS	  00000002;
EXEC SQL define    CONSTRAINTS	  00000004;

EXEC SQL define MIGRATE_DEFAULT		"/export/database";
EXEC SQL define TABLENAMELEN		19;
EXEC SQL define MAX_SQL_BUF		4096;
EXEC SQL define INFORMIX_NAME_LEN	19;


EXEC SQL define DEBUG	printf;

EXEC SQL define NODEBUG (void);

EXEC SQL define WARNNOTIFY	1;
EXEC SQL define NOWARNNOTIFY	0;
EXEC SQL define MAX_CONNECTIONS	10;

EXEC SQL define CONFREE   0;
EXEC SQL define CONACTIVE 1;

EXEC SQL define CREATEDATABASE 1;
EXEC SQL define DROPDATABASE 2;

EXEC SQL define CREATEDBSPACE 0x1;
EXEC SQL define DROPDBSPACE   0x2;
EXEC SQL define ADDCHUNK      0x8;
EXEC SQL define DROPCHUNK     0x10;
EXEC SQL define STARTMIRROR   0x20;
EXEC SQL define ENDMIRROR     0x40;
EXEC SQL define CHUNKDOWN     0x80;
EXEC SQL define CHUNKONLINE   0x100;
EXEC SQL define DATASKIPOFF   0x200;
EXEC SQL define DATASKIPON    0x400;

EXEC SQL define TRANSBEGIN	20983;
EXEC SQL define TRANSEND	213658;

#endif
