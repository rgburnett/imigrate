#
# Name 		: makefile - for irun 
#
# Synopsis	: make -f makefile 
#
# Arguments	: none
#
# Description	: irun is a replacement for dbaccess in the database build process
#		  it gives a detailed account of the line number and statement if
#		  an sql statement fails.
#
# See Also	: 
#
# Sccs 		: @(#)makefile	1.3 
#
# Continuus 
# Project	: %subsystem% %filespec%";



IULIB=../../lib/libdb.a
DESTDIR=../../dbtools
ESQL=esql
ESQLCFLAGS= -local -I../incl
CFLAGS= -O -I../incl

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


$(DESTDIR)/irun : irun.o $(IULIB)
	$(ESQL) $(ESQLCFLAGS) $(*F).o $(IULIB) -o $@
	@rm -f $*.o $*.c
	    
irun.o	: irun.ec
