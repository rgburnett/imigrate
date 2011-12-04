#ifndef _ERRORINCLUDED
#define _ERRORINCLUDED

/*
 * File		: error.h - error handling routine global definitions
 * 
 * Sccs		: @(#)error.class.h	1.3  
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


#define IU_MESGBASE 1000 

typedef enum
{
    IU_SUCCESS = IU_MESGBASE,	/* 1000 */
    IU_EALLOCDESC,
    IU_EDBCONNECT,
    IU_EDEALLOCDESC,
    IU_EDECLARE,
    IU_EDECOMPRESS_MAXBITS,
    IU_EDESCRIBE,
    IU_EFETCH,
    IU_EGETDESC,
    IU_EINVALIDARG,
    IU_EIOERROR,		/* 1010 */
    IU_ELISTINSERT,
    IU_EOPENCURSOR,
    IU_EPREPARE,
    IU_ERROR,
    IU_ERTERROR,
    IU_NODATA,
    IU_WARNING,		
    IU_ECONSTRAINTS,
    IU_EOBJECTEXISTS,
    IU_EEXISTS,			/* 1020 */
    IU_EPERM,
    IU_ESTARTTRANS,
    IU_EENDTRANS,
    IU_EINFORMIXSERVER,
    IU_EINFORMIXDIR
}
status;
    
struct _iu_error
{
    status	iu_errno;
    char	*iu_mesg;
};

GLOBAL
struct _iu_error iu_errlist[]
#ifdef MAIN
=
{
    { IU_SUCCESS,		"Success" },
    { IU_EALLOCDESC,		"Allocate sqlda descriptor failed" },
    { IU_EDBCONNECT,		"Connect to database failed" },
    { IU_EDEALLOCDESC,		"Deallocating an sqlda descriptor failed" },
    { IU_EDECLARE,		"Declare statement failed" },
    { IU_EDECOMPRESS_MAXBITS,	"Decompress maximum bits exceeded" },
    { IU_EDESCRIBE,		"Describe failed" },
    { IU_EFETCH,		"Cursor fetch failed" },
    { IU_EGETDESC,		"Get description failed" },
    { IU_EINVALIDARG,		"Invalid argument" },
    { IU_EIOERROR,		"I/O Error" },
    { IU_ELISTINSERT,		"ListInsert routine failed" },
    { IU_EOPENCURSOR,		"Open Cursor failed" },
    { IU_EPREPARE,		"Prepare failed" },
    { IU_ERROR,			"General Error" },
    { IU_ERTERROR,		"Runtime error" },
    { IU_NODATA,		"No Data Returned" },
    { IU_WARNING,		"Warning" },
    { IU_ECONSTRAINTS,		"Failure to Set Constraints Mode" },
    { IU_EOBJECTEXISTS,		"Database Object Exists" },
    { IU_EEXISTS,		"Object Does Not Exist" },
    { IU_EPERM,			"Insufficient privilige to execute this function" },
    { IU_ESTARTTRANS,		"cannot begin transaction" },
    { IU_EENDTRANS,		"cannot commit transaction" },
    { IU_EINFORMIXSERVER,	"INFORMIXSERVER not set in environment" },
    { IU_EINFORMIXDIR,		"INFORMIXDIR not set in environment" }
}
#endif
;

#endif
