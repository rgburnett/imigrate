/*
 * File		: rwlockLockWrite.c
 * 
 * Sccs		: @(#)rwlockLockWrite.c	1.2
 *
 * Dated	: 96/10/30 15:24:29 
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

#ifdef TEST
#define MAIN
#endif

#include "c.incl.h"
#include "c.defs.h"
#include "c.class.h"
#include "error.class.h"
#include "c.proto.h"
#include "global.h"

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)rwlockLockWrite.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: rwlockLockWrite - lock mutex in preparation for update 
 *
 * Synopsis	: PUBLIC
 *		  void 
 *		  rwlockLockWrite(rwl)
 *		  rwlock_t *rwl;
 *
 * Arguments	: rwl - read/write object mutex 
 *
 * Description	: rwlockLockWrite locks an object for thread safe update.
 *
 *		  
 *
 * Returns	: void
 *
 * See Also	: rwlockUnlockWrite()
 *
 */

PUBLIC
void
rwlockLockWrite(rwl)
rwlock_t *rwl;
{	
    pthread_mutex_lock(&rwl->lock);

    rwl->waiting_writers++;

    pthread_cleanup_push(rwlockWaitingWriterCleanup, rwl);

    while (rwl->lock_count)
	pthread_cond_wait(&rwl->wcond, &rwl->lock);

    rwl->lock_count = -1;

    pthread_cleanup_pop(1);
}
