/*
 * File		: IUEnv.c
 * 
 * Sccs		: @(#)IUEnv.c	1.2
 *
 * Dated	: 96/10/30 15:24:20 
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
#define MAIN
#endif

#include "c.incl.h"
#include "c.defs.h"
#include "c.class.h"
#include "error.class.h"
#include "c.proto.h"
#include "global.h"

PRIVATE
char *sccsid = "SCCS: @(#)IUEnv.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUunset - unset and environment variable
 *
 * Synopsis	: PUBLIC
 *		  void
 *		  IUunset(envvar)
 *		  char *envvar;
 *
 * Arguments	: envvar - name of an environment variable to unset
 *
 * Description	: C version of the unset built-in shell command.
 *
 * Returns	: void
 *
 * See Also	: IUputenv()
 *
 */


PUBLIC
void
IUunset(envvar)
char *envvar;
{
    register char **ptr;
    register int varlen;
    extern char **environ;

    if(envvar == (char *)NULL || *envvar == '\0')
	return;

    for(ptr = environ, varlen = strlen(envvar); *ptr; *ptr++)
	if(!memcmp(*ptr, envvar, varlen))
	{
	    char baaah[ 1256 ];

	    memcpy(baaah, *ptr, varlen + 1); 

	    putenv(baaah);
	    break;
	}
}

/*{{ FUNCDOC 3
 *
 * Name 	: IUputenv - put a variable in the current environment
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  IUputenv(envvar, value)
 *		  char *envvar;
 *		  char *value;
 *		  
 * Arguments	: envvar - name of the environment variable to set.
 *
 *		  value - the value which you wish it to be set to.
 *
 * Description	: IUputenv allows you to change the current program's
 *		  environment.
 *
 * Returns	: status values of IU_SUCCESS or IU_ERTERROR/errno values
 *		  otherwise.
 *
 * See Also	: IUunset();
 *
 */

PUBLIC
status
IUputenv(envvar, value)
char *envvar;
char *value;
{
    register char **ptr;
    char *vptr = value;
    int varlen;
    int arglen;

    extern char **environ;

    if(envvar == (char *)NULL || *envvar == '\0')
	return;

    if(value == (char *)NULL)
	vptr = "";

    arglen = strlen(vptr);
    varlen = strlen(envvar);

    for(ptr = environ; *ptr; *ptr++)
	if(!memcmp(*ptr, envvar, varlen))
	{
	    *ptr = (char *)NULL;
	    break;
	}
    
    if((*ptr = (char *)malloc(arglen + varlen + 1)) == (char *)NULL)
	return Error(errno, "IUputenv.malloc", "133");

    (void) sprintf(*ptr, "%s=%s", envvar, value);

    return IU_SUCCESS;
}

#ifdef TEST

main()
{
    char *ptr;
    extern char *getenv();

    IUunset("DBDATE");

    if(IUputenv("DBDATE", "4DMY") != IU_SUCCESS)
    {
	fprintf(stderr, "Putenv failed\n");
	exit(0);
    }

    if((ptr  = getenv("DBDATE")) == (char *)NULL)
    {
	fprintf(stderr, "Putenv failed dbdate not set\n");
	exit(1);
    }

    printf("DBDATE=%s\n", ptr);

    IUunset("DBDATE");

    if((ptr = getenv("DBDATE")) == (char *)NULL)
    {
	fprintf(stderr, "Getenv worked dbdate not set\n");
	exit(1);
    }
}
    
#endif
