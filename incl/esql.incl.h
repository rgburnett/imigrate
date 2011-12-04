#ifndef _ESQLINCLUDESINCLUDED
#define _ESQLINCLUDESINCLUDED

/*
 * File		: esql.incl.h
 * 
 * Sccs		: @(#)esql.incl.h	1.3 
 *
 * Dated	: 96/10/30 15:38:38 
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

EXEC SQL include "stdio.h";
EXEC SQL include "sys/times.h";
EXEC SQL include "sys/resource.h";
EXEC SQL include "procinfo.h";
EXEC SQL include "sys/types.h";
EXEC SQL include "ctype.h";
EXEC SQL include "malloc.h";
EXEC SQL include "sys/limits.h";
EXEC SQL include "errno.h";

EXEC SQL include sqltypes;
EXEC SQL include sqlstype;
EXEC SQL include decimal;
EXEC SQL include datetime;
EXEC SQL include sqlca;
EXEC SQL include sqlda;
EXEC SQL include varchar;

#endif
