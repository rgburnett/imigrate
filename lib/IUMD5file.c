/*
 * File		: IUMD5file.c
 * 
 * Sccs		: @(#)IUMD5file.c	1.2
 *
 * Dated	: 96/10/30 15:24:22 
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
#include "md5global.h"
#include "md5.h"

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)IUMD5file.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUMD5String - return the MD5 hash of a string
 *
 * Synopsis	: PUBLIC
 *		  char *
 *		  IUMD5String (string)
 *		  char	*string;
 *
 * Arguments	: string - a string to hash
 *
 * Description	: IUMD5String returns the md5 hash of a string
 *
 * Returns	: a pointer to the hash string or a NULL pointer on error
 *
 * See Also	: MD5
 *
 */


PUBLIC
char *
IUMD5String (string)
char *string;
{
    static unsigned char digest[16];
    MD5_CTX context;
    unsigned int len = strlen (string);

    MD5Init(&context);
    MD5Update(&context, string, len);
    MD5Final(digest, &context);

    return digest;
}

/*{{ FUNCDOC
 *
 * Name 	: MD5File - return the MD5 of a file
 *
 * Synopsis	: PUBLIC
 *		  char *
 *		  MDFile(filename)
 *		  char	*filename;
 *
 * Arguments	: filename - the name of the file to hash
 *
 * Description	: MDFile is a lift from the mddriver function in rfc1321 
 *
 * Returns	: a pointer to the hash or null on error
 *
 * See Also	: MD5
 *
 */


PUBLIC
char *
MD5File(filename, digest)
char	*filename;
char    *digest;
{
    FILE *fp;
    MD5_CTX context;
    int	len;
    unsigned char	buffer[4096];

    if ((fp = fopen(filename, "rb")) == (FILE *)NULL)
    {
	Error(errno, filename, "103");
	return (char *)NULL;
    }

    MD5Init (&context);

    while (len = fread (buffer, 1, 4096, fp))
	MD5Update (&context, buffer, len);
    MD5Final (digest, &context);

    fclose (fp);

    return digest;
}

/*{{ FUNCDOC
 *
 * Name 	: IUMD5Stream - produce a hash of a FILE stream
 *
 * Synopsis	: PUBLIC
 *		  char *
 *		  IUMD5Stream(fp, digest)
 *		  FILE *fp;
 *		  char *digest;
 *
 * Arguments	: fp - a FILE pointer
 *
 *		  digest - buffer to store the digest in
 *
 * Description	: 
 *
 * Returns	:
 *
 * See Also	:
 *
 */

PUBLIC
char *
IUMD5Stream(fp, digest)
FILE *fp;
char *digest;
{
    MD5_CTX context;
    int	len;
    unsigned char	buffer[4096];

    if(fp == (FILE *)NULL || ferror(fp))
    {
	Error(errno, "IUMD5Stream", "152");
	return (char *)NULL;
    }

    MD5Init (&context);

    while (len = fread (buffer, 1, 4096, fp))
	MD5Update (&context, buffer, len);
    MD5Final (digest, &context);

    return digest;
}
