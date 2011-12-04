#ifndef _CPROTO
#define _CPROTO

/*
 * File		: c.proto.h - function prototypes for C Programs 
 * 
 * Sccs		: @(#)c.proto.h	1.4 
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

PUBLIC char    *MD5File(char *filename, char *digest);
PUBLIC char    *ReadIntoUntilChar(FILE *fp, char *dest, int until);
PUBLIC char    *ReadSQL(char *into, FILE *from);
PUBLIC void	CStripComment(FILE *instream, FILE *outstream);
PUBLIC int	IsEmptyList(list listptr);
PUBLIC int	IsEmptyStack(stack *stackptr);
PUBLIC status	ListAllocateNode(list *listptr, generic_ptr data);
PUBLIC status	ListAppend(list *listptr, generic_ptr data);
PUBLIC status	ListDeleteNode(list *listptr, list nodetodelete);
PUBLIC status	ListDestroy(list *listptr);
PUBLIC status	IULog(char *filename);
PUBLIC status	IUDirectory(list *alist, char *path);
PUBLIC void	ListFreeNode(list *listptr);
PUBLIC status	ListInitialise(list *listptr);
PUBLIC status	ListInsert(list *listptr, generic_ptr data);
PUBLIC status	StackInitialise(stack *stackptr);
PUBLIC status	StackPop(stack *stackptr, generic_ptr *dataptr);
PUBLIC status	StackPush(stack *stackptr, generic_ptr *dataptr);
PUBLIC status   StackTop(stack *stackptr, generic_ptr *dataptr);
PUBLIC int	match(char *string, char *pattern);
PUBLIC int	hash(char *string);
PUBLIC char    *strip(char *s);
PUBLIC void	rwlockInit(rwlock_t *rwl);
PUBLIC void	rwlockLockRead(rwlock_t *rwl);
PUBLIC void	rwlockUnlockRead(rwlock_t *rwl);
PUBLIC void	rwlockWaitingReaderCleanup(void *arg);
PUBLIC void	rwlockLockWrite(rwlock_t *rwl);
PUBLIC void	rwlockUnlockWrite(rwlock_t *rwl);
PUBLIC void	rwlockWaitingWriterCleanup(void *arg);
#endif
