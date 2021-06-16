default:	game doc

all:	dist

publish:	dist
	scp Dist/Grizzards.zip Dist/Grizzards.Source.tar.gz \
		star-hope.org:star-hope.org/games/Grizzards/

dist:	Dist/Grizzards.zip Dist/Grizzards.Source.tar.gz

Dist/Grizzards.Source.tar.gz:	game
	find Source Manual -name \*~ -exec rm {} \;
	tar zcf $@ Makefile README.md Source Manual

cart:	cart-ntsc

cart-ntsc:	Dist/Grizzards.NTSC.a26
	minipro -p AT27C256@DIP28 -w Dist/Grizzards.NTSC.a26

cart-pal:	Dist/Grizzards.PAL.a26
	minipro -p AT27C256@DIP28 -w Dist/Grizzards.PAL.a26

cart-secam:	Dist/Grizzards.SECAM.a26
	minipro -p AT27C256@DIP28 -w Dist/Grizzards.SECAM.a26

Dist/Grizzards.zip: \
	Dist/Grizzards.NTSC.a26 \
	Dist/Grizzards.NTSC.pdf \
	Dist/Grizzards.PAL.a26 \
	Dist/Grizzards.PAL.pdf \
	Dist/Grizzards.SECAM.a26 \
	Dist/Grizzards.SECAM.pdf
	zip $@ $^

game:	Dist/Grizzards.NTSC.a26

doc:	Dist/Grizzards.NTSC.pdf

.PRECIOUS: %.s %.png %.a26 %.txt

SOURCES=$(shell find Source -name \*.s -o -name \*.txt -o -name \*.png)

Dist/Grizzards.NTSC.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.NTSC.a26

Dist/Grizzards.PAL.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.PAL.a26

Dist/Grizzards.SECAM.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.SECAM.a26

Source/Generated/Makefile:	bin/write-master-makefile ${SOURCES}
	mkdir -p Source/Generated
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

stella:	Dist/Grizzards.NTSC.a26 Dist/Grizzards.NTSC.sym
	stella -tv.filter 3 -grabmouse 0 -bs F4 \
		-lc Joystick -rc AtariVox \
		-format NTSC -pp Yes \
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
		--entry skyline-tool::command

bin/buildapp:
	sbcl --load SkylineTool/prepare-system.lisp --eval '(cl-user::quit)'

