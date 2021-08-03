default:	game demo

all:	dist demo

unerase:	Dist/Grizzards.Unerase.NTSC.a26 \
		Dist/Grizzards.Unerase.PAL.a26 \
		Dist/Grizzards.Unerase.SECAM.a26

publish:	dist demo doc unerase
	scp Dist/Grizzards.Demo.NTSC.a26 Dist/Grizzards.Demo.PAL.a26 Dist/Grizzards.Demo.SECAM.a26 \
		Dist/Grizzards.Demo.zip Dist/Grizzards.Source.tar.gz \
		Dist/Grizzards.Demo.NTSC.pdf Dist/Grizzards.Demo.PAL.pdf Dist/Grizzards.Demo.SECAM.pdf \
		Dist/Grizzards.Unerase.NTSC.a26 \
		Dist/Grizzards.Unerase.PAL.a26 \
		Dist/Grizzards.Unerase.SECAM.a26 \
		star-hope.org:star-hope.org/games/Grizzards/

demo:	Dist/Grizzards.Demo.zip

dist:	Dist/Grizzards.zip Dist/Grizzards.Source.tar.gz

Dist/Grizzards.Source.tar.gz:	game
	find Source Manual -name \*~ -exec rm {} \;
	tar zcf $@ Makefile README.md Source Manual

cart:	cart-ntsc

cart-ntsc:	Dist/Grizzards.Demo.NTSC.a26
	minipro -p AT27C256@DIP28 -w $<

cart-pal:	Dist/Grizzards.Demo.PAL.a26
	minipro -p AT27C256@DIP28 -w $<

cart-secam:	Dist/Grizzards.Demo.SECAM.a26
	minipro -p AT27C256@DIP28 -w $<

# Basic Harmony cart only can handle 32k images
HARMONY=/run/media/${USER}/HARMONY/
harmony:	Dist/Grizzards.Demo.NTSC.a26 \
		Dist/Grizzards.Demo.PAL.a26 \
		Dist/Grizzards.Demo.SECAM.a26
	if [ $$(uname -s) = 'Linux' ] ; then \
	  cp -v Dist/Grizzards.Demo.NTSC.a26 $(HARMONY)/Grizzards.D.NTSC.F4 ;\
	  cp -v Dist/Grizzards.Demo.PAL.a26 $(HARMONY)/Grizzards.D.PAL.F4 ;\
	  cp -v Dist/Grizzards.Demo.SECAM.a26 $(HARMONY)/Grizzards.D.SECAM.F4 ;\
	else \
	  echo "Patch Makefile for your $$(uname -s) OS" ; \
	fi

# Uno needs special extension to detect  us as an EF cartridge and shows
# fairyl short names only
UNOCART=/run/media/${USER}/TBA_2600/
uno:	Dist/Grizzards.Dirtex.NTSC.a26 \
	Dist/Grizzards.Dirtex.PAL.a26 \
	Dist/Grizzards.Dirtex.SECAM.a26 \
	Dist/Grizzards.Aquax.NTSC.a26 \
	Dist/Grizzards.Aquax.PAL.a26 \
	Dist/Grizzards.Aquax.SECAM.a26 \
	Dist/Grizzards.Airex.NTSC.a26 \
	Dist/Grizzards.Airex.PAL.a26 \
	Dist/Grizzards.Airex.SECAM.a26 \
	Dist/Grizzards.Demo.NTSC.a26 \
	Dist/Grizzards.Demo.PAL.a26 \
	Dist/Grizzards.Demo.SECAM.a26
	if [ $$(uname -s) = 'Linux' ] ; then \
	  cp -v Dist/Grizzards.Dirtex.NTSC.a26 $(UNOCART)/GRIZ.0.NTSC.EF ;\
	  cp -v Dist/Grizzards.Dirtex.PAL.a26 $(UNOCART)/GRIZ.0.PAL.EF ;\
	  cp -v Dist/Grizzards.Dirtex.SECAM.a26 $(UNOCART)/GRIZ.0.SECAM.EF ;\
	  cp -v Dist/Grizzards.Aquax.NTSC.a26 $(UNOCART)/GRIZ.1.NTSC.EF ;\
	  cp -v Dist/Grizzards.Aquax.PAL.a26 $(UNOCART)/GRIZ.1.PAL.EF ;\
	  cp -v Dist/Grizzards.Aquax.SECAM.a26 $(UNOCART)/GRIZ.1.SECAM.EF ;\
	  cp -v Dist/Grizzards.Airex.NTSC.a26 $(UNOCART)/GRIZ.2.NTSC.EF ;\
	  cp -v Dist/Grizzards.Airex.PAL.a26 $(UNOCART)/GRIZ.2.PAL.EF ;\
	  cp -v Dist/Grizzards.Airex.SECAM.a26 $(UNOCART)/GRIZ.2.SECAM.EF ;\
	  cp -v Dist/Grizzards.Demo.NTSC.a26 $(UNOCART)/GRIZ.D.NTSC.F4 ;\
	  cp -v Dist/Grizzards.Demo.PAL.a26 $(UNOCART)/GRIZ.D.PAL.F4 ;\
	  cp -v Dist/Grizzards.Demo.SECAM.a26 $(UNOCART)/GRIZ.D.SECAM.F4 ;\
	else \
	  echo "Patch Makefile for your $$(uname -s) OS" ; \
	fi

