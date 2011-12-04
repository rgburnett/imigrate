#ifndef _CDEFSINCLUDED
#define _CDEFSINCLUDED

/*
 * File		: c.defs.h - global constant definitions
 * 
 * Sccs		: @(#)c.defs.h	1.4 
 *
 * Dated	: 96/10/30 15:38:37 
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
 * Operator overloading existed in C for years in the form of the static
 * keyword. As an aid to programmers (I find it a lot easier) I have 
 * defined the following to make scope rules more obvious and to encourage 
 * the correct scoping of functions and variables.
 *
 * PUBLIC 	- means that this function has global visibility and is
 *	  	  used for all the library routines.
 *
 * PRIVATE 	- restricts visibility to that file on nowhere else. Based
 * 		  on the overloaded static keyword from C.
 *
 * FINAL	- Used to define immutable constants. Evaluates to the
 *		  const keyword in C.
 *
 * GLOBAL 	- is another OO ism to help with variable scope and 
 *		  initialisation of objects. In the file which contains
 *		  the main() routine, you should #define MAIN so that
 *		  all variables are initialised once only.
 *
 */

/*
 * PUBLIC is an empty definition - just for neatness
 */

#define PUBLIC
#define FINAL	const	/* more Java less C */
#define PACKAGE		/* Scope of this function is global, but only to our package */

/*
 * All global variables are initialised once in MAIN - all other references
 * are external to the file which includes the reference so define GLOBAL
 * appropriately
 *
 */

#ifdef MAIN
#define GLOBAL
#else
#define GLOBAL extern
#endif

/*
 * This is usually defined in several places in the usual UNIX header files
 * notably stdio.h
 */

#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif

/*
 * The much underused/understood static keyword.
 */

#define PRIVATE static
#define FINAL	const

#define STACKINCREMENT 100

/*
 * The following bitmaps are used by IUConstraints
 */

#define    INDEXES	  00000001
#define    TRIGGERS	  00000002
#define    CONSTRAINTS	  00000004

#define NBUCKETS 1024 

#define DATA(L)		((L)->datapointer)
#define NEXT(L)		((L)->next)
#define PREV(L)		((L)->prev)
#define FRONT(Q)	((Q)->front)
#define REAR(Q)		((Q)->rear)
#define CURRENT_STACKSIZE(stackptr) ((stackptr)->top - (stackptr)->base)

#define TABLENAMELEN	19
#define MAX_SQL_BUF	4096
#define INFORMIX_NAME_LEN	19
#define MAX_CONNECTIONS	10


#define DEBUG	printf
#define NODEBUG (void)

#define CONACTIVE	1
#define CONFREE		0


#define MIGRATE_DEFAULT		"/export/database"
#define COMPRESSED_IEXPORT_DIR	".cexp"
#define DBEXPORT_DIR		".exp"
#define TABLENAMELEN		19
#define MAX_SQL_BUF		4096
#define INFORMIX_NAME_LEN	19

#define CREATEDATABASE 1
#define DROPDATABASE 2

#define CREATEDBSPACE 0x1
#define DROPDBSPACE   0x2
#define ADDCHUNK      0x8
#define DROPCHUNK     0x10
#define STARTMIRROR   0x20
#define ENDMIRROR     0x40
#define CHUNKDOWN     0x80
#define CHUNKONLINE   0x100
#define DATASKIPOFF   0x200
#define DATASKIPON    0x400


#define DBSPACEOP(ptr, x)		ptr->op = x
#define DBSPACENAME(ptr, x)		strcpy(ptr->spacename, x)
#define DBSPACEPATH(ptr, x)		strcpy(ptr->path, x)
#define DBSPACEOFFSET(ptr, x)		ptr->offset = x
#define DBSPACESIZE(ptr, x)		ptr->size = x
#define DBSPACETMP(ptr, x)		ptr->tmp = x
#define DBSPACEMIRROR(ptr, x)		strcpy(ptr->mirror_path, x)
#define DBSPACEMIRROROFFSET(ptr, x)	ptr->mirror_offset = x

/*
 * Thought I would leave me telephone numbers - in case you get stuck (-;
 */

#define BEGINWORK	01727
#define COMMITWORK	832250
#define ROLLBACKWORK	0345
#define MOBILE		546648

#define BUFFER_64K	65536	/* various buffer sizes */
#define BUFFER_32K	32768
#define BUFFER_8K	 8192
#define BUFFER_4K	 4096
#define BUFFER_1K	 1024
#define BUFFER_PAGE	 4096	/* size of the platform memory page */

#endif
