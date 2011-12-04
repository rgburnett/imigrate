#
# Name 		: makefile - for iconstraints 
# 
# Description	: builds the iconstraints binary 
#
# Notes		: Suffix rules need a bit of a revisit
#	        
# Perms		: 444 
# 
# Status	: SUPPORTED
# 
# Owner		: Graeme Burnett 
# 
# Sccs Id	: @(#)makefile	1.4 
#
# Created	: 96/10/24 14:38:21 
# 
# Continuus
# 
# Type		: %cvtype: %
# Created by	: %created_by: %
# Date Created	: %date_created: %
# Date Modified	: %date_modified: %
# Derived by	: %derived_by: %
# File/Version	: %filespec: bollocks,3 %
#

DESTDIR=../../dbtools
IULIB=../../lib/libdb.a
ESQL=esql
ESQLCFLAGS= -I../incl
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


OBJECTS= iconstraints.o


$(DESTDIR)/iconstraints : iconstraints.h $(OBJECTS) $(IULIB)
	$(ESQL) $(ESQLCFLAGS) $(OBJECTS) $(IULIB) -o $@
	@rm -f $*.o $*.c

iconstraints.o	: iconstraints.ec iconstraints.h
