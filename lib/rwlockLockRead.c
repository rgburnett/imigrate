/*
 * File		: rwlockLockRead.c
 * 
 * Sccs		: @(#)rwlockLockRead.c	1.2
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
char *sccsid = "SCCS: @(#)rwlockLockRead.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: rwlockLockRead - obtain a read lock in order to read a resource 
 *
 * Synopsis	: PUBLIC
 *		  void 
 *		  rwlockLockRead(rwl)
 *		  rwlock_t *rwl;
 *
 * Arguments	: rwl - a read/write object
 *
 * Description	: rwlockRead obtains a read lock to read the value of the
 *		  mutex resource.
 *
 * Returns	: void
 *
 * See Also	:
 *
 */

PUBLIC
void 
rwlockLockRead(rwl)
rwlock_t *rwl;
{
    pthread_mutex_lock(&rwl->lock);

    pthread_cleanup_push(rwlockWaitingReaderCleanup, rwl);

    while ((rwl->lock_count < 0) && (rwl->waiting_writers))
	pthread_cond_wait(&rwl->rcond, &rwl->lock);

    rwl->lock_count++;

    /*
     *  Note that the pthread_cleanup_pop subroutine will
     *  execute the waiting_reader_cleanup routine
     */

    pthread_cleanup_pop(1);
}