Dist/Grizzards.zip: \
	Dist/Grizzards.Dirtex.NTSC.a26 \
	Dist/Grizzards.Dirtex.PAL.a26 \
	Dist/Grizzards.Dirtex.SECAM.a26 \
	Dist/Grizzards.Aquax.NTSC.a26 \
	Dist/Grizzards.Aquax.PAL.a26 \
	Dist/Grizzards.Aquax.SECAM.a26 \
	Dist/Grizzards.Airex.NTSC.a26 \
	Dist/Grizzards.Airex.PAL.a26 \
	Dist/Grizzards.Airex.SECAM.a26 \
	Dist/Grizzards.NTSC.pdf \
	Dist/Grizzards.PAL.pdf \
	Dist/Grizzards.SECAM.pdf
	zip $@ $^

Dist/Grizzards.Demo.zip: \
	Dist/Grizzards.Demo.NTSC.a26 \
	Dist/Grizzards.Demo.NTSC.pdf \
	Dist/Grizzards.Demo.PAL.a26 \
	Dist/Grizzards.Demo.PAL.pdf \
	Dist/Grizzards.Demo.SECAM.a26 \
	Dist/Grizzards.Demo.SECAM.pdf
	zip $@ $^

game:	Dist/Grizzards.Dirtex.NTSC.a26 Dist/Grizzards.Dirtex.PAL.a26 Dist/Grizzards.Dirtex.SECAM.a26 \
	Dist/Grizzards.Aquax.NTSC.a26 Dist/Grizzards.Aquax.PAL.a26 Dist/Grizzards.Aquax.SECAM.a26 \
	Dist/Grizzards.Airex.NTSC.a26 Dist/Grizzards.Airex.PAL.a26 Dist/Grizzards.Airex.SECAM.a26 \
	Dist/Grizzards.NTSC.pdf Dist/Grizzards.PAL.pdf Dist/Grizzards.SECAM.pdf

doc:	Dist/Grizzards.NTSC.pdf Dist/Grizzards.PAL.pdf Dist/Grizzards.SECAM.pdf \
	Dist/Grizzards.Demo.NTSC.pdf Dist/Grizzards.Demo.PAL.pdf Dist/Grizzards.Demo.SECAM.pdf

.PRECIOUS: %.s %.png %.a26 %.txt %.zip %.tar.gz

SOURCES=$(shell find Source -name \*.s -o -name \*.txt -o -name \*.png -o -name \*.midi -a -not -name .\#\*)

Dist/Grizzards.Demo.NTSC.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Demo.NTSC.a26

Dist/Grizzards.Demo.PAL.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Demo.PAL.a26

Dist/Grizzards.Demo.SECAM.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Demo.SECAM.a26

Dist/Grizzards.Dirtex.NTSC.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Dirtex.NTSC.a26

Dist/Grizzards.Dirtex.PAL.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Dirtex.PAL.a26

Dist/Grizzards.Dirtex.SECAM.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Dirtex.SECAM.a26

Dist/Grizzards.Aquax.NTSC.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Aquax.NTSC.a26

Dist/Grizzards.Aquax.PAL.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Aquax.PAL.a26

Dist/Grizzards.Aquax.SECAM.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Aquax.SECAM.a26

Dist/Grizzards.Airex.NTSC.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Airex.NTSC.a26

Dist/Grizzards.Airex.PAL.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Airex.PAL.a26

Dist/Grizzards.Airex.SECAM.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Airex.SECAM.a26

Source/Generated/Makefile:	bin/write-master-makefile ${SOURCES}
	mkdir -p Source/Generated
	for bank in 5 7 8 9 a b c d e f; do bin/make-speakjet-enums $$bank; done
	$< > Source/Generated/Makefile

Dist/Grizzards.NTSC.pdf: Object/Grizzards.tex
	-cd Object ; xelatex -interaction=batchmode "\def\TVNTSC{}\input{Grizzards}"
	-cd Object ; xelatex -interaction=batchmode "\def\TVNTSC{}\input{Grizzards}"
	-cd Object ; xelatex -interaction=batchmode "\def\TVNTSC{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/Grizzards.pdf Dist/Grizzards.NTSC.pdf

Dist/Grizzards.PAL.pdf: Object/Grizzards.tex
	-cd Object ; xelatex -interaction=batchmode "\def\TVPAL{}\input{Grizzards}"
	-cd Object ; xelatex -interaction=batchmode "\def\TVPAL{}\input{Grizzards}"
	-cd Object ; xelatex -interaction=batchmode "\def\TVPAL{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/Grizzards.pdf Dist/Grizzards.PAL.pdf

Dist/Grizzards.SECAM.pdf: Object/Grizzards.tex
	-cd Object ; xelatex -interaction=batchmode "\def\TVSECAM{}\input{Grizzards}"
	-cd Object ; xelatex -interaction=batchmode "\def\TVSECAM{}\input{Grizzards}"
	-cd Object ; xelatex -interaction=batchmode "\def\TVSECAM{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/Grizzards.pdf Dist/Grizzards.SECAM.pdf

Dist/Grizzards.Demo.NTSC.pdf: Object/Grizzards.tex
	-cd Object ; xelatex -interaction=batchmode "\def\DEMO{}\def\TVNTSC{}\input{Grizzards}"
	-cd Object ; xelatex -interaction=batchmode "\def\DEMO{}\def\TVNTSC{}\input{Grizzards}"
	-cd Object ; xelatex -interaction=batchmode "\def\DEMO{}\def\TVNTSC{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/Grizzards.pdf Dist/Grizzards.Demo.NTSC.pdf

Dist/Grizzards.Demo.PAL.pdf: Object/Grizzards.tex
	-cd Object ; xelatex -interaction=batchmode "\def\DEMO{}\def\TVPAL{}\input{Grizzards}"
	-cd Object ; xelatex -interaction=batchmode "\def\DEMO{}\def\TVPAL{}\input{Grizzards}"
	-cd Object ; xelatex -interaction=batchmode "\def\DEMO{}\def\TVPAL{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/Grizzards.pdf Dist/Grizzards.Demo.PAL.pdf

Dist/Grizzards.Demo.SECAM.pdf: Object/Grizzards.tex
	-cd Object ; xelatex -interaction=batchmode "\def\DEMO{}\def\TVSECAM{}\input{Grizzards}"
	-cd Object ; xelatex -interaction=batchmode "\def\DEMO{}\def\TVSECAM{}\input{Grizzards}"
	-cd Object ; xelatex -interaction=batchmode "\def\DEMO{}\def\TVSECAM{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/Grizzards.pdf Dist/Grizzards.Demo.SECAM.pdf

Object/Grizzards.tex: Manual/Grizzards.tex
	mkdir -p Object
	cp $< $@

# If Make tries to second-guess us, let the default assembler be “error,”
# because the default assembler (probably GNU gas) almost certainly
# neither understands 65xx mnemonics nor 64tass macros and things.
AS=error

Dist/Grizzards.Demo.NTSC.sym:	\
	$(shell bin/banks Object Demo.NTSC.sym)
	cat $^ > $@

Dist/Grizzards.Demo.PAL.sym:	\
	$(shell bin/banks Object Demo.PAL.sym)
	cat $^ > $@

Dist/Grizzards.Demo.SECAM.sym:	\
	$(shell bin/banks Object Demo.SECAM.sym)
	cat $^ > $@


Dist/Grizzards.Dirtex.NTSC.sym:	\
	$(shell bin/banks Object Dirtex.NTSC.sym)
	cat $^ > $@

Dist/Grizzards.Dirtex.PAL.sym:	\
	$(shell bin/banks Object Dirtex.PAL.sym)
	cat $^ > $@

Dist/Grizzards.Dirtex.SECAM.sym:	\
	$(shell bin/banks Object Dirtex.SECAM.sym)
	cat $^ > $@


Dist/Grizzards.Aquax.NTSC.sym:	\
	$(shell bin/banks Object Aquax.NTSC.sym)
	cat $^ > $@

Dist/Grizzards.Aquax.PAL.sym:	\
	$(shell bin/banks Object Aquax.PAL.sym)
	cat $^ > $@

Dist/Grizzards.Aquax.SECAM.sym:	\
	$(shell bin/banks Object Aquax.SECAM.sym)
	cat $^ > $@


Dist/Grizzards.Airex.NTSC.sym:	\
	$(shell bin/banks Object Airex.NTSC.sym)
	cat $^ > $@

Dist/Grizzards.Airex.PAL.sym:	\
	$(shell bin/banks Object Airex.PAL.sym)
	cat $^ > $@

Dist/Grizzards.Airex.SECAM.sym:	\
	$(shell bin/banks Object Airex.SECAM.sym)
	cat $^ > $@

Dist/Grizzards.Demo.NTSC.pro:	Source/Grizzards.Demo.pro Dist/Grizzards.Demo.NTSC.a26
	sed $^ -e s/@@TV@@/NTSC/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.NTSC.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Demo.PAL.pro:	Source/Grizzards.Demo.pro Dist/Grizzards.Demo.PAL.a26
	sed $^ -e s/@@TV@@/PAL/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.PAL.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Demo.SECAM.pro:	Source/Grizzards.Demo.pro Dist/Grizzards.Demo.SECAM.a26
	sed $^ -e s/@@TV@@/SECAM/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.SECAM.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Dirtex.NTSC.pro:	Source/Grizzards.pro Dist/Grizzards.Dirtex.NTSC.a26
	sed $^ -e s/@@TV@@/NTSC/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.Dirtex.NTSC.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Dirtex.PAL.pro:	Source/Grizzards.pro Dist/Grizzards.Dirtex.PAL.a26
	sed $^ -e s/@@TV@@/PAL/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.Dirtex.PAL.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Dirtex.SECAM.pro:	Source/Grizzards.pro Dist/Grizzards.Dirtex.SECAM.a26
	sed $^ -e s/@@TV@@/SECAM/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.Dirtex.SECAM.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Aquax.NTSC.pro:	Source/Grizzards.pro Dist/Grizzards.Aquax.NTSC.a26
	sed $^ -e s/@@TV@@/NTSC/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.Aquax.NTSC.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Aquax.PAL.pro:	Source/Grizzards.pro Dist/Grizzards.Aquax.PAL.a26
	sed $^ -e s/@@TV@@/PAL/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.Aquax.PAL.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Aquax.SECAM.pro:	Source/Grizzards.pro Dist/Grizzards.Aquax.SECAM.a26
	sed $^ -e s/@@TV@@/SECAM/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.Aquax.SECAM.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Airex.NTSC.pro:	Source/Grizzards.pro Dist/Grizzards.Airex.NTSC.a26
	sed $^ -e s/@@TV@@/NTSC/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.Airex.NTSC.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Airex.PAL.pro:	Source/Grizzards.pro Dist/Grizzards.Airex.PAL.a26
	sed $^ -e s/@@TV@@/PAL/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.Airex.PAL.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Airex.SECAM.pro:	Source/Grizzards.pro Dist/Grizzards.Airex.SECAM.a26
	sed $^ -e s/@@TV@@/SECAM/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.Airex.SECAM.a26 | cut -d\  -f1)/g > $@

