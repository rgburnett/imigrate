/*
 * File		: IUConnectionInfo.ec 
 * 
 * Sccs		: @(#)IUConnectionInfo.ec	1.1
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
EXEC SQL include "esql.incl.h";

#include "c.defs.h"
EXEC SQL include "esql.defs.h";

#include "c.class.h"
EXEC SQL include "esql.class.h";

#include "error.class.h"

#include "c.proto.h"
EXEC SQL include "esql.proto.h";

#include "global.h"

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)IUConnectionInfo.ec	1.1 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUConnectionInfo - retrieve sqlhosts entry for current connection 
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  IUConnectionInfo(cptr)
 *		  connectioninfo *cptr; 
 *
 * Arguments	: cptr - pointer to a connectioninfo structure 
 *
 * Description	: IUConnectionInfo retrieves the information held in
 *		  $INFORMIXDIR/etc/sqlhosts and places it in a connectioninfo
 *		  data structure. It is primarily used to find out whether
 *		  we have a shared memory or socket connection to the
 *		  server.
 *
 * See Also	: 
 *
 * Returns	: status values of IU_SUCCESS or IU_ERTERROR on error.
 */

PUBLIC
status
IUConnectionInfo(cptr)
connectioninfo *cptr;
{
    char *informix_server;
    char *informix_dir;
    char path[ PATH_MAX ];
    char buf[ BUFFER_4K ];
    char pattern[ 256 ];
    status retval = IU_NODATA;
    FILE *fp;

    extern char *getenv();
    
    if(cptr == (connectioninfo *)NULL)
	return Error(IU_EINVALIDARG, "IUConnectionInfo.cptr ", "84");

    if((informix_dir = getenv("INFORMIXDIR")) == (char *)NULL)
	return Error(IU_EINFORMIXDIR, "IUConnectionInfo", "87");

    if((informix_server = getenv("INFORMIXSERVER")) == (char *)NULL)
	return Error(IU_EINFORMIXSERVER, "IUConnectionInfo", "90");

    sprintf(path, "%s/etc/sqlhosts", informix_dir);

    if((fp = fopen(path, "r")) == (FILE *)NULL)
	return Error(errno, "IUConnectionInfo", "95");

    sprintf(pattern, "^[ 	]*%s[ 	][ 	]*.*$", informix_server);

    while(fgets(buf, BUFFER_4K, fp) != (char *)NULL)
    {
	if(match(buf, "^[ 	]*#.*$"))
	    continue;

	if(!match(buf, pattern))
	    continue;
	else
	{
	    int i;
	    char *token;
	    char *bufptr;
	    char *destptr;


	    for(i = 0, bufptr = buf; i < 4; i++, bufptr = (char *)NULL)
	    {
	 	token = strtok(bufptr, " 	");

		switch(i)
		{
		    case 0: destptr = cptr->informix_server; break;
		    case 1: destptr = cptr->connection_type; break;
		    case 2: destptr = cptr->host; break;
		    case 3: destptr = cptr->server_ent; StripNewLine(token); break;
		}

		strcpy(destptr, token);
	    }
	    retval = IU_SUCCESS;
	}
    }


    if(errno || (fclose(fp) == EOF))
	return Error(errno, "IUConnectionInfo", "134");
    
    return retval;
}

#ifdef TEST

main()
{
    list glist, lptr;
    char *db;
    char con[ 10 ];
    connectioninfo fred;
    
    if(IUDBConnect("stores7", con) != IU_SUCCESS)
    {
	fprintf(stderr, "Cannot connect to stores7\n");
	exit(1);
    }

    printf("%d \n", IUConnectionInfo(&fred));

    printf("%s\n", fred.informix_server);
    printf("%s\n", fred.connection_type);
    printf("%s\n", fred.host);
    printf("%s\n", fred.server_ent);

    exit(0);
}

#endif
