#ifndef _ICONSTRAINTSH
#define _ICONSTRAINTSH

/*
 * File		: iconstraints.h
 * 
 * Sccs		: @(#)iconstraints.h	1.3
 *
 * Dated	: 96/10/15 10:42:50 
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

#define ARGVAL() (*++(*argv) || (--argc && *++argv))

#include "c.incl.h"
#include "c.defs.h"
EXEC SQL include "esql.defs.h";
#include "c.class.h"
EXEC SQL include "esql.class.h";
#include "error.class.h"
#include "c.proto.h"
EXEC SQL include "esql.proto.h";
#include "global.h"

/*
 * Global Program Variables
 */

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

/*
 * PRIVATE function prototypes
 */

PRIVATE status ParseArgs(int argc, char **argv, char **envp);
PRIVATE void iconstraintsUsage();

#endif
