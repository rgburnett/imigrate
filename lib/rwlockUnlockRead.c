/*
 * File		: rwlockUnlockRead.c
 * 
 * Sccs		: @(#)rwlockUnlockRead.c	1.2
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
char *sccsid = "SCCS: @(#)rwlockUnlockRead.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: rwlockUnlockRead - unlock a read locked resource 
 *
 * Synopsis	: PUBLIC
 *		  void 
 *		  rwlockUnlockRead(rwl)
 *		  rwlock_t *rwl;
 *
 * Arguments	: rwl - read/write lock object.
 *
 * Description	: rwlockUnlockRead discards a previously acquired read lock 
 *
 * Returns	: void
 *
 * See Also	:
 *
 */

PUBLIC
void 
rwlockUnlockRead(rwl)
rwlock_t *rwl;
{
    pthread_mutex_lock(&rwl->lock);

    rwl->lock_count--;

    if (!rwl->lock_count)
	pthread_cond_signal(&rwl->wcond);

    pthread_mutex_unlock(&rwl->lock);
}
