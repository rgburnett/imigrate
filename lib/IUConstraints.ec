/*
 * File		: IUConstraints.ec 
 * 
 * Sccs		: @(#)IUConstraints.ec	1.2
 *
 * Dated	: 96/10/30 15:24:18 
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


#ifdef TEST
EXEC SQL define MAIN;
#define MAIN
#endif

#include "c.incl.h"
#include "c.defs.h"
#include "c.class.h"
#include "error.class.h"
#include "c.proto.h"
#include "global.h"

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)IUConstraints.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUConstraints -  enable/disable constraints on a table
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  IUConstraints(tablename, type, operation)
 *		  char *tablename;
 *		  int   type;
 *		  ConstraintOperation operation;
 *
 * Arguments	: tablename - the name of the table whose constrainst should
 *			      be operated on.
 *
 *		  type 	    - Bit value of CONSTRAINTS | TRIGGERS | INDEXES. These
 *			      can be OR'd together.
 *
 *		  operation - ENABLE | DISABLE
 *
 * Description	: IUConstraints disables/enables the operation of database 
 *		  objects on specified tables (thats what is says in the manual). 
 *		  It allows you to switch off or on CONSTRAINTS (e.g. 
 *		  PRIMARY KEYS, FOREIGN KEYS KEY CONSTRAINTS, CHECK CONSTRAINTS).
 *
 *		  It also allows you to disable/enable TRIGGERS and/or INDEXES.
 *
 * Returns	: IU_SUCCESS on success and status values on error.
 *
 * See Also	: Informix Guide to 7.1 Feature Enhancements 
 *		  Part No. 000-7748. the SET command 3-78. This describes
 *		  the operations performed by the ENABLED | DISABLED 
 *		  FILTERING commands.
 *
 */

PUBLIC
status
IUConstraints(tablename, type, operation)
char   *tablename;
int     type;
ConstraintOperation operation;
{
    char part1[ 256 ] = "SET ";
    char part2[ 256 ];
    char *optype;
    status retval;
    list alist;
    list lptr;

    if(tablename == (char *)NULL)
	return Error(IU_EINVALIDARG, "IUConstraints.tablename", "88");

    if(type & CONSTRAINTS)
	strcat(part1, " CONSTRAINTS ");

    if (type & INDEXES)
    {
	if(type & CONSTRAINTS)
	    strcat(part1, ", ");

	strcat(part1, " INDEXES ");
    }
	
    if (type & TRIGGERS)
    {
	if(type & CONSTRAINTS || type & INDEXES)
	    strcat(part1, ", ");

	strcat(part1, " TRIGGERS "); 
    }

    switch(operation)
    {
	case ENABLED:
	    optype = " ENABLED;";
	    break;

	case DISABLED:
	    optype = " DISABLED;";
	    break;

	default:
	    optype = " ENABLED;";
    }

    strcpy(part2, part1);
    strcat(part2, " FOR ");
    strcat(part2, tablename);
    strcat(part2, optype); 

    ListInitialise(&alist);

    if((retval = IUMasterTableList(tablename, &alist)) != IU_SUCCESS)
    {
	Error(retval, "IUConstraints.IUMasterTableList", "132");
	goto deletelist;
    }


    for(lptr = alist; DATA(lptr); lptr = NEXT(lptr))
    {
	if (operation == ENABLED)
	{
	    if((retval = IURunSQL(part2, NULL, REPORT)) != IU_SUCCESS)
		    goto deletelist;
	}

	if((retval = IUConstraints(DATA(lptr), type, operation)) != IU_SUCCESS)
	{
	    Error(retval, "IUConstraints.IUConstraints", "147");
	    goto deletelist;
	}
    }

    if(operation == DISABLED)
	if((retval = IURunSQL(part2, NULL, REPORT)) != IU_SUCCESS)
	    goto deletelist;

deletelist:

    ListDestroy(&alist);

    return retval;
}

#ifdef TEST

main()
{
    status retval;
    list alist;
    list lptr;
    char con[ 7 ];
    int failures = 0;
    int last_failures = 0;


    IUDBConnect("stores7", con);

    if(db == (char *)NULL)
    {
	fprintf(stderr, "Connect failed\n");
	exit(1);
    }

    ListInitialise(&alist);

    if((retval = IUListTables(&alist, (char *)NULL)) != IU_SUCCESS)
    {
	Error(retval, "main.IUListTables", "help");
	exit(1);
    }

    fprintf(stderr, "------------- DISABLING ---------------\n");

    for(lptr = alist; DATA(lptr); lptr = NEXT(lptr))
    {
	printf("Disabling constraints on %s\n", DATA(lptr));
	IUConstraints(DATA(lptr), (CONSTRAINTS | TRIGGERS | INDEXES), DISABLED);
    }

    fprintf(stderr, "------------- ENABLING ---------------\n");

    for(lptr = alist; DATA(lptr); lptr = NEXT(lptr))
    {
	printf("Enabling constraints on %s\n", DATA(lptr));
	IUConstraints(DATA(lptr), (CONSTRAINTS | TRIGGERS | INDEXES), ENABLED);
    }

    ListDestroy(&alist);

    IUDBDisconnect(con);

    exit(0);
}

#endif
