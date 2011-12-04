#
# Description	: makefile for iimport 
#
# Notes		: none  
#		  
# Status	: INTERNAL DB TEAM USE ONLY
# 
# Sccs		: @(#)makefile	1.6 
#
# Dated		: 96/10/24 14:43:51 
#
# Owner		: Graeme Burnett
#
# Continuus
#
# Type		: %cvtype: %
# Created by	: %created_by: %
# Date Created	: %date_created: %
# Date Modified: %date_modified: %
# Derived by	: %derived_by: %
# File/Version	: %filespec: %
#
#


DESTDIR=../../dbtools
IULIB=../../lib/libdb.a
ESQL=esql
ESQLCFLAGS= -g -local -I../incl
CFLAGS= -I../incl

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

OBJECTS= \
	CreateTableDDL.o	\
	CreateViolations.o	\
	TargetTableName.o	\
	MigrateTableName.o	\
	MakeMigrateSpace.o	\
	MigrateDatabase.o	\
	ParseArgs.o		\
	RmConstraintName.o	\
	StopViolations.o	\
	Signals.o		\
	iimport.o

$(DESTDIR)/iimport : iimport.h $(OBJECTS) $(IULIB) makefile
	$(ESQL) $(ESQLCFLAGS) $(OBJECTS) $(IULIB) -o $@
	@rm -f $*.o $*.c


CreateTableDDL.o	: CreateTableDDL.ec	iimport.h
CreateViolations.o	: CreateViolations.ec	iimport.h
TargetTableName.o	: TargetTableName.ec	iimport.h
MigrateTableName.o	: MigrateTableName.ec	iimport.h
MakeMigrateSpace.o	: MakeMigrateSpace.ec	iimport.h
MigrateDatabase.o	: MigrateDatabase.ec	iimport.h
ParseArgs.o		: ParseArgs.ec		iimport.h
RmConstraintName.o	: RmConstraintName.ec	iimport.h
MakeTmpDbName.o		: MakeTmpDbName.ec	iimport.h
StopViolations.o	: StopViolations.ec	iimport.h
iimport.o		: iimport.ec		iimport.h
Signals.o		: Signals.ec		iimport.h
iimport.h		:
