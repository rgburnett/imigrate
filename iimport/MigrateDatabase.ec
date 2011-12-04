/*
 * File		: MigrateDatabase.ec
 * 
 * Sccs		: @(#)MigrateDatabase.ec	1.5
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
 * Name 	: MigrateDatabase - Migrate a database from a source release
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  MigrateDatabase(database)
 *		  char *database;
 *
 * Arguments	: database - the name of the database to migrate the cexp to.
 *
 * Description	: MigrateDatabase performs all the steps necessary to
 *		  migrate a database
 *
 * Returns	: various status values.
 *
 * See Also	:
 *
 */

EXEC SQL include "iimport.h";

PRIVATE
char *sccsid = "SCCS: @(#)MigrateDatabase.ec	1.5 Continuus: %subsystem: % %filespec: %";

PRIVATE status EnableRI(list target);
PRIVATE status RunPreprocessFile();
PRIVATE status SourceTablesProcess(list source);
PRIVATE status TargetTablesProcess(list target);
PRIVATE status DropDbSpace(char *dbname, char *spacename);


PUBLIC
status
MigrateDatabase(database)
char *database;
{
    list source;
    list target;
    list lptr;
    status retval;
    char migratedb_con[ 6 ] = "";
    char targetdb_con[ 6 ] = "";
    FINAL char *where = "iimport.MigrateDatabse: ";

    EXEC SQL BEGIN DECLARE SECTION;
    char srvname[ 100 ];
    char cnctname[ 100 ];
    EXEC SQL END DECLARE SECTION;
    

    DEBUG("\nMODULE [ %s ]\n\n", where);

    ListInitialise(&source);
    ListInitialise(&target);

    /*
     * Set up the two database connections
     */

    DEBUG("Setting up connections to target %s and source %s\n", database, 
								DEFAULT_DBNAME);

    if(IUDBConnect(database, targetdb_con) != IU_SUCCESS)
	goto free_lists;

    if(IUDBConnect(DEFAULT_DBNAME, migratedb_con) != IU_SUCCESS)
	goto free_lists;

    if(IUDBConnect((char *)NULL, migratedb_con) != IU_SUCCESS)
	goto free_lists;

    if((retval = CreateTableDDL(&source, database)) != IU_SUCCESS)
	goto free_lists;

    if((retval = SourceTablesProcess(source)) != IU_SUCCESS)
	goto free_lists;

    if(IUDBConnect((char *)NULL, targetdb_con) != IU_SUCCESS)
	goto free_lists;

    if((retval = IUListTables(&target, (char *)NULL)) != IU_SUCCESS)
	goto free_lists;

    if((retval = TargetTablesProcess(target)) != IU_SUCCESS)
	goto free_lists;

    chdir("..");

    if(IUDBConnect((char *)NULL, migratedb_con) != IU_SUCCESS)
	goto free_lists;


    if((retval = RunPreprocessFile()) != IU_SUCCESS)
	goto free_lists;

    if(IUDBConnect((char *)NULL, targetdb_con) != IU_SUCCESS)
	goto free_lists;

    if((retval = EnableRI(target)) != IU_SUCCESS)
	goto free_lists;

    IUDBDisconnect(migratedb_con);
    IUDBDisconnect(targetdb_con);

    EXEC SQL SET CONNECTION DEFAULT;

    if((retval = DropDbSpace(DEFAULT_DBNAME, DEFAULT_DBSPACE)) != IU_SUCCESS)
	goto free_lists;

free_lists:

    ListDestroy(&source);
    ListDestroy(&target);

    printf("Migrate completed %ssuccessfully\n", (retval == IU_SUCCESS) ? "" : "un");

    if(global.has_violations)
    {
	int i = global.has_violations;

	printf("Warning: There %s %d table%s with violations\n", ((i == 1) ? 
								"is" : "are" ), i,
							    ((i == 1) ? "" : "s"));

	printf("Check this log file for the string \"Violations Warning:\"\n");
    }

    return retval;
}

/*
 *
 * Name 	: TargetTablesProcess - do various things to the target tables
 *
 * Synopsis	: PRIVATE
 *		  status
 *		  TargetTablesProcess(target)
 *		  list target;
 *
 * Arguments	: target 	- a list of tables.
 *
 * Description	: Delete all data from target tables. Prepare violations and 
 *		  diagnostics tables for the target tables and disable 
 *		  all constraints.
 *
 * Returns	: status values.
 *
 * See Also	: SourceTablesProcess()
 *
 */