dstella:	Dist/Grizzards.Demo.NTSC.a26 Dist/Grizzards.Demo.NTSC.sym Dist/Grizzards.Demo.NTSC.pro
	stella -tv.filter 3 -grabmouse 0 -bs F4 \
		-lc Genesis -rc AtariVox \
		-format NTSC -pp Yes \
		-debug $<

dstella-pal:	Dist/Grizzards.Demo.PAL.a26 Dist/Grizzards.Demo.PAL.sym Dist/Grizzards.Demo.PAL.pro
	stella -tv.filter 3 -grabmouse 0 -bs F4 \
		-lc Genesis -rc AtariVox \
		-format PAL -pp Yes \
		-debug $<

dstella-secam:	Dist/Grizzards.Demo.SECAM.a26 Dist/Grizzards.Demo.SECAM.sym Dist/Grizzards.Demo.SECAM.pro
	stella -tv.filter 3 -grabmouse 0 -bs F4 \
		-lc Genesis -rc AtariVox \
		-format SECAM -pp Yes \
		-debug $<

stella:	Dist/Grizzards.Aquax.NTSC.a26 Dist/Grizzards.Aquax.NTSC.sym Dist/Grizzards.Aquax.NTSC.pro
	stella -tv.filter 3 -grabmouse 0 -bs EF \
		-lc Genesis -rc AtariVox \
		-format NTSC -pp Yes \
		-debug $<

