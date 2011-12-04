/*
 * File		: IUDisplaySQLStateError.ec
 * 
 * Sccs		: @(#)IUDisplaySQLStateError.ec	1.2
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

#include "c.incl.h"
#include "c.defs.h"
#include "c.class.h"
#include "error.class.h"
#include "c.proto.h"
#include "global.h"

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)IUDisplaySQLStateError.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUDisplaySQLStateError - display an sql error 
 *
 * Synopsis	: void IUDisplaySQLStateError()
 *
 * Arguments	: none
 *
 * Description	: IUDisplaySQLStateError is based on the routine
 *		  supplied with the ESQL/C manual.
 *
 * See Also	:
 *
 * Sccs 	: @(#)IUDisplaySQLStateError.ec	1.2 
 *
 * Continuus 
 * Project	: %subsystem% %filespec%";
 */

PUBLIC
void
IUDisplaySQLStateError()
{

    int j;

    EXEC SQL BEGIN DECLARE SECTION;

    int	i;
    int	exception_count;
    char overflow[2];
    int exception_num = 1;
    char class_id[255];
    char subclass_id[255];
    char message[255];
    int messlen;
    int rowcount;
    char sqlstate_code[6];

    EXEC SQL END DECLARE SECTION; 


    printf("-----------------------\n");
    printf("SQLSTATE: %s\n", SQLSTATE);
    printf("SQLCODE: %d\n", SQLCODE);
    printf("\n");

    EXEC SQL get diagnostics :exception_count = NUMBER;

    printf("Exceptions: Number = %d\n", exception_count);
    printf("More? : %s\n", overflow);

    for( i = 1; i <= exception_count; i++)
    {
	EXEC SQL get DIAGNOSTICS exception :i 
		:sqlstate_code = RETURNED_SQLSTATE,
		:class_id = CLASS_ORIGIN, 
		:subclass_id = SUBCLASS_ORIGIN,
		:message = MESSAGE_TEXT,
		:messlen = MESSAGE_LENGTH;

	printf("EXCEPTION %d: SQLSTATE = %s\n", i, sqlstate_code);
	message[ messlen - 1 ] = '\0';
	printf("MESSAGE TEXT: %s\n", message);

	j = byleng(class_id, stleng(class_id));
	class_id[ j ] = '\0';
	printf("CLASS ORIGIN: %s\n", class_id);

	j = byleng(subclass_id, stleng(subclass_id));
	subclass_id[ j ] = '\0';
	printf("SUBCLASS ORIGIN: %s\n", subclass_id);

    }
}
