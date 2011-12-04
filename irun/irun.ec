/*
 * File		: irun.ec 
 * 
 * Sccs		: @(#)irun.ec	1.5 
 *
 * Dated	: 96/10/24 14:46:31 
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
 * Name 	: irun - run a file full of sql commands. 
 *
 * Synopsis	: irun <database> | '-' [ <sql command file> ]
 *
 * Arguments	: database	- name of a database to connect to 
 *
 * Description	: irun is a replacement for dbaccess which provides an
 *		  easier way to run scripts from shell.
 *
 * See Also	:
 *
 * Sccs 	: @(#)irun.ec	1.5
 *
 * Continuus 
 * Project	: %subsystem% %filespec%";
 */

#define MAIN
EXEC SQL define MAIN;

#include "c.incl.h"
#include "c.defs.h"
EXEC SQL include "esql.defs.h";
#include "c.class.h"
EXEC SQL include "esql.class.h";
#include "error.class.h"
#include "c.proto.h"
EXEC SQL include "esql.proto.h";
#include "global.h"

PRIVATE
char *sccsid = "SCCS @(#)irun.ec	1.5 : Continuus Project: %subsystem% %filespec%";

main(argc, argv, envp)
EXEC SQL BEGIN DECLARE SECTION; 
int argc;
char *argv[];
char *envp[];
EXEC SQL END DECLARE SECTION; 
{
    FILE *fp;
    char dmlbuf[ 2048 ];

    if( argc > 1 && *argv[ 1 ] != '-')
	IUDBConnect(argv[ 1 ], NORMAL);

    if(*argv[ 2 ])
	if ((fp = fopen(argv[ 2 ], "r")) == (FILE *)NULL)
	{
	    perror("fopen");
	    exit(1);
	}
    else
	fp = stdin;


    while(ReadSQL(dmlbuf, fp) != (char *)NULL)
	if(IURunSQL(dmlbuf, stdout, REPORT) != IU_SUCCESS)
	{
	    printf("Error - statement ended at line %d\n", linecount);
	    exit(1);
	}

    exit(0);
}
