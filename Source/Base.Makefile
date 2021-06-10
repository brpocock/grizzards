# Building for one TV standard at a time: Define this with make
# TV=PAL or edit the Makefile.

TV=NTSC
# TV=PAL
# TV=SECAM

all:	game doc

dist:	Dist/Grizzards.${TV}.zip

Dist/Grizzards.${TV}.zip: \
	Dist/Grizzards.${TV}.a26 \
	Dist/Grizzards.${TV}.pdf
	zip $@ $<

game:	Dist/Grizzards.${TV}.a26

doc:	Dist/Grizzards.${TV}.pdf

.PRECIOUS: %.s %.png %.a26 %.txt

Dist/Grizzards.${TV}.a26:	\
	$(shell bin/banks Object ${TV}.o)
	mkdir -p Dist/
	cat $^ > $@

Dist/Grizzards.${TV}.pdf: Object/Grizzards.tex
	-cd Object ; xelatex -interaction=batchmode "\def\TV${TV}{}\input{Grizzards}"
	-cd Object ; xelatex -interaction=batchmode "\def\TV${TV}{}\input{Grizzards}"
	-cd Object ; xelatex -interaction=batchmode "\def\TV${TV}{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/Grizzards.pdf Dist/Grizzards.${TV}.pdf

Object/Grizzards.tex: Manual/Grizzards.tex
	mkdir -p Object
	cp $< $@

YEAR=$(shell date +%Y)
YEAR2=$(shell date +%y)
MONTH=$(shell date +%m)
DATE=$(shell date +%d)
JULIAN=$(shell date +%j)
BUILD=$(shell date +%y.%j)
ASFLAGS= --nostart --long-branch --case-sensitive \
	--ascii -I Source/Common -I Source/Routines -I Source/Art -I Object/Art -I Object/Speech \
	-D YEARNOW=${YEAR} -D MONTHNOW=${MONTH} \
	-D DATENOW=${DATE} -D JULIANDATENOW=${JULIAN} \
	-D BUILD=${BUILD}
AS2600=${ASFLAGS} -I src/2600 -I obj/2600 --m6502

# If Make tries to second-guess us, let the default assembler be “error,”
# because the default assembler (probably GNU gas) almost certainly
# neither understands 65xx mnemonics nor 64tass macros and things.
AS=error

Dist/Grizzards.${TV}.sym:	\
	$(shell bin/banks Object ${TV}.labels.txt)
	cat $< > $@

stella:	Dist/Grizzards.${TV}.a26 Dist/Grizzards.${TV}.sym
	stella -tv.filter 0 -grabmouse 0 -bs F4 \
		-lc Joystick -rc AtariVox \
		-format ${TV} -pp Yes \
		-debug $<

COMMON=$(shell ls Source/Common/*.s)
ROUTINES=$(shell ls Source/Routines/*.s)

Object/%.${TV}.o:
	$(MAKE) $(shell echo $@ | sed -e s,${TV}.o,,)Makefile
	$(MAKE) -f $(shell echo $@ | sed -e s,${TV}.o,,)Makefile TV=${TV} bank


Object/%.Makefile:	$(shell ls Source/Banks/*/*.{s,txt,png}) \
	${COMMON} ${ROUTINES}
	mkdir -p Object
	bin/write-makefile $(shell echo $@ | sed -e s,Object/,, -e s,\.Makefile,,) > $@

# Object/Bank00.${TV}.o:	Source/Banks/Bank00.s \
# 		${COMMON} ${ROUTINES} \
# 		Object/Art/Title1.s \
# 		Object/Art/Title2.s \
# 		Object/Art/Title3.s \
# 		Source/Art/Font.s \
# 		Object/Speech/TitleSpeech.s
# 	mkdir -p Object
# 	64tass ${AS2600} -l $@.labels.txt -L $@.list.txt $< -o $@

Object/Bank01.${TV}.o:	Source/Banks/Bank01/Bank01.s \
		$(shell ls Source/Common/*.s) \
		Object/Speech/HapriSpeech.s
	mkdir -p Object
	64tass ${AS2600} -l $@.labels.txt -L $@.list.txt $< -o $@

Object/Bank02.${TV}.o:	Source/Banks/Bank02/Bank02.s \
		$(shell ls Source/Common/*.s) \
		Object/Speech/AlbronSpeech.s
	mkdir -p Object
	64tass ${AS2600} -l $@.labels.txt -L $@.list.txt $< -o $@

Object/Bank03.${TV}.o:	Source/Banks/Bank03/Bank03.s \
		$(shell ls Source/Common/*.s) \
		Object/Speech/PortiaSpeech.s
	mkdir -p Object
	64tass ${AS2600} -l $@.labels.txt -L $@.list.txt $< -o $@

Object/Bank04.${TV}.o:	Source/Banks/Bank04/Bank04.s \
		$(shell ls Source/Common/*.s)
	mkdir -p Object
	64tass ${AS2600} -l $@.labels.txt -L $@.list.txt $< -o $@

Object/Bank05.${TV}.o:	Source/Banks/Bank05/Bank05.s \
		$(shell ls Source/Common/*.s)
	mkdir -p Object
	64tass ${AS2600} -l $@.labels.txt -L $@.list.txt $< -o $@

Object/Bank06.${TV}.o:	Source/Banks/Bank06/Bank06.s \
		$(shell ls Source/Common/*.s)
	mkdir -p Object
	64tass ${AS2600} -l $@.labels.txt -L $@.list.txt $< -o $@

Object/Bank07.${TV}.o:	Source/Banks/Bank07/Bank07.s \
		$(shell ls Source/Common/*.s)
	mkdir -p Object
	64tass ${AS2600} -l $@.labels.txt -L $@.list.txt $< -o $@

Object/Art/%.s:	Source/Art/%.png bin/skyline-tool
	mkdir -p Object/Art
	bin/skyline-tool compile-art $@ $<

Object/Speech/%.s: Source/Speech/%.txt Source/Common/SpeakJet.dic bin/convert-to-speakjet
	mkdir -p Object/Speech
	bin/convert-to-speakjet $< Source/Common/SpeakJet.dic $@

quickclean:
	rm -rf Object Dist

clean:
	rm -fr Object Dist bin/buildapp bin/skyline-tool

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

