/*
 * File		: IUColumnInfo.ec
 * 
 * Sccs		: @(#)IUColumnInfo.ec	1.2
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

#include "c.incl.h"
#include "c.defs.h"
#include "c.class.h"
#include "error.class.h"
#include "c.proto.h"
#include "global.h"

EXEC SQL include "esql.class.h";

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)IUColumnInfo.ec	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUColumnInfo - get information about a column
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  IUColumnInfo(colobj, index)
 *		  EXEC SQL BEGIN DECLARE SECTION;
 *		  PARAMETER columninfo *colobj;
 *		  PARAMETER int index;
 *		  EXEC SQL END DECLARE SECTION;
 *
 * Arguments	: index - the column number in the table you are interested in
 *
 * Description	: IUColumnInfo returns information about a column
 *		  in a "columninfo" structure detailing the attributes 
 *		  for a column.
 *
 *		  The columns are self explanitory.
 *
 * Returns	: status value of IU_SUCCESS on success, status codes otherwise 
 *
 * See Also	: esql.class.h
 *
 */

PUBLIC
status
IUColumnInfo(colobj, index)
EXEC SQL BEGIN DECLARE SECTION;
PARAMETER columninfo *colobj;
PARAMETER int index;
EXEC SQL END DECLARE SECTION;
{
    EXEC SQL get descriptor 'IUUTdesc' VALUE :index 
	:colobj->type = TYPE,
        :colobj->len = LENGTH, 
	:colobj->nullable = NULLABLE, 
	:colobj->is_null = INDICATOR,
	:colobj->name = NAME;

    return IUCheck("IUColumnInfo: get descriptor");
}
