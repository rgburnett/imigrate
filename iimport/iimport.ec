/*
 * File		: iimport.ec
 * 
 * Sccs		: @(#)iimport.ec	1.7
 *
 * Dated	: 96/10/24 14:43:51 
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
 * Name 	: iimport - migrate a database to the current in-situ schema
 *
 * Synopsis	: iimport database [ -p preprocess file ]
 *		        [ -d directory ] [ -s directory ] [ -o percentage ]
 *
 * Arguments	: database	the name of the installed target database 
 *				which the data will be migrated to.
 *
 *		  -d directory	a directory in which to create the migrate space.
 *
 *		  -s directory	a directory which contains the export of the 
 *			 	database. This may be in either dbexport or
 *				iexport format.	
 *
 *		  -p filename 	A Pre process SQL file
 *
 *		  -o NNN	a percentage of free disk space which iimport 
 *		                will occupy. Default is 90%.
 * 
 * Description	: iimport performs a migration of data from a compressed 
 *		  export of a database or series of databases produced 
 *		  by the tool iexport(1DB).
 *
 *		  A new database space is created called migratedbs.
 *		  A database called migratedb is created and the 
 *		  source tables are created and loaded.
 *		  
 *		  The disk space for this new dbspace is culled from
 *		  the directory specified with the -d <dirname> flag.
 *		  If this is not supplied, the environment variable
 *		  MIGRATEDBSDIR is queried. If this is not set, 
 *		  the default of /export/database (which is guaranteed 
 *		  to be 1.2 *
 *		  the size of the target database) is used..
 *
 *		  The optional user supplied preprocess script against 
 *		  the source tables performing any data/column 
 *		  manipulations.
 *
 *		  Constraints on the target database are disabled 
 *		  (constraints/indexes/triggers N.B. CHECK 
 *		  constraints are NOT disabled)
 *
 *	          Violation and diagnostic tables started on the target
 *		  tables. 
 *
 *		  Any data in the target database is deleted prior to the 
 *		  data in the source tables being transferred.
 *		  
 *		  Constraints are now enabled and any violations reported 
 *		  to the user, who then has the responsibility of massaging
 *		  the non-conformant data into the target database.
 *		  
 *		  This process is repeatable in the event of data errors.
 *
 * preprocess.sql
 * Script File	
 *		: This file can contain any legitimate SQL statements, 
 *		  including multi-table selects/inserts.
 *
 * Caveats	: Due to time constraints, blob/text data are not catered
 *		  for in either iexport or iimport. It would require 
 *		  approximately two/three man days to add this.
 * 
 * Algorithm	: This is how iimport works and the various steps
 *		  that are performed internally.
 *
 *		  parse program arguments (iimport.ParseArgs)
 *
 *		  create a new dbspace called migratedbs. This creates
 *		  all chunks as necessary.
 *
 *		  create source database in migratedbs 
 *
 *		  Parse a list of DDL statements from the 
 *		  file <dbname>.cexp/<dbname>.sql file	
 *				(iimport.MigrateDatabase.CreateTableDDL)
 *
 *		  for each source table
 *		  do
 *		      Create table in migratedb
 *
 *		      Load data into source table from compressed file series
 *
 *                done			  
 *
 *		  run preprocess.sql file
 *
 *		  for each target table
 *		  do
 * 		      Create all violations tables on the target tables	
 *
 *		      Delete existing data from the target tables
 *
 *	  	      insert data from source table into target table.		
 *
 *		  done
 *
 *		  for each target table
 *		  do
 *		      Turn on RI and report errors 
 *		  done
 *
 *		  Drop database migratedb 
 *
 *		  Drop database space migratedbs
 *
 * Status	: IN DEVELOPMENT
 *
 * See Also	: iexport, dbexport, dbimport 
 *
 * Sccs 	: @(#)iimport.ec	1.7 
 *
 * Dated	: 96/10/24 14:43:51 
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

EXEC SQL define MAIN;
#define MAIN

#include <time.h>

EXEC SQL include "iimport.h";

PRIVATE
char *sccsid = "SCCS: @(#)iimport.ec	1.7 Continuus: %subsystem: % %filespec: %";

PACKAGE
void
iimportUsage()
{
    fprintf(stderr, "iimport: database [ -p <preprocess sql file> ] [ -o NNN ]\n"); 
    EXEC SQL DISCONNECT ALL;
    exit(1);
}

PUBLIC
int
main(argc, argv, envp)
int argc;
char **argv;
char **envp;
{
    char *db;
    long t;
    FINAL char *where = "iimport";
    connectioninfo con;

    DEBUG("iimport: logging to iimport.log\n\n");

    if(IULog("iimport.log") != IU_SUCCESS)
	exit(1);

    printf("iimport: Started\n");


    DEBUG("Unsetting DBDATE\n");

    IUunset("DBDATE");


    DEBUG("Establishing implicit database connection to sysmaster\n");

    EXEC SQL DATABASE "sysmaster";

    if(IUCheck("DATABASE sysmaster") == IU_ERTERROR)
	exit(1);

    iimportSetSignals();

    IUTime();

    DEBUG("Checking for SOCKET Connection to database\n");

    if(IUConnectionInfo(&con) != IU_SUCCESS)
    {
	fprintf(stderr, "Cannot establish connection type\n");
	exit(1);
    }

    if(strcmp(con.connection_type, "onsoctcp"))
    {
	fprintf(stderr, "INFORMIXSERVER MUST be set to an \"onsoctcp\" entry\n");
	fprintf(stderr, "in sqlhosts\n");
	exit(1);
    }

    if(ParseArgs(argc, argv, envp) != IU_SUCCESS)
	exit(1);

    DEBUG("Dropping existing migration database\n");

    if(IUDBObjectExists("sysmaster", DATABASE, DEFAULT_DBNAME) == IU_SUCCESS)
    {
	DEBUG("Calling IUDatabase to drop existing %s database\n", DEFAULT_DBNAME);

	if(IUDatabase(DROPDATABASE, DEFAULT_DBNAME, (char *)NULL) != IU_SUCCESS)
	{
	    fprintf(stderr, "Couldn't drop database %s\n", DEFAULT_DBNAME);
	    exit(1);
	}
    }

    DEBUG("Create and initialise %s\n", DEFAULT_DBSPACE);

    if(MakeMigrateSpace(DEFAULT_DBSPACE) != IU_SUCCESS)
	return Error(IU_ERTERROR, "iimport: failed to create migrate db space", "240");


    DEBUG("Creating database %s\n", DEFAULT_DBNAME);

    if(IUDatabase(CREATEDATABASE, DEFAULT_DBNAME, DEFAULT_DBSPACE) != IU_SUCCESS)
    {
	fprintf(stderr, "%s, couldn't create migrate database %s\n", where, 
						DEFAULT_DBNAME); 
	exit(1);
    }


    DEBUG("Migrating %s\n", global.database);

    if(MigrateDatabase(global.database) != IU_SUCCESS)
    {
	fprintf(stderr, "%s Error, Migration failed - check the log file\n", where); 
	exit(1);
    }

    IUTime();

    exit(0);
}
