#ifndef _HASHINCLUDED
#define _HASHINCLUDED

/*
 * File		: hash.h - hash header 
 * 
 * Sccs		: @(#)hash.h	1.3 
 *
 * Dated	: 96/10/30 15:38:39 
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
 * Each token enumerates to a value which will be returned by hash(3db)
 *
 * Nota Bene: You must also explicitly check the string one you get a hash hit
 *            as the hash(3db) function gives a reasonably but not uniq distribution
 *
 */

typedef     enum _keywordhash
{
    ECREATE   = 	868,
    ETABLE    = 	142,
    EALTER    = 	 34,
    EDROP     = 	  0,
    EFRAGMENT = 	 30,
    ECONSTRAINT = 	943,
    ECLOSE    = 	867,
    ECONNECT  = 	940,
    EEXECUTE  = 	603,
    EGET      = 	404,
    EGRANT    = 	406,
    EINFO     = 	798,
    EINSERT   = 	141,
    ELOAD     = 	108,
    EOPEN     = 	951,
    EPREPARE  = 	676,
    ERENAME   = 	409,
    EROLLBACK = 	849,
    ESELECT   = 	859,
    ESET      = 	856,
    EUNLOCK   = 	960,
    EUPDATE   = 	522,
    EWHENEVER = 	183,
    ESCAN     = 2000,
    ETABLENAME,
}
keywordenum;

#endif
