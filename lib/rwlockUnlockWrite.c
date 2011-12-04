/*
 * File		: rwlockUnlockWrite.c
 * 
 * Sccs		: @(#)rwlockUnlockWrite.c	1.2
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
char *sccsid = "SCCS: @(#)rwlockUnlockWrite.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: rwlockUnlockWrite - release a write lock on a mutex object
 *
 * Synopsis	: PUBLIC
 *		  void 
 *		  rwlockUnlockWrite(rwl)
 *		  rwlock_t *rwl;
 *
 * Arguments	: rwl - read/write mutex object
 *
 * Description	: rwlockUnlockWrite unlocks a mutex resource and if there
 *		  are any waiters, wakes up blocked threads.
 *
 * Returns	: void
 *
 * See Also	:
 *
 */

PUBLIC
void 
rwlockUnlockWrite(rwl)
rwlock_t *rwl;
{
    pthread_mutex_lock(&rwl->lock);

    rwl->lock_count = 0;

    if (!rwl->waiting_writers)
	pthread_cond_broadcast(&rwl->rcond);
    else
	pthread_cond_signal(&rwl->wcond);

    pthread_mutex_unlock(&rwl->lock);
}
