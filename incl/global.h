#ifndef _GLOBALINCLUDED
#define _GLOBALINCLUDED

/*
 * File		: globals.h - global communication objects
 *
 * Sccs		: @(#)global.h	1.3 
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

GLOBAL dbconnection connection[ MAX_CONNECTIONS ];
GLOBAL int linecount;
GLOBAL int database_has_logging;
GLOBAL int database_is_ansi;

#endif
