#ifndef _ESQLCLASSINCLUDED
#define _ESQLCLASSINCLUDED

/*
 * File		: esql typedefs 
 * 
 * Sccs		: @(#)esql.class.h	1.3 
 *
 * Dated	: 96/10/30 15:38:38 
 *
 * Owner	: Graeme Burnett
 *
 * Notes	: 
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

EXEC SQL BEGIN DECLARE SECTION; 

/*
 * Used to store the entry from sqlhosts of the current connection. 
 */

typedef struct _connectioninfo
{
    char informix_server[ INFORMIX_NAME_LEN ];
    char connection_type[ INFORMIX_NAME_LEN ];
    char host[ PATH_MAX ];
    char server_ent[ INFORMIX_NAME_LEN ];
}
connectioninfo;

typedef struct _columninfo
{
    int type;
    int len;
    int nullable;
    int is_null;
    char name[ INFORMIX_NAME_LEN ];
}
columninfo;

typedef struct _dbspace
{
    int		op;
    char	spacename[ 18 ];
    int		pagesize;
    char	path[ PATH_MAX ];
    int		offset;
    int		size;
    int		tmp;
    char	mirror_path[ PATH_MAX ];
    int		mirror_offset;
}
dbspace;

EXEC SQL END DECLARE SECTION; 

#endif
