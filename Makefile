default:	game doc

all:	dist demo

publish:	dist demo
	scp Dist/Grizzards.Demo.NTSC.a26 Dist/Grizzards.Demo.PAL.a26 Dist/Grizzards.Demo.SECAM.a26 \
		Dist/Grizzards.Demo.zip Dist/Grizzards.Source.tar.gz \
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

harmony:	Dist/Grizzards.Demo.NTSC.a26 \
		Dist/Grizzards.Demo.PAL.a26 \
		Dist/Grizzards.Demo.SECAM.a26
	if [ $$(uname -s) = 'Linux' ] ; then \
	  cp Dist/*.a26 /run/media/${USER}/HARMONY/ ; \
	else \
	  echo "Patch Makefile for your $$(uname -s) OS" ; \
	fi

uno:	Dist/Grizzards.Demo.NTSC.a26 \
		Dist/Grizzards.Demo.PAL.a26 \
		Dist/Grizzards.Demo.SECAM.a26
	if [ $$(uname -s) = 'Linux' ] ; then \
	  cp Dist/*.a26 /run/media/${USER}/TBA_2600/ ; \
	else \
	  echo "Patch Makefile for your $$(uname -s) OS" ; \
	fi

Dist/Grizzards.zip: \
	Dist/Grizzards.NTSC.a26 \
	Dist/Grizzards.NTSC.pdf \
	Dist/Grizzards.PAL.a26 \
	Dist/Grizzards.PAL.pdf \
	Dist/Grizzards.SECAM.a26 \
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

game:	Dist/Grizzards.NTSC.a26

doc:	Dist/Grizzards.NTSC.pdf

.PRECIOUS: %.s %.png %.a26 %.txt %.zip %.tar.gz

SOURCES=$(shell find Source -name \*.s -o -name \*.txt -o -name \*.png -o -name \*.midi -a -not -name .\#\*)

Dist/Grizzards.NTSC.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.NTSC.a26

Dist/Grizzards.Demo.NTSC.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Demo.NTSC.a26

Dist/Grizzards.PAL.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.PAL.a26

Dist/Grizzards.Demo.PAL.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Demo.PAL.a26

Dist/Grizzards.SECAM.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.SECAM.a26

Dist/Grizzards.Demo.SECAM.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Demo.SECAM.a26

Source/Generated/Makefile:	bin/write-master-makefile ${SOURCES}
	mkdir -p Source/Generated
	bin/make-speakjet-enums
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

Dist/Grizzards.NTSC.sym:	\
	$(shell bin/banks Object NTSC.sym)
	cat $^ > $@

Dist/Grizzards.PAL.sym:	\
	$(shell bin/banks Object PAL.sym)
	cat $^ > $@

Dist/Grizzards.SECAM.sym:	\
	$(shell bin/banks Object SECAM.sym)
	cat $^ > $@

Dist/Grizzards.Demo.NTSC.sym:	\
	$(shell bin/banks Object Demo.NTSC.sym)
	cat $^ > $@

Dist/Grizzards.Demo.PAL.sym:	\
	$(shell bin/banks Object Demo.PAL.sym)
	cat $^ > $@

Dist/Grizzards.Demo.SECAM.sym:	\
	$(shell bin/banks Object Demo.SECAM.sym)
	cat $^ > $@

Dist/Grizzards.NTSC.pro:	Source/Grizzards.pro Dist/Grizzards.NTSC.a26
	sed $^ -e s/@@TV@@/NTSC/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.NTSC.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.PAL.pro:	Source/Grizzards.pro Dist/Grizzards.PAL.a26
	sed $^ -e s/@@TV@@/PAL/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.PAL.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.SECAM.pro:	Source/Grizzards.pro Dist/Grizzards.SECAM.a26
	sed $^ -e s/@@TV@@/SECAM/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.SECAM.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Demo.NTSC.pro:	Source/Grizzards.Demo.pro Dist/Grizzards.NTSC.a26
	sed $^ -e s/@@TV@@/NTSC/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.NTSC.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Demo.PAL.pro:	Source/Grizzards.Demo.pro Dist/Grizzards.PAL.a26
	sed $^ -e s/@@TV@@/PAL/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.PAL.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Demo.SECAM.pro:	Source/Grizzards.Demo.pro Dist/Grizzards.SECAM.a26
	sed $^ -e s/@@TV@@/SECAM/g \
		-e s/@@MD5@@/$(shell md5sum Dist/Grizzards.SECAM.a26 | cut -d\  -f1)/g > $@

stella:	Dist/Grizzards.Demo.NTSC.a26 Dist/Grizzards.Demo.NTSC.sym Dist/Grizzards.Demo.NTSC.pro
	stella -tv.filter 3 -grabmouse 0 -bs F4 \
		-lc Joystick -rc AtariVox \
		-format NTSC -pp Yes \
		-debug $<

stella-pal:	Dist/Grizzards.Demo.PAL.a26 Dist/Grizzards.Demo.PAL.sym Dist/Grizzards.Demo.PAL.pro
	stella -tv.filter 3 -grabmouse 0 -bs F4 \
		-lc Joystick -rc AtariVox \
		-format PAL -pp Yes \
		-debug $<

stella-secam:	Dist/Grizzards.Demo.SECAM.a26 Dist/Grizzards.Demo.SECAM.sym Dist/Grizzards.Demo.SECAM.pro
	stella -tv.filter 3 -grabmouse 0 -bs F4 \
		-lc Joystick -rc AtariVox \
		-format SECAM -pp Yes \
		-debug $<

quickclean:
	rm -rf Object Dist

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