stella-pal:	Dist/Grizzards.Aquax.PAL.a26 Dist/Grizzards.Aquax.PAL.sym Dist/Grizzards.Aquax.PAL.pro
	stella -tv.filter 3 -grabmouse 0 -bs EF \
		-lc Genesis -rc AtariVox \
		-format PAL -pp Yes \
		-debug $<

stella-secam:	Dist/Grizzards.Aquax.SECAM.a26 Dist/Grizzards.Aquax.SECAM.sym Dist/Grizzards.Aquax.SECAM.pro
	stella -tv.filter 3 -grabmouse 0 -bs EF \
		-lc Genesis -rc AtariVox \
		-format SECAM -pp Yes \
		-debug $<

quickclean:
	rm -rf Object Dist Source/Generated

clean:
	rm -fr Object Dist Source/Generated bin/buildapp bin/skyline-tool

bin/skyline-tool:	bin/buildapp \
	$(shell ls SkylineTool/*.lisp SkylineTool/src/*.lisp SkylineTool/skyline-tool.asd)
	mkdir -p bin
	@echo "Note: This may take a while if you don't have some common Quicklisp \
libraries already compiled. On subsequent runs, though, it'll be much quicker." >&2
	bin/buildapp --output bin/skyline-tool \
		--load SkylineTool/setup.lisp \
		--load-system skyline-tool \
		--entry skyline-tool::command

bin/buildapp:
	sbcl --load SkylineTool/prepare-system.lisp --eval '(cl-user::quit)'


Dist/Grizzards.Unerase.NTSC.a26:	$(shell find Source -name \*.s)
	64tass --nostart --long-branch --case-sensitive \
	--ascii -I. -I Source/Common -I Source/Routines \
	-Wall -Wno-shadow -Wno-leading-zeros --m6502 \
	Source/Unerase/Unerase.s -DTV=NTSC -o $@

Dist/Grizzards.Unerase.PAL.a26:	$(shell find Source -name \*.s)
	64tass --nostart --long-branch --case-sensitive \
	--ascii -I. -I Source/Common -I Source/Routines \
	-Wall -Wno-shadow -Wno-leading-zeros --m6502 \
	Source/Unerase/Unerase.s -DTV=PAL -o $@

Dist/Grizzards.Unerase.SECAM.a26:	$(shell find Source -name \*.s)
	64tass --nostart --long-branch --case-sensitive \
	--ascii -I. -I Source/Common -I Source/Routines \
	-Wall -Wno-shadow -Wno-leading-zeros --m6502 \
	Source/Unerase/Unerase.s -DTV=SECAM -o $@
