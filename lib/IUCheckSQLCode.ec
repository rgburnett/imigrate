/*
 * File		: IUCheckSQLCode.ec
 * 
 * Sccs		: @(#)IUCheckSQLCode.ec	1.2
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
char *sccsid = "SCCS: @(#)IUCheckSQLCode.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUCheckSQLCode - check whether a  statement executed properly 
 *
 * Synopsis	: char *IUCheckSQLCode(statement)
 *		  char *statement;	
 *
 * Arguments	: statement - a dml statement which you have just exectuted.
 *
 * Description	: IUCheckSQLCode checks all 
 *
 * Returns	: status of IU_SUCCESS or IU_ERTERROR on error.
 *
 * See Also	:
 */

PUBLIC
status
IUCheckSQLCode(statement)
char *statement;
{
    EXEC SQL BEGIN DECLARE SECTION;

    int exception_count;
    char overflow[2];
    int exception_num = 1;
    char class[255];
    char subclass[255];
    char message[255];
    int messlen;
    int rowcount;
    char sqlstate[6];
    int i;

    EXEC SQL END DECLARE SECTION; 

    if(!strncmp(SQLSTATE, "00", 2) || !strncmp(SQLSTATE, "02", 2))
	return IU_SUCCESS;

    
    printf("-----------------------\n");
    printf("%s: SQLSTATE: %s\n", statement, SQLSTATE);
    printf("SQLCODE: %d\n", SQLCODE);

    EXEC SQL GET DIAGNOSTICS :exception_count = NUMBER, :overflow = MORE;

    printf("NUMBER: %d\n", exception_count);
    printf("MORE : %s\n", overflow);

    for( i = 1; i <= exception_count; i++)
    {
	$GET DIAGNOSTICS exception :i :sqlstate = RETURNED_SQLSTATE,
	    :class = CLASS_ORIGIN, :subclass = SUBCLASS_ORIGIN,
	    :message = MESSAGE_TEXT, :messlen = MESSAGE_LENGTH;

	printf("SQLSTATE: %s\n", sqlstate);
	printf("CLASS: %s\n", class);
	printf("SUBCLASS: %s\n", subclass);
	printf("TEXT: %s\n", message);
	printf("MESSLEN: %s\n", messlen);

    }

    return IU_ERTERROR;
}