PRIVATE
status
TargetTablesProcess(target)
list target;
{
    list lptr;
    status retval;
    FINAL char *where = "iimport.MigrateDatabase.TargetTablesProcess";

    DEBUG("\nMODULE [ %s ]\n\n", where);

    for(lptr = target; DATA(lptr); lptr = NEXT(lptr))
    {
	char del_from[ 256 ];


	printf("Disabling Constraints on %s.%s\n", global.database, DATA(lptr));

	IUTime();

	if((retval = IUConstraints ( DATA(lptr),
			(CONSTRAINTS | INDEXES | TRIGGERS), DISABLED)) != IU_SUCCESS)
	    return retval;

	IUTime();

	printf("Deleting All Rows from %s.%s\n", global.database, DATA(lptr));

	sprintf(del_from, "DELETE FROM %s WHERE 1 = 1;\n", DATA(lptr));

	if((retval = IURunSQL(del_from, NULL, REPORT)) != IU_SUCCESS)
	    return Error(retval, 
		"iimport.MigrateDatabase.TargetTablesProcess: Delete rows failed", 
			"205"); 

	IUTime();

	printf("Starting Violations  on %s.%s\n", global.database, DATA(lptr));

	if((retval = CreateViolations(DATA(lptr))) != IU_SUCCESS)
	    return retval;

    }

    return IU_SUCCESS;
}

/*
 * Name 	: SourceTablesProcess - do various things to the source tables
 *
 * Synopsis	: PRIVATE
 *		  status
 *		  SourceTablesProcess(target)
 *		  list target;
 *
 * Arguments	: target 	- a list of tables.
 *
 * Description	: Remove the named constraint from the create table statement. 
 *		  Run the create table statement and load the data into the
 *		  table.
 *
 * Returns	: status values.
 *
 * See Also	: TargetTablesProcess()
 *
 */

PRIVATE
status
SourceTablesProcess(source)
list source;
{
    FINAL char *where = "iimport.MigrateDatabase.SourceTablesProcess: ";
    char sqlbuf[ MAX_SQL_BUF ];
    list lptr;
    status retval;

    DEBUG("\nMODULE [ %s ]\n\n", where);

    ListInitialise(&lptr);

    for(lptr = source; DATA(lptr); lptr = NEXT(lptr))
    {
	/*
	 * A dbschema of a database has named constraints which
	 * have to be removed to avoid name conflicts with 
	 * the target database
	 */

	RmConstraintName(MigrateTableAttr(lptr, sqlbuf));
	
	DEBUG("Creating Load Table for %s\n", MigrateTableAttr(lptr, shortname));

	if((retval = IURunSQL(MigrateTableAttr(lptr, sqlbuf), NULL, 
							IGNORE)) != IU_SUCCESS)
	{
	    Error(retval, "iimport.MigrateDatabase.IURunSQL: Create tables", "268"); 
	    goto free_list;
	}

	/*
	 * Load the data into the temporary table 
	 */

	DEBUG("Loading data into %s.%s\n", DEFAULT_DBNAME, 
						    MigrateTableAttr(lptr, shortname));

	IUTime();

	if((retval = IULoadTable(MigrateTableAttr(lptr, shortname),
		global.commit_threshold, global.compressed)) != IU_SUCCESS)
	    goto free_list;

	IUTime();
    }

free_list:

    ListDestroy(&lptr);

    return retval;
}


/*
 * Name 	: RunPreProcessFile - run the SQL preprocess file
 *
 * Synopsis	: PRIVATE
 *		  status
 *		  RunPreprocessFile()
 *
 * Arguments	: none
 *
 * Description	: Run the commands
 *
 * Returns	: status values
 *
 * See Also	:
 *
 */

