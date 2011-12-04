#ifndef _CCLASSINCLUDED
#define _CCLASSINCLUDED

/*
 * File		: c.class.h - C abstract type definitions
 * 
 * Sccs		: @(#)c.class.h	1.4 
 *
 * Dated	: 96/10/30 15:38:37 
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

typedef struct 
{
    pthread_mutex_t lock;
    pthread_cond_t  rcond;
    pthread_cond_t  wcond;
    int lock_count;		/* < 0 .. held by writer             */
				/* > 0 .. held by lock_count readers */
				/* = 0 .. held by nobody             */
    int waiting_writers;	/* count of wating writers      */
}
rwlock_t;

typedef char *generic_ptr;
typedef struct node node, *list;
typedef long int count_int;
typedef long int code_int;


struct node
{
    generic_ptr datapointer;
    list next;
    list prev; 	/* not implemented */
};

typedef struct
{
    int status;
    char name[ 10 ];
}
dbconnection;

typedef struct
{
    generic_ptr *base;
    generic_ptr *top;
    int stacksize;
}
stack;

typedef enum _dbobjclass 
{
    COLUMN,
    CONSTRAINT,
    INDEX, 
    PROCEDURE,
    SYNONYM,
    TABLE, 
    TRIGGER,
    USER,
    DBSPACE,
    DBCHUNK,
    DATABASE
}
dbobjclass;

typedef enum _ConstraintOperation
{
    ENABLED,
    DISABLED,
    FILTERING
}
ConstraintOperation;

typedef enum _sqlerrors
{
    REPORT,
    IGNORE,
    REPORTWARNINGS
}
sqlerrors;

typedef enum _dbaccess
{
    NORMAL,
    EXCLUSIVE
}
dbaccess;

typedef struct _objexists 
{
    dbobjclass object;
    char *retrieval;
}
objectexists;

extern char *sys_errlist[];

#endif
