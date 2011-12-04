#
# Description	: makefile for iexport 
#
# Notes		: Builds the iexport binary into ../../dbtools 
#		  
# Status	: INTERNAL DB TEAM USE ONLY
#
# Sccs		: %W% 
#
# Dated		: %D% %T% 
#
# Owner		: Graeme Burnett
#
# Continuus
#
# Type		: %cvtype: %
# Created by	: %created_by: %
# Date Created	: %date_created: %
# Date Modified : %date_modified: %
# Derived by	: %derived_by: %
# File/Version	: %filespec: %
#
#

IULIB=../../lib/libdb.a
LOCKLIB=../../lib/liblock.a
INFORMIXC=cc_r
CC=cc_r
ESQL=esql
ESQLCFLAGS=-g -local -I../incl
CFLAGS= -g -I../incl
DESTDIR=/home/burnetg/dbtools

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

$(DESTDIR)/iexport : iexport.o $(IULIB)
	(export INFORMIXC=cc_r ; $(ESQL) $(ESQLCFLAGS) $(*F).o -lc_r $(IULIB) $(LOCKLIB) -o $@)
	@rm -f $*.o $*.c

iexport.o : iexport.ec
