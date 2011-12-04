/*
 * File		: rwlockInit.c
 * 
 * Sccs		: @(#)rwlockInit.c	1.2
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
char *sccsid = "SCCS: @(#)rwlockInit.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: rwlockInit - initialiase a read/write lock object
 *
 * Synopsis	: PUBLIC
 *		  void 
 *		  rwlockInit(rwl)
 *		  rwlock_t *rwl;
 *
 * Arguments	: rwl - a read/write lock data object
 *
 * Description	: rwlockInit initialises a write priority lock for a multi-threaded
 *		  program
 *
 */

PUBLIC
void 
rwlockInit(rwl)
rwlock_t *rwl;
{
    pthread_mutex_init(&rwl->lock, NULL);
    pthread_cond_init(&rwl->wcond, NULL);
    pthread_cond_init(&rwl->rcond, NULL);

    rwl->lock_count = 0;
    rwl->waiting_writers = 0;
}


#ifdef TEST

int counter = 0;	/* thread sync resource */

void *threadWriter(void *arg);
void *threadReader(void *arg);

main()
{
    rwlock_t a, *mptr = &a;
    pthread_t	write_thread;
    pthread_t	read_thread;
    int retval;

    rwlockInit(&a);

    if((retval = pthread_create(&write_thread, NULL, threadWriter, (void *)mptr)) != 0)
    {
	Error(errno, "test.pthread_create", "84");
	exit(0);
    }

    if((retval = pthread_create(&read_thread, NULL, threadReader, (void *)mptr)) != 0)
    {
	Error(errno, "test.pthread_create", "90");
	exit(0);
    }

    sleep(1);

    printf("Main - waiting for lock on counter\n");

    rwlockLockWrite(&a);

    printf("Main - lock gained\n");

    counter++;

    rwlockUnlockWrite(&a);

    rwlockLockRead(&a);

    printf("Main - counter is %d\n", counter);

    rwlockUnlockRead(&a);

    for(;;) sleep(1000);

    exit(0);
}

void *
threadWriter(rwl)
void *rwl;
{
    rwlock_t *ptr = (rwlock_t *)rwl;

    for(;;)
    {
	rwlockLockWrite(ptr);

	printf("Thread Writer [ %d ]\n", counter);

	counter++;

	if(counter == 1)
	    sleep(10);
	rwlockUnlockWrite(ptr);
	sleep(1);

    }
}

void *
threadReader(rwl)
void *rwl;
{
    rwlock_t *ptr = (rwlock_t *)rwl;

    for(;;)
    {
	rwlockLockRead(ptr);

	printf("Thread Reader [ %d ]\n", counter);

	rwlockUnlockRead(ptr);
	sleep(1);
    }
}

#endif
