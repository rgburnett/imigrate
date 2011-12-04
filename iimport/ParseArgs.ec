/*
 * File		: ParseArgs.ec
 * 
 * Sccs		: @(#)ParseArgs.ec	1.4
 *
 * Dated	: 96/10/24 14:43:50 
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
 * Name 	: ParseArgs - parse the iimport arguements
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
 * Description	: ParseArgs processes all the argument combinations for the iimport
 *		  program.
 *
 * Returns	: IU_SUCCESS on success, various status values on error
 *
 * See Also	: Error
 *
 */

EXEC SQL include "iimport.h";

#include <sys/stat.h>

PRIVATE
char *sccsid = "SCCS: @(#)ParseArgs.ec	1.4 Continuus: %subsystem: % %filespec: %";

PUBLIC
status
ParseArgs(argc, argv, envp)
int    argc;
char **argv;
char **envp;
{
    struct stat sb;
    int had_database = 0;
    char *env_ptr;
    FINAL char *where = "iimport.ParseArgs";

    extern char *getenv();

    DEBUG("\nMODULE [ %s ]\n\n", where);

    /*
     * chown call further down needs to be run as root, so must check for
     * effective privilige.
     */

    if(geteuid() != 0)
    {
	fprintf(stderr, "Must be ROOT to execute iimport\n");
	return IU_ERTERROR;
    }

    /*
     * Late addition at the request of Mike Rathjen (pedant's corner), 
     * an environment var for the migration directory. This is 
     * overridden if the command line arguement is given though.
     */

    if((env_ptr = getenv("MIGRATEDBSDIR")) != (char *)NULL)
    {
	if(stat(*++argv, &sb) == -1)
	{
	    fprintf(stderr, "Directory [ %s ] does not exist\n", env_ptr);
	    return Error(errno, where, "91");
	}

	if((sb.st_mode & S_IFMT) != S_IFDIR)
	{
	    fprintf(stderr, "File [ %s ] is not a directory\n", env_ptr);
	    return IU_ERTERROR;
	}

	strcpy(global.migrate_dir, env_ptr);

	DEBUG("MIGRATEDBSDIR Migration Directory [ %s ]\n", global.migrate_dir);
    }
    else
	DEBUG("Migrate databaes directory defaults to [ %s ]\n", global.migrate_dir);


    if(argc <= 1 || (*argv == (char *)NULL) || (*envp == (char *)NULL))
	iimportUsage();

    for (argc--, argv++; argc > 0 ; argc--, argv++) 
    {
	if (**argv == '-')
	{
	    while (*++(*argv))
	    {
		switch (**argv)
		{
		    case 'd':

			if(stat(*++argv, &sb) == -1)
			{
			    fprintf(stderr, "Directory [ %s ] does not exist\n", *argv);
			    return IU_ERTERROR;
			}

			if((sb.st_mode & S_IFMT) != S_IFDIR)
			{
			    fprintf(stderr, "%s is not a directory\n", *argv);
			    return Error(errno, where, "130");
			}

			argc--;

			strcpy(global.migrate_dir, *argv);

			DEBUG("Migration Directory [ %s ]\n", global.migrate_dir);

			goto nextarg;

		    case 's':

			if(stat(*++argv, &sb) == -1)
			{
			    fprintf(stderr, "Directory [ %s ] does not exist\n", *argv);
			    return IU_ERTERROR;
			}

			if((sb.st_mode & S_IFMT) != S_IFDIR)
			{
			    fprintf(stderr, "%s is not a directory\n", *argv);
			    return Error(errno, where, "152");
			}

			argc--;
			
			strcpy(global.source_dir, *argv);

			global.compressed = match(global.source_dir, ".*.cexp$") ?
			    TRUE : FALSE;

			DEBUG("Source Directory [ %s ]\n", global.source_dir);
			DEBUG("Directory is in %s format\n", 
				(global.compressed == TRUE) ? "iexport(1DB)" : 
								"dbexport(1INF)" );
					

			goto nextarg;


		    case 'p':

			if(stat(*++argv, &sb) == -1)
			{
			    fprintf(stderr, "Cannot open %s\n", *argv);
			    return IU_ERTERROR;
			}

			argc--;

			strcpy(global.preprocessfile, *argv);

			DEBUG("SQL Preprocessfile [ %s ]\n", global.preprocessfile);

			goto nextarg;

		    case 'o':
			global.occupancy = atoi(*++argv);

			if(global.occupancy < 1 && global.occupancy > 100)
			    global.occupancy = 90;

			DEBUG("Occupancy [ %d ]\n", global.occupancy);

			argc--;

			goto nextarg;

		    default:
			return Error(errno, "iimport.ParseArgs: Unknown flag", "200");
		}
	    }
	}
	else 
	{
	    if(had_database)
	    {
		fprintf(stderr, "Too many database names\n");
		iimportUsage();
	    }
		
	    /*
	     * make sure that global.database is not overrun.
	     */

	    (void) strncpy(global.database, *argv, INFORMIX_NAME_LEN);

	    if(IUDBObjectExists("sysmaster", DATABASE, global.database) != IU_SUCCESS)
	    {
		fprintf(stderr, "Target Database %s does not exist\n", global.database);
		iimportUsage();
	    }
	    else
		had_database = 1;
	}
	nextarg: 
	    continue;
    }
    return IU_SUCCESS;
}