PRIVATE
status
RunPreprocessFile()
{
    FILE *fp;
    FINAL char *where = "iimport.MigrateDatabase.RunPreprocessFile";
    char dmlbuf[ 4096 ];

    DEBUG("\nMODULE [ %s ]\n\n", where);

    if ((fp = fopen(global.preprocessfile, "r")) == (FILE *)NULL)
	return Error(IU_EINVALIDARG, 
		"iimport.MigrateDatabase.RunPreprocessFile: Cannot open input file", 
			"326");
    linecount = 0;

    while(ReadSQL(dmlbuf, fp) != (char *)NULL)
	if(IURunSQL(dmlbuf, (FILE *)NULL, REPORT) != IU_SUCCESS)
	{
	    printf("Script Failed Error near line %d\n", linecount);
	    return IU_ERTERROR;
	}

    return IU_SUCCESS;
}

/*
 * Name 	: EnableRI - enable constraints on the target database.
 *
 * Synopsis	: PRIVATE
 *		  status
 *		  EnableRI(target)
 *		  list target;
 *
 * Arguments	: target - a list of tables.
 *
 * Description	: EnableRI re-enables indexes, triggers and RI constraints on 
 *		  a database.
 *
 * Returns	: status values: IU_SUCCESS || IU_RTERROR
 *
 * See Also	:
 *
 */

PRIVATE
status
EnableRI(target)
list target;
{
    FINAL char *where = "iimport.MigrateDatabse.EnableRI";
    list lptr;
    status retval = IU_SUCCESS;

    DEBUG("\nMODULE [ %s ]\n\n", where);

    ListInitialise(&lptr);

    for(lptr = target; DATA(lptr); lptr = NEXT(lptr))
    {
	DEBUG("Enabling Constraints on %s.%s\n", global.database, DATA(lptr));

	if((retval = IUConstraints (DATA(lptr),
			(CONSTRAINTS | INDEXES | TRIGGERS), ENABLED)) != IU_SUCCESS)
	{
	    fprintf(stderr, "--> Error: Table %s.%s failed to re-enable database RI\n", 
		global.database, DATA(lptr));

	    printf("Check violations table [ %s.%s ]\n", global.database, DATA(lptr)); 
	}

	if((retval = StopViolations(DATA(lptr))) != IU_SUCCESS)
	    goto free_list;
    }

free_list:

    ListDestroy(&lptr);

    return retval;
}


/*
 * Name 	: DropDbSpace - clean up disk space used. 
 *
 * Synopsis	: PRIVATE
 *		  status
 *		  DropDbSpace(dbname, spacename)
 *		  char *dbname;
 *		  char *spacename;
 *
 * Arguments	: dbname	- the name of the database to drop
 *
 *		  spacename	- the space to drop 
 *
 * Description	: DropDbSpace cleans up the migration environment
 *		  by dropping the migration database and then
 *		  removing the dbspace and it's links.
 *
 * Returns	: IU_SUCCESS on success status values otherwise.
 *
 * See Also	: IUDatabase, IUOnspaces
 *
 */

PRIVATE
status
DropDbSpace(dbname, spacename)
char *dbname;
char *spacename;
{
    FINAL   char *where = "iimport.MigrateDatabase.DropDbSpace";
    char    chunk_path[ PATH_MAX ];
    char msg[ 256 ];
    dbspace dbs, *ptr = &dbs;
    int     chunk_count = 0;
    status  retval;

    DEBUG("\nMODULE [ %s ]\n\n", where);

    EXEC SQL DATABASE "sysmaster";

    if((retval = IUDatabase(DROPDATABASE, dbname, (char *)NULL)) != IU_SUCCESS)
    {
	sprintf(msg, "%s : Cannot Drop Database %s\n", where, dbname);
	
	return Error(IU_ERTERROR, msg, "440"); 
    }

    bzero(ptr, sizeof(dbs));

    DBSPACEOP(ptr, DROPDBSPACE);
    DBSPACENAME(ptr, spacename);

    if((retval = IUOnspaces(ptr)) != IU_SUCCESS)
    {
	sprintf(msg, "%s : Cannot Drop Database Space %s\n", where, spacename);

	return Error(IU_ERTERROR, msg, "452"); 
    }

    for(;;)
    {
	sprintf(chunk_path, "%s%s/migrate_chunk%03d", global.migrate_dir, 
		"/migrate_chunks", chunk_count++);

	DEBUG("Removing %s\n", chunk_path);
	
	if(unlink(chunk_path) == -1)
	{
	    if(errno == ENOENT)
		break;
	    else
		return Error(errno, "iimport.MigrateDatabase.DropDbSpace", "467");
	}
    }

    sync();

    return IU_SUCCESS;
}
