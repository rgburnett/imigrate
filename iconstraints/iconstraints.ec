/*
 * File		: iconstraints.ec 
 * 
 * Sccs		: @(#)iconstraints.ec	1.5 
 *
 * Dated	: 96/10/24 16:03:45 
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
 * Name 	: iconstraints -  enable/disable constraints/triggers/indexes on a table
 *
 * Synopsis	: iconstraints <database> table ... [ -d | -e ] [ -c -i -t ] 
 *
 * Arguments	: database - the name of the database containing the tables
 *
 *		  table...    a list of tables whose constrainst/triggers/indexes 
 *			      should be operated on.
 *
 *		  -e 	      enable constraints/triggers/indexes
 *
 *		  -d	      disable constraints/triggers/indexes
 *
 *		  -c	      CONSTRAINTS 
 *
 *		  -i	      INDEXES
 *
 *		  -t	      TRIGGERS
 *
 * Description	: iconstraints disables/enables the operation of database 
 *		  objects on specified tables. It allows you to switch off 
 *		  or on CONSTRAINTS (e.g. PRIMARY KEYS, FOREIGN KEYS KEY 
 *		  CONSTRAINTS, CHECK CONSTRAINTS), TRIGGERS and/or INDEXES.
 *
 * Returns	: 0 on success 
 *
 * See Also	: Informix Guide to 7.1 Feature Enhancements 
 *		  Part No. 000-7748. the SET command 3-78. This describes
 *		  the operations performed by the ENABLED | DISABLED 
 *		  FILTERING commands.
 *
 */

EXEC SQL define MAIN;
#define MAIN

EXEC SQL include "iconstraints.h";

PRIVATE
char *sccsid = "SCCS: @(#)iconstraints.ec	1.5 Continuus: %subsystem: % %filespec: %";

PRIVATE
void
iconstraintsUsage()
{
    fprintf(stderr, "iconstraints <database> table ... [ -e | -d ] [ -c -i -t ]\n");
    EXEC SQL DISCONNECT ALL;
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

/*
 * Name 	: ParseArgs - parse the iconstraints arguements
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  ParseArgs(argc, argv, envp)
 *		  int    argc;
 *		  char **argv;
 *		  char **envp;
 *
 * Arguments	: argc - the number of arguements
 *
 *		  argv - a vector to the progams arguements
 *
 *		  envp - a vector to the programs environment
 *
 * Description	: ParseArgs processes all the argument combinations 
 *		  for the iconstraints program.
 *
 * Returns	: IU_SUCCESS on success, various status values on error
 *
 * See Also	: Error(3DB)
 *
 */

PRIVATE
status
ParseArgs(argc, argv, envp)
int    argc;
char **argv;
char **envp;
{
    char **tbptr;
    int Tables = 0;

    if(argc <= 0 || (*argv == (char *)NULL) || (*envp == (char *)NULL))
	return Error(IU_EINVALIDARG, "iconstraints.ParseArgs", "135");

    if((global.tables = tbptr = (char **)(malloc(argc * sizeof(*argv)))) ==
	(char **)NULL)
	return Error(errno, "iconstraints.ParseArgs.malloc", "139");

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
			global.optype |= TRIGGERS;
			break;

		    case 'I':
		    case 'i':
			global.optype |= INDEXES;
			break;

		    case 'C':
		    case 'c':
			global.optype |= CONSTRAINTS;
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
