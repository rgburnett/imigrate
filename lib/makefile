#
# Name 		: makefile - for irun and the libdb.a archive 
#
# Synopsis	: make -f makefile 
#
# Arguments	: none
#
# Description	: This makefile construcst the library 
#
# See Also	: 
#
# Sccs 		: @(#)makefile	1.3 
#
# Continuus 
# Project	: %subsystem% %filespec%";

ESQL=esql
ESQLCFLAGS=-g -I$(INCLUDE) -local
CFLAGS=-g -I$(INCLUDE)
CC=cc_r
GET=iget

.SUFFIXES	: .ec .ec~

.ec.o:
	@rm -f $*.o $*.c
	$(ESQL) -c $(ESQLCFLAGS) $<

.ec.a:
	@rm -f $*.o $*.c
	$(ESQL) -c $(ESQLCFLAGS) $<
	$(AR) $(ARFLAGS) $@ $*.o
	@rm -f $*.o $*.c

.ec:
	@rm -f $*.o $*.c
	$(ESQL) $(ESQLCFLAGS) $< -o $@
	@rm -f $*.o $*.c

.ec~.o:
	$(GET) $(GFLAGS) -p $< > $*.ec
	@rm -f $*.o $*.c
	$(ESQL) -c $(ESQLCFLAGS) $<
	@rm -f $*.o $*.c

INCLUDE=../incl

HEADERS= \
	$(INCLUDE)/c.class.h	\
	$(INCLUDE)/c.defs.h	\
	$(INCLUDE)/c.incl.h	\
	$(INCLUDE)/c.proto.h	\
	$(INCLUDE)/error.class.h\
	$(INCLUDE)/esql.class.h	\
	$(INCLUDE)/esql.defs.h	\
	$(INCLUDE)/esql.incl.h	\
	$(INCLUDE)/esql.proto.h	\
	$(INCLUDE)/global.h	\
	$(INCLUDE)/hash.h	\
	$(INCLUDE)/md5.h	\
	$(INCLUDE)/md5global.h

LIBDIR=../../lib

IULIB=$(LIBDIR)/libdb.a
LOCKLIB=$(LIBDIR)/liblock.a

#ESQLCFLAGS= -O -I$(INCLUDE)
#CFLAGS= -O -I.$(INCLUDE)

all: $(IULIB) $(LOCKLIB)


$(IULIB): \
	$(HEADERS) 					\
	makefile 					\
	$(LIBDIR)/libdb.a(CStripComment.o) 		\
	$(LIBDIR)/libdb.a(Error.o) 			\
	$(LIBDIR)/libdb.a(IUCheck.o) 			\
	$(LIBDIR)/libdb.a(IUCheckSQLCode.o) 		\
	$(LIBDIR)/libdb.a(IUCheckDBSignature.o) 	\
	$(LIBDIR)/libdb.a(IUColumnInfo.o)	 	\
	$(LIBDIR)/libdb.a(IUCompress.o) 		\
	$(LIBDIR)/libdb.a(IUConstraints.o) 		\
	$(LIBDIR)/libdb.a(IUConnectionInfo.o) 		\
	$(LIBDIR)/libdb.a(IUDirectory.o) 		\
	$(LIBDIR)/libdb.a(IUDBConnect.o)		\
	$(LIBDIR)/libdb.a(IUDBDisconnect.o)		\
	$(LIBDIR)/libdb.a(IUDatabase.o)			\
	$(LIBDIR)/libdb.a(IUDBObjectExists.o)		\
	$(LIBDIR)/libdb.a(IUDisplayError.o) 		\
	$(LIBDIR)/libdb.a(IUDisplayException.o)		\
	$(LIBDIR)/libdb.a(IUDisplaySQLStateError.o)	\
	$(LIBDIR)/libdb.a(IUDisplayShortError.o) 	\
	$(LIBDIR)/libdb.a(IUDisplayWarning.o) 		\
	$(LIBDIR)/libdb.a(IUEnv.o) 			\
	$(LIBDIR)/libdb.a(IUExpressionCheck.o) 		\
	$(LIBDIR)/libdb.a(IULoadTable.o) 		\
	$(LIBDIR)/libdb.a(IULog.o)	 		\
	$(LIBDIR)/libdb.a(IUListTables.o) 		\
	$(LIBDIR)/libdb.a(IUMasterTableList.o) 		\
	$(LIBDIR)/libdb.a(IUMD5file.o)			\
	$(LIBDIR)/libdb.a(IUOnspaces.o)			\
	$(LIBDIR)/libdb.a(IURunSQL.o) 			\
	$(LIBDIR)/libdb.a(IURenameTable.o) 		\
	$(LIBDIR)/libdb.a(IUSQLStateError.o) 		\
	$(LIBDIR)/libdb.a(IUTime.o) 			\
	$(LIBDIR)/libdb.a(IUTransaction.o) 		\
	$(LIBDIR)/libdb.a(IUUnloadTable.o) 		\
	$(LIBDIR)/libdb.a(ListAllocNode.o) 		\
	$(LIBDIR)/libdb.a(ListAppend.o) 		\
	$(LIBDIR)/libdb.a(ListDelete.o) 		\
	$(LIBDIR)/libdb.a(ListDestroy.o) 		\
	$(LIBDIR)/libdb.a(ListDeleteNode.o) 		\
	$(LIBDIR)/libdb.a(ListEmpty.o) 			\
	$(LIBDIR)/libdb.a(ListFreeNode.o) 		\
	$(LIBDIR)/libdb.a(ListInitialise.o) 		\
	$(LIBDIR)/libdb.a(ListInsert.o) 		\
	$(LIBDIR)/libdb.a(ReadSQL.o) 			\
	$(LIBDIR)/libdb.a(StackEmpty.o) 		\
	$(LIBDIR)/libdb.a(StackInit.o) 			\
	$(LIBDIR)/libdb.a(StackPop.o) 			\
	$(LIBDIR)/libdb.a(StackPush.o) 			\
	$(LIBDIR)/libdb.a(StackTop.o) 			\
	$(LIBDIR)/libdb.a(StripNewLine.o) 		\
	$(LIBDIR)/libdb.a(match.o) 			\
	$(LIBDIR)/libdb.a(md5c.o) 			\
	$(LIBDIR)/libdb.a(hash.o)			\
	$(LIBDIR)/libdb.a(strip.o)

$(LOCKLIB): \
	$(HEADERS) 					\
	makefile 					\
	$(LIBDIR)/liblock.a(rwlockInit.c)		\
	$(LIBDIR)/liblock.a(rwlockLockRead.c)		\
	$(LIBDIR)/liblock.a(rwlockLockWrite.c)		\
	$(LIBDIR)/liblock.a(rwlockUnlockRead.c)		\
	$(LIBDIR)/liblock.a(rwlockUnlockWrite.c)	\
	$(LIBDIR)/liblock.a(rwlockWaitingReaderCleanup.c)	\
	$(LIBDIR)/liblock.a(rwlockWaitingWriterCleanup.c)
