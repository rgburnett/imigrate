/*
 * File		: IUCheckDbSignature.ec
 * 
 * Sccs		: @(#)IUCheckDBSignature.ec	1.2
 *
 * Dated	: 96/10/30 15:24:17 
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

#include "c.incl.h"
#include "c.defs.h"
#include "c.class.h"
#include "error.class.h"
#include "c.proto.h"
#include "global.h"

PRIVATE 
FINAL
char *sccsid = "SCCS @(#)IUCheckDBSignature.ec	1.2 : Continuus Project: %subsystem% %filespec%";

/*{{ FUNCDOC 3
 *
 * Name 	: IUCheckDbSignature - check a digital signature on an in-situ schema
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  IUCheckDbSignature(databasename, sigfile, grants)
 *		  char *databasename;
 *		  char *sigfile;
 *		  int grants;
 *
 * Arguments	: databasename	- the name of the target database
 *
 *		  sigfile	- A file containing known Digital Signatures 
 *
 *		  grants	- do not exclude grants when generating MD5 string
 *
 * Description	: IUCheckDbSignature performs an MD5 checksum of an in situ 
 *		  database schema and compares this value with those stored in
 *		  a signature file.
 *
 * Returns	: IU_SUCCESS if the database is a known version, IU_NODATA if
 *		  this database is unknown. 
 *
 *		  status values on error.
 *
 * See Also	: MD5
 *
 */

PUBLIC
status
IUCheckDbSignature(databasename, sigfile, grants)
char *databasename;
char *sigfile;
int grants;
{
    FILE *fp;
    char cmd[ 200 ];
    char digest[ 16 ];
    char digeststring[ 40 ];
    char digestbuf[ 3 ];
    char buf[ 256 ];
    unsigned int i;
    static char *md5_with_grants = "dbschema -d %s | sed -e '1,/^Software/d'";
    static char *md5_without_grants = 
	"dbschema -d %s | sed -e '1,/^Software/d' -e '/^grant /d'";

    extern FILE *fopen();


    if(grants)
	sprintf(cmd, md5_with_grants, databasename);
    else
	sprintf(cmd, md5_without_grants, databasename);

    if(( fp = popen(cmd, "r")) == (FILE *)NULL)
	return Error(errno, "IUCheckDBSignature", "89");

    IUMD5Stream(fp, digest);

    pclose(fp);

    for(i = 0; i < 16; i++)
    {
	sprintf(digestbuf, "%02x", digest[ i ]);
	strcat(digeststring, digestbuf);
    }

    if((fp = fopen(sigfile, "r")) == (FILE *)NULL)
	return Error(errno, "iimport.IUCheckDbSignature.fopen", "102");


    while(fread(buf, 1, 256, fp))
    {
	if(!memcmp(buf, digeststring, 16))
	{
	    fclose(fp);
	    return IU_SUCCESS;
	}
    }

    fclose(fp);

    return IU_NODATA;
}

