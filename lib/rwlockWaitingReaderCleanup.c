/*
 * File		: rwlockWaitingReaderCleanup.c
 * 
 * Sccs		: @(#)rwlockWaitingReaderCleanup.c	1.2
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
#endif

#include "c.incl.h"
#include "c.defs.h"
#include "c.class.h"
#include "error.class.h"
#include "c.proto.h"
#include "global.h"

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)rwlockWaitingReaderCleanup.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: rwlockWaitingReaderCleanup - clean up in event of a waiting reader
 *
 * Synopsis	: PUBLIC
 *		  void 
 *		  rwlockWaitingReaderCleanup(arg)
 *		  void *arg;
 *
 * Arguments	: arg - generic pointer cast to a read/write object 
 *
 * Description	: rwlockWaitingReaderCleanup ensures that the mutex lock
 *		  is release in the event of a condition being cancelled.
 *
 * Returns	: void
 *
 * See Also	:
 *
 */

PUBLIC
void 
rwlockWaitingReaderCleanup(arg)
void *arg;
{
    rwlock_t *rwl;

    rwl = (rwlock_t *)arg;

    pthread_mutex_unlock(&rwl->lock);
}
