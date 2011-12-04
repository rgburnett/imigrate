#include <pthread.h>	/* include file for pthreads - the 1st */
#include <stdio.h>	/* include file for printf()           */
#include <unistd.h>	/* include file for sleep()            */

char *tables[ 8 ] = {
"1",
"2",
"3",
"4",
"5",
"6",
"7",
"8"
};

void *IUUnloadTable(string)
void *string;
{
    for(;;)
    {
	putchar('a');
	fflush(stdout);
	sleep(1);
    }

    pthread_exit(NULL);
}

int main()
{
    int rc;
    int i;
    int retval;
    pthread_t thread[ 8 ];

    void *IUUnloadTable();
    setbuf(stdout, NULL);

    for( i = 0; i < 8; i++)
    {
	if((retval = pthread_create(&thread[ i ], NULL, IUUnloadTable, 
						    (void *)tables[i])) != 0)
	{
	    perror("Thread");
	    exit(-1);
	}

	printf("Started Thread %d\n", thread[ i ]);
    }

    sleep(100);

    exit(0);
}


int
mutex()
{

    pthread_mutex_t mutex;

    pthread_mutexattr_t attributes;

    pthread_mutexattr_init(&attributes))


    pthread_mutex_init(&mutex, &attributes))



    pthread_mutexattr_destroy(&attributes);
}

/* the initial thread */
pthread_mutex_t mutex;
int i;
...
pthread_mutex_init(&mutex, NULL);    /* creates the mutex      */

for (i = 0; i < num_req; i++)        /* loop to create threads */
	pthread_create(th + i, NULL, rtn, &mutex);
...                                  /* waits end of session   */
pthread_mutex_destroy(&mutex);       /* destroys the mutex     */
...
/* the request handling thread */
...                                  /* waits for a request  */
pthread_mutex_lock(&db_mutex);       /* locks the database   */
...                                  /* handles the request  */
pthread_mutex_unlock(&db_mutex);     /* unlocks the database */
...


typedef struct {
	pthread_mutex_t lock;
	pthread_cond_t cond;
	int count;
} sema_t;
void sema_init(sema_t *sem)
{
	pthread_mutex_init(&sem->lock, NULL);
	pthread_cond_init(&sem->cond, NULL);
	sem->count = 1;
}
void sema_destroy(sema_t *sem)
{
	pthread_mutex_destroy(&sem->lock);
	pthread_cond_destroy(&sem->cond);
}
void p_operation_cleanup(void *arg)
{
	sema_t *sem;


	sem = (sema_t *)arg;
	pthread_mutex_unlock(&sem->lock);
}
void sema_p(sema_t *sem)
{
	pthread_mutex_lock(&sem->lock);
	pthread_cleanup_push(p_operation_cleanup, sem);
	while (sem->count <= 0)
		pthread_cond_wait(&sem->cond, &sem->lock);
	sem->count--;		pthread_cond_wait(&sem->cond, &sem->lock);
	sem->count--;
	/*
	 *  Note that the pthread_cleanup_pop subroutine will
	 *  execute the p_operation_cleanup routine
	 */
	pthread_cleanup_pop(1);
}
void sema_v(sema_t *sem)
{
	pthread_mutex_lock(&sem->lock);
	sem->count++;
	if (sem->count <= 0)
		pthread_cond_signal(&sem->cond);
	pthread_mutex_unlock(&sem->lock);
}
