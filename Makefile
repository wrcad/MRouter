# Top-level Makefile for MRouter package.
# $Id: Makefile,v 1.24 2017/02/16 00:10:43 stevew Exp $

SUBDIRS = def lef mrouter

all: lef def
	cd def; $(MAKE)
	cd lef; $(MAKE)
	cd mrouter; $(MAKE) depend; $(MAKE)

lef:
	tar xzf source.lefdef/lef*tar.Z
	patch -p0 < source.lefdef/lef.patch

def:
	tar xzf source.lefdef/def*tar.Z
	patch -p0 < source.lefdef/def.patch

clean:
	-@for a in $(SUBDIRS); do \
	    (dir=`pwd`; cd $$a; $(MAKE) clean; cd $$dir) \
	done
	-cd examples; $(MAKE) clean

distclean:
	-@rm -rf lef def autom4te.cache config.status config.log
	-@rm -f mrouter-`./version`.tar.gz
	-cd mrouter; $(MAKE) distclean
	-cd examples; $(MAKE) distclean

depend:
	cd mrouter; $(MAKE) depend
	cd examples; $(MAKE) depend

test:
	-cd mrouter; $(MAKE) test

INSTALL_PREFIX = /usr/local
destn = $(INSTALL_PREFIX)/mrouter

install:
	rm -rf $(destn)
	mkdir $(destn)
	mkdir $(destn)/bin
	if [ -f mrouter/mrouter.exe ]; then \
            cp -f mrouter/mrouter.exe             $(destn)/bin; \
	else \
	    cp -f mrouter/mrouter                 $(destn)/bin; \
	fi
	mkdir $(destn)/doc $(destn)/doc/xic
	cp -f doc/mrmanual-`./version`.pdf     	  $(destn)/doc
	cp -f doc/mrmanual-html-`./version`.tar.gz $(destn)/doc
#	cp -f doc/Makefile                        $(destn)/doc
#	cp -f doc/mrman1.tex                      $(destn)/doc
#	cp -f doc/mrman2.tex                      $(destn)/doc
#	cp -f doc/mrman3.tex                      $(destn)/doc
#	cp -f doc/mrmanual.sed                    $(destn)/doc
	cp -f doc/README                          $(destn)/doc
#	cp -f doc/README.build                    $(destn)/doc
#	cp -f doc/tm.eps                          $(destn)/doc
	cp -f doc/xic/MRouter.hlp                 $(destn)/doc/xic
	mkdir $(destn)/examples
	cp -f examples/Makefile                   $(destn)/examples
	cp -f examples/main-plg.cc                $(destn)/examples
	cp -f examples/map9v3.def                 $(destn)/examples
	cp -f examples/map9v3_blk.def             $(destn)/examples
	cp -f examples/map9v3.rsc                 $(destn)/examples
	cp -f examples/openMSP430.def             $(destn)/examples
	cp -f examples/openMSP430_blk.def         $(destn)/examples
	cp -f examples/openMSP430.rsc             $(destn)/examples
	cp -f examples/README                     $(destn)/examples
	mkdir $(destn)/examples/osu35
	cp -f examples/osu35/osu035_stdcells.gds2 $(destn)/examples/osu35
	cp -f examples/osu35/osu035_stdcells.lef  $(destn)/examples/osu35
	mkdir $(destn)/examples/xic
	cp -f examples/xic/exroute.scr            $(destn)/examples/xic
	cp -f examples/xic/osu35.lib              $(destn)/examples/xic
	cp -f examples/xic/README                 $(destn)/examples/xic
	cp -f examples/xic/stdvia.scr             $(destn)/examples/xic
	cp -f examples/xic/stdvias                $(destn)/examples/xic
	cp -f examples/xic/xic_tech               $(destn)/examples/xic
	mkdir $(destn)/include
	cp -f include/ld_util.h include/ld_vers.h include/lddb.h \
          include/mr_vers.h include/mrouter.h     $(destn)/include
	mkdir $(destn)/lib
	cp -f mrouter/libmrouter.*                $(destn)/lib

uninstall:
	rm -rf $(destn)

tag:
	@vrs=`./version`; \
	tag=`IFS=.; set $$vrs; echo mrouter-$$1-$$2-$$3`; \
	echo $$tag; \
	cvs rtag -F $$tag mrouter

distrib:
	rm -rf dtmp;
	mkdir dtmp;
	@vrs=`./version`; \
	tag=`IFS=.; set $$vrs; echo mrouter-$$1-$$2-$$3`; \
	cd dtmp; cvs export -r $$tag  mrouter
	cp doc/mrmanual-`./version`.pdf \
  doc/mrmanual-html-`./version`.tar.gz dtmp/mrouter/doc
	cd dtmp; mv -f mrouter mrouter-`../version`; \
  tar czf mrouter-`../version`.tar.gz mrouter-`../version`;
	mv dtmp/mrouter-`./version`.tar.gz .; rm -rf dtmp


