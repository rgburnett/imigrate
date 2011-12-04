/*
 * File		: rwlockWaitingWriterCleanup.c
 * 
 * Sccs		: @(#)rwlockWaitingWriterCleanup.c	1.2
 *
 * Dated	: 96/10/30 15:24:30 
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
EXEC SQL define MAIN
#endif

#include "c.incl.h"
#include "c.defs.h"
#include "c.class.h"
#include "error.class.h"
#include "c.proto.h"
#include "global.h"

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)rwlockWaitingWriterCleanup.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: rwlockWaitingWriterCleanup - clean up waiting write threads if lock cancelled
 *
 * Synopsis	: PUBLIC
 *		  void
 *		  rwlockWaitingWriterCleanup(arg)
 *		  void *arg;
 *
 * Arguments	: arg - rwlock_t object
 *
 * Description	: rwlockWaitingWriterCleanup - Reset the mutex resource in
 *		  case the event is cancelled
 *
 * Returns	: void
 *
 * See Also	:
 *
 */

PUBLIC
void
rwlockWaitingWriterCleanup(arg)
void *arg;
{
    rwlock_t *rwl = (rwlock_t *)arg;

    rwl->waiting_writers--;

    /*
     * This only happens if we have been canceled
     */

    if ((!rwl->waiting_writers) && (rwl->lock_count >= 0))
	pthread_cond_broadcast(&rwl->wcond);

    pthread_mutex_unlock(&rwl->lock);
}
