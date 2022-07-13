default:	game doc

all:	game demo no-save doc atariage

atariage:	Dist/Grizzards.AtariAge.zip

publish:	demo game no-save doc Dist/Grizzards.Source.tar.gz Dist/Grizzards.AtariAge.zip \
		Dist/Grizzards.Portable.NTSC.bin
	@until rsync -essh --progress \
		Dist/Grizzards.Demo.NTSC.a26 Dist/Grizzards.Demo.PAL.a26 Dist/Grizzards.Demo.SECAM.a26 \
		Dist/Grizzards.Demo.zip Dist/Grizzards.Source.tar.gz \
		Dist/Grizzards.Demo.pdf \
		Dist/Grizzards.NoSave.NTSC.a26 Dist/Grizzards.NoSave.PAL.a26 Dist/Grizzards.NoSave.SECAM.a26 \
		Dist/Grizzards.NoSave.pdf \
		Dist/Grizzards.Portable.NTSC.bin \
		Dist/Grizzards.NTSC.a26 Dist/Grizzards.PAL.a26 Dist/Grizzards.SECAM.a26 \
		Dist/Grizzards.pdf \
		Dist/Grizzards.zip \
		Dist/Grizzards.AtariAge.zip \
		star-hope.org:star-hope.org/games/Grizzards/ ; \
	do sleep 1; done

plustest:	Dist/Grizzards.NTSC.a26
	@echo -e 'put Dist/Grizzards.NTSC.a26 Grizzards.Test.NTSC.EF' | \
	cadaver https://plusstore.firmaplus.de/remote.php/dav/files/$(USER)/Grizzards

plus:	Dist/Grizzards.NTSC.a26 \
	Dist/Grizzards.PAL.a26 \
	Dist/Grizzards.SECAM.a26 \
	Dist/Grizzards.Demo.NTSC.a26 \
	Dist/Grizzards.Demo.PAL.a26 \
	Dist/Grizzards.Demo.SECAM.a26 \
	Dist/Grizzards.NoSave.NTSC.a26 \
	Dist/Grizzards.NoSave.PAL.a26 \
	Dist/Grizzards.NoSave.SECAM.a26 \
	Dist/Grizzards.Manual.txt

	@echo -e 'put Dist/Grizzards.NTSC.a26 Grizzards.NTSC.EF\nput Dist/Grizzards.PAL.a26 Grizzards.PAL.EF\nput Dist/Grizzards.SECAM.a26 Grizzards.SECAM.EF\nput Dist/Grizzards.Demo.NTSC.a26 Grizzards.Demo.NTSC.F4\nput Dist/Grizzards.Demo.PAL.a26 Grizzards.Demo.PAL.F4\nput Dist/Grizzards.Demo.SECAM.a26 Grizzards.Demo.SECAM.F4\nput Dist/Grizzards.NoSave.NTSC.a26 Grizzards.NoSave.NTSC.F4\nput Dist/Grizzards.NoSave.PAL.a26 Grizzards.NoSave.PAL.F4\nput Dist/Grizzards.NoSave.SECAM.a26 Grizzards.NoSave.SECAM.F4\nput Dist/Grizzards.Manual.txt Grizzards.Manual.txt' | \
	cadaver https://plusstore.firmaplus.de/remote.php/dav/files/$(USER)/Grizzards

demo:	Dist/Grizzards.Demo.zip

no-save:	Dist/Grizzards.NoSave.zip

Dist/Grizzards.Source.tar.gz:	game
	find Source Manual -name \*~ -exec rm {} \;
	tar zcf $@ Makefile README.md Guts.txt Source Manual

cart:	Dist/Grizzards.AA.NTSC.a26
	minipro -p AT27C512@DIP32 -w $<


USBMOUNT=$(shell echo \"$$(mount | grep /run/media/$$USER | grep vfat | head -n 1 | \
		perl -pne 's#^/dev/.+ on (.+) type vfat (.*)#$$1#g')\")

USBDEV=$(shell grep "$(USBMOUNT)" /etc/mtab | cut -d ' ' -f 1)

# Basic Harmony cart only can handle 32k images
harmony:	Dist/Grizzards.Demo.NTSC.a26 \
		Dist/Grizzards.NoSave.NTSC.a26
	[ "$(USBMOUNT)" != "" ]
	@if [ $$(uname -s) = 'Linux' ] ; then \
	  mkdir -p $(USBMOUNT)/Grizzards ;\
	  cp -v Dist/Grizzards.Demo.NTSC.a26 $(USBMOUNT)/Grizzards/Grizzards.Demo.F4 ;\
	  cp -v Dist/Grizzards.NoSave.NTSC.a26 $(USBMOUNT)/Grizzards/Grizzards.NoSave.F4 ;\
	else \
	  echo "Patch Makefile for your $$(uname -s) OS" ; \
	fi

encore:	Dist/Grizzards.Demo.NTSC.a26 \
	Dist/Grizzards.NoSave.NTSC.a26 \
	Dist/Grizzards.NTSC.a26
	[ "$(USBMOUNT)" != "" ]
	@if [ $$(uname -s) = 'Linux' ] ; then \
	  mkdir -p $(USBMOUNT)/Grizzards ;\
	  cp -v Dist/Grizzards.Demo.NTSC.a26 $(USBMOUNT)/Grizzards/Grizzards.Demo.F4 ;\
	  cp -v Dist/Grizzards.NoSave.NTSC.a26 $(USBMOUNT)/Grizzards/Grizzards.NoSave.F4 ;\
	  cp -v Dist/Grizzards.NTSC.a26 $(USBMOUNT)/Grizzards/Grizzards.EF ;\
	else \
	  echo "Patch Makefile for your $$(uname -s) OS" ; \
	fi

# Uno needs special extension to detect  us as an EF cartridge and shows
# fairly short names only
uno:	Dist/Grizzards.NTSC.a26 \
	Dist/Grizzards.Demo.NTSC.a26 \
	Dist/Grizzards.NoSave.NTSC.a26
	[ "$(USBMOUNT)" != "" ]
	@if [ $$(uname -s) = 'Linux' ] ; then \
	  mkdir -p $(USBMOUNT)/GRIZZARDS/ ;\
	  cp -v Dist/Grizzards.NTSC.a26 $(USBMOUNT)/GRIZZARDS/GRIZZARDS.NTSC.EF ;\
	  cp -v Dist/Grizzards.Demo.NTSC.a26 $(USBMOUNT)/GRIZZARDS/DEMO.NTSC.F4 ;\
	  cp -v Dist/Grizzards.NoSave.NTSC.a26 $(USBMOUNT)/GRIZZARDS/NOSAVE.NTSC.F4 ;\
	else \
	  echo "Patch Makefile for your $$(uname -s) OS" ; \
	fi

portbin:	Dist/Grizzards.Portable.NTSC.bin

portable:	Dist/Grizzards.Portable.NTSC.bin
	[ "$(USBMOUNT)" != "" ]
	if [ $$(uname -s) = 'Linux' ] ; then \
	  mkdir -p $(USBMOUNT)/Game ;\
	  cp -v Dist/Grizzards.Portable.NTSC.bin $(USBMOUNT)/Game/'Grizzards demo     '.bin ;\
            sync $(USBMOUNT) ;\
            umount $(USBMOUNT) ;\
            sudo fatsort -o d -n $(USBDEV) ;\
            sync ;\
	else \
	  echo "Patch Makefile for your $$(uname -s) OS" ; \
	fi

Dist/Grizzards.AtariAge.zip:	\
	Dist/Grizzards.AA.NTSC.a26 Dist/Grizzards.AA.PAL.a26 Dist/Grizzards.AA.SECAM.a26 \
	Dist/Grizzards.AA.NTSC.pro Dist/Grizzards.AA.PAL.pro Dist/Grizzards.AA.SECAM.pro \
	Dist/Grizzards.AA-book.pdf \
	Package/Box.svg Package/EndLabel.png Package/FrontLabel.png
	@echo "AtariAge daily build of Grizzards for the Atari 2600. © 2021-2022 Bruce-Robert Pocock." | \
		zip  --archive-comment -9 "$@" $^

Dist/Grizzards.zip:	\
	Dist/Grizzards.NTSC.a26 Dist/Grizzards.PAL.a26 Dist/Grizzards.SECAM.a26 \
	Dist/Grizzards.pdf \
	Dist/Grizzards.NTSC.pro Dist/Grizzards.PAL.pro Dist/Grizzards.SECAM.pro
	@echo "Daily build of Grizzards for the Atari 2600. © 2021-2022 Bruce-Robert Pocock." | \
		zip  --archive-comment -9 "$@" $^

Dist/Grizzards.Demo.zip: \
	Dist/Grizzards.Demo.NTSC.a26 \
	Dist/Grizzards.Demo.PAL.a26 \
	Dist/Grizzards.Demo.SECAM.a26 \
	Dist/Grizzards.Demo.NTSC.pro \
	Dist/Grizzards.Demo.PAL.pro \
	Dist/Grizzards.Demo.SECAM.pro \
	Dist/Grizzards.Demo.pdf
	@echo "Daily build of Grizzards demo for the Atari 2600. © 2021-2022 Bruce-Robert Pocock." | \
		zip  --archive-comment -9 "$@" $^

Dist/Grizzards.NoSave.zip: \
	Dist/Grizzards.NoSave.NTSC.a26 \
	Dist/Grizzards.NoSave.pdf \
	Dist/Grizzards.NoSave.NTSC.pro \
	Dist/Grizzards.NoSave.PAL.a26 \
	Dist/Grizzards.NoSave.PAL.pro \
	Dist/Grizzards.NoSave.SECAM.a26 \
	Dist/Grizzards.NoSave.SECAM.pro
	@echo "Daily build of Grizzards no-save demo for the Atari 2600. © 2021-2022 Bruce-Robert Pocock." | \
		zip  --archive-comment -9 "$@" $^

game:	Dist/Grizzards.zip

doc:	Dist/Grizzards.pdf \
	Dist/Grizzards.AA-book.pdf \
	Dist/Grizzards.Demo.pdf \
	Dist/Grizzards.Manual.txt \
	Dist/Grizzards.NoSave.pdf \
	Dist/GrizzardsCompleteGuide.pdf

.PRECIOUS: %.s %.png %.a26 %.txt %.zip %.tar.gz

SOURCES=$(shell find Source -name \*.s -o -name \*.txt -o -name \*.png -o -name \*.midi \
		-a -not -name .\#\*)

Dist/Grizzards.Manual.txt:	Manual/Manual.txt
	cp Manual/Manual.txt Dist/Grizzards.Manual.txt

Dist/Grizzards.Portable.NTSC.bin:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Portable.NTSC.bin

Dist/Grizzards.Demo.NTSC.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Demo.NTSC.a26

Dist/Grizzards.Demo.PAL.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Demo.PAL.a26

Dist/Grizzards.Demo.SECAM.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.Demo.SECAM.a26

Dist/Grizzards.NoSave.NTSC.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.NoSave.NTSC.a26

Dist/Grizzards.NoSave.PAL.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.NoSave.PAL.a26

Dist/Grizzards.NoSave.SECAM.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.NoSave.SECAM.a26

Dist/Grizzards.NTSC.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.NTSC.a26

Dist/Grizzards.PAL.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.PAL.a26

Dist/Grizzards.SECAM.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.SECAM.a26

Dist/Grizzards.AA.NTSC.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.AA.NTSC.a26

Dist/Grizzards.AA.PAL.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.AA.PAL.a26

Dist/Grizzards.AA.SECAM.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.AA.SECAM.a26


Source/Generated/Makefile:	bin/write-master-makefile ${SOURCES}
	mkdir -p Source/Generated
	for bank in 5 7 8 9 a b c; do bin/make-speakjet-enums $$bank; done
	$< > Source/Generated/Makefile

Dist/Grizzards.AA-book.pdf:	Dist/Grizzards.AA.pdf
	pdfbook2 --paper=legalpaper -o 0 -i 0 -t 0 -b 0 $<

Dist/GrizzardsCompleteGuide.pdf: Manual/GrizzardsCompleteGuide.tex
	mkdir -p Object/Complete.pdf
	cp $< Object/Complete.pdf/
	ln -sf ../Manual Object/
	-cd Object/Complete.pdf ; xelatex -interaction=batchmode "\input{GrizzardsCompleteGuide}"
	-cd Object/Complete.pdf ; xelatex -interaction=batchmode "\input{GrizzardsCompleteGuide}"
	-cd Object/Complete.pdf ; xelatex -interaction=batchmode "\input{GrizzardsCompleteGuide}"
	mkdir -p Dist
	mv Object/Complete.pdf/GrizzardsCompleteGuide.pdf Dist/GrizzardsCompleteGuide.pdf

Dist/Grizzards.pdf: Manual/Grizzards.tex
	mkdir -p Object/Grizzards.pdf
	cp $< Object/Grizzards.pdf/
	ln -sf ../Manual Object/
	-cd Object/Grizzards.pdf ; xelatex -interaction=batchmode "\input{Grizzards}"
	-cd Object/Grizzards.pdf ; xelatex -interaction=batchmode "\input{Grizzards}"
	-cd Object/Grizzards.pdf ; xelatex -interaction=batchmode "\input{Grizzards}"
	mkdir -p Dist
	mv Object/Grizzards.pdf/Grizzards.pdf Dist/Grizzards.pdf

Dist/Grizzards.AA.pdf: Manual/Grizzards.tex
	mkdir -p Object/AA.pdf
	cp $< Object/AA.pdf/
	ln -sf ../Manual Object/
	-cd Object/AA.pdf ; xelatex -interaction=batchmode "\def\ATARIAGESAVE{}\input{Grizzards}"
	-cd Object/AA.pdf ; xelatex -interaction=batchmode "\def\ATARIAGESAVE{}\input{Grizzards}"
	-cd Object/AA.pdf ; xelatex -interaction=batchmode "\def\ATARIAGESAVE{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/AA.pdf/Grizzards.pdf Dist/Grizzards.AA.pdf

Dist/Grizzards.Demo.pdf: Manual/Grizzards.tex
	mkdir -p Object/Demo.pdf
	cp $< Object/Demo.pdf/
	ln -sf ../Manual Object/
	-cd Object/Demo.pdf ; xelatex -interaction=batchmode "\def\DEMO{}\input{Grizzards}"
	-cd Object/Demo.pdf ; xelatex -interaction=batchmode "\def\DEMO{}\input{Grizzards}"
	-cd Object/Demo.pdf ; xelatex -interaction=batchmode "\def\DEMO{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/Demo.pdf/Grizzards.pdf Dist/Grizzards.Demo.pdf

Dist/Grizzards.NoSave.pdf: Manual/Grizzards.tex
	mkdir -p Object/NoSave.pdf
	cp $< Object/NoSave.pdf/
	ln -sf ../Manual Object/
	-cd Object/NoSave.pdf ; xelatex -interaction=batchmode "\def\DEMO{}\def\NOSAVE{}\input{Grizzards}"
	-cd Object/NoSave.pdf ; xelatex -interaction=batchmode "\def\DEMO{}\def\NOSAVE{}\input{Grizzards}"
	-cd Object/NoSave.pdf ; xelatex -interaction=batchmode "\def\DEMO{}\def\NOSAVE{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/NoSave.pdf/Grizzards.pdf Dist/Grizzards.NoSave.pdf

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

Dist/Grizzards.NoSave.NTSC.sym:	\
	$(shell bin/banks Object NoSave.NTSC.sym)
	cat $^ > $@

Dist/Grizzards.NoSave.PAL.sym:	\
	$(shell bin/banks Object NoSave.PAL.sym)
	cat $^ > $@

Dist/Grizzards.NoSave.SECAM.sym:	\
	$(shell bin/banks Object NoSave.SECAM.sym)
	cat $^ > $@


Dist/Grizzards.NTSC.sym:	\
	$(shell bin/banks Object NTSC.sym)
	cat $^ > $@

Dist/Grizzards.PAL.sym:	\
	$(shell bin/banks Object PAL.sym)
	cat $^ > $@

Dist/Grizzards.SECAM.sym:	\
	$(shell bin/banks Object SECAM.sym)
	cat $^ > $@


Dist/Grizzards.Demo.NTSC.lst:	\
	$(shell bin/banks Object Demo.NTSC.lst)
	cat $^ > $@

Dist/Grizzards.Demo.PAL.lst:	\
	$(shell bin/banks Object Demo.PAL.lst)
	cat $^ > $@

Dist/Grizzards.Demo.SECAM.lst:	\
	$(shell bin/banks Object Demo.SECAM.lst)
	cat $^ > $@

Dist/Grizzards.NoSave.NTSC.lst:	\
	$(shell bin/banks Object NoSave.NTSC.lst)
	cat $^ > $@

Dist/Grizzards.NoSave.PAL.lst:	\
	$(shell bin/banks Object NoSave.PAL.lst)
	cat $^ > $@

Dist/Grizzards.NoSave.SECAM.lst:	\
	$(shell bin/banks Object NoSave.SECAM.lst)
	cat $^ > $@


Dist/Grizzards.NTSC.lst:	\
	$(shell bin/banks Object NTSC.lst)
	cat $^ > $@

Dist/Grizzards.PAL.lst:	\
	$(shell bin/banks Object PAL.lst)
	cat $^ > $@

Dist/Grizzards.SECAM.lst:	\
	$(shell bin/banks Object SECAM.lst)
	cat $^ > $@


Dist/Grizzards.Demo.NTSC.pro:	Source/Grizzards.Demo.pro Dist/Grizzards.Demo.NTSC.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/NTSC/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.Demo.NTSC.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Demo.PAL.pro:	Source/Grizzards.Demo.pro Dist/Grizzards.Demo.PAL.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/PAL/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.Demo.PAL.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Demo.SECAM.pro:	Source/Grizzards.Demo.pro Dist/Grizzards.Demo.SECAM.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/SECAM/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.Demo.SECAM.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.NoSave.NTSC.pro:	Source/Grizzards.NoSave.pro Dist/Grizzards.NoSave.NTSC.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/NTSC/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.NoSave.NTSC.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.NoSave.PAL.pro:	Source/Grizzards.NoSave.pro Dist/Grizzards.NoSave.PAL.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/PAL/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.NoSave.PAL.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.NoSave.SECAM.pro:	Source/Grizzards.NoSave.pro Dist/Grizzards.NoSave.SECAM.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/SECAM/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.NoSave.SECAM.a26 | cut -d\  -f1)/g > $@


Dist/Grizzards.NTSC.pro:	Source/Grizzards.pro Dist/Grizzards.NTSC.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/NTSC/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.NTSC.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.PAL.pro:	Source/Grizzards.pro Dist/Grizzards.PAL.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/PAL/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.PAL.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.SECAM.pro:	Source/Grizzards.pro Dist/Grizzards.SECAM.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/SECAM/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.SECAM.a26 | cut -d\  -f1)/g > $@


Dist/Grizzards.AA.NTSC.pro:	Source/Grizzards.pro Dist/Grizzards.AA.NTSC.a26
	sed $< -e s/@@ATARIAGESAVE@@/1/ -e s/@@TV@@/NTSC/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.AA.NTSC.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.AA.PAL.pro:	Source/Grizzards.pro Dist/Grizzards.AA.PAL.a26
	sed $< -e s/@@ATARIAGESAVE@@/1/ -e s/@@TV@@/PAL/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.AA.PAL.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.AA.SECAM.pro:	Source/Grizzards.pro Dist/Grizzards.AA.SECAM.a26
	sed $< -e s/@@ATARIAGESAVE@@/1/ -e s/@@TV@@/SECAM/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.AA.SECAM.a26 | cut -d\  -f1)/g > $@


dstella:	Dist/Grizzards.Demo.NTSC.a26 Dist/Grizzards.Demo.NTSC.lst \
	Dist/Grizzards.Demo.NTSC.sym Dist/Grizzards.Demo.NTSC.pro
	stella -tv.filter 3 -grabmouse 0 -bs F4 \
		-lc Genesis -rc AtariVox \
		-format NTSC -pp Yes \
		-debug $<

dstella-pal:	Dist/Grizzards.Demo.PAL.a26 Dist/Grizzards.Demo.PAL.lst \
	Dist/Grizzards.Demo.PAL.sym Dist/Grizzards.Demo.PAL.pro
	stella -tv.filter 3 -grabmouse 0 -bs F4 \
		-lc Genesis -rc AtariVox \
		-format PAL -pp Yes \
		-debug $<

dstella-secam:	Dist/Grizzards.Demo.SECAM.a26 Dist/Grizzards.Demo.SECAM.lst \
	Dist/Grizzards.Demo.SECAM.sym Dist/Grizzards.Demo.SECAM.pro
	stella -tv.filter 3 -grabmouse 0 -bs F4 \
		-lc Genesis -rc AtariVox \
		-format SECAM -pp Yes \
		-debug $<

nstella:	Dist/Grizzards.NoSave.NTSC.a26 Dist/Grizzards.NoSave.NTSC.lst \
	Dist/Grizzards.NoSave.NTSC.sym Dist/Grizzards.NoSave.NTSC.pro
	stella -tv.filter 3 -grabmouse 0 -bs F4 \
		-lc Genesis -rc Joystick \
		-format NTSC -pp Yes \
		-debug $<

nstella-pal:	Dist/Grizzards.NoSave.PAL.a26 Dist/Grizzards.NoSave.PAL.lst \
	Dist/Grizzards.NoSave.PAL.sym Dist/Grizzards.NoSave.PAL.pro
	stella -tv.filter 3 -grabmouse 0 -bs F4 \
		-lc Genesis -rc Joystick \
		-format PAL -pp Yes \
		-debug $<

nstella-secam:	Dist/Grizzards.NoSave.SECAM.a26 Dist/Grizzards.NoSave.SECAM.lst \
	Dist/Grizzards.NoSave.SECAM.sym Dist/Grizzards.NoSave.SECAM.pro
	stella -tv.filter 3 -grabmouse 0 -bs F4 \
		-lc Genesis -rc Joystick \
		-format SECAM -pp Yes \
		-debug $<

stella:	Dist/Grizzards.NTSC.a26 Dist/Grizzards.NTSC.lst \
	Dist/Grizzards.NTSC.sym Dist/Grizzards.NTSC.pro
	stella -tv.filter 3 -grabmouse 0 -bs EF \
		-lc Genesis -rc AtariVox \
		-format NTSC -pp Yes \
		-debug $<

stella-pal:	Dist/Grizzards.PAL.a26 Dist/Grizzards.PAL.lst \
	Dist/Grizzards.PAL.sym Dist/Grizzards.PAL.pro
	stella -tv.filter 3 -grabmouse 0 -bs EF \
		-lc Genesis -rc AtariVox \
		-format PAL -pp Yes \
		-debug $<

stella-secam:	Dist/Grizzards.SECAM.a26 Dist/Grizzards.SECAM.lst \
	Dist/Grizzards.SECAM.sym Dist/Grizzards.SECAM.pro
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


RELEASE=noreleasenamegiven
release:	all
	@if [ $(RELEASE) = noreleasenamegiven ]; then echo "Usage: make RELEASE=ident release" >&2; exit 1; fi
	mkdir -p Dist/$(RELEASE)
	-rm Dist/$(RELEASE)/*
	-cp -v Dist/GrizzardsCompleteGuide.pdf Dist/$(RELEASE)
	-cp -v Dist/Grizzards.{AA.,Demo.,NoSave.,}{NTSC,PAL,SECAM}.{a26,pro} \
		Dist/$(RELEASE)
	cp -v Dist/Grizzards.Portable.NTSC.bin Dist/$(RELEASE)/Grizzards.Portable.$(RELEASE).bin
	cp -v Dist/Grizzards.{AA-book.,AA.,Demo.,NoSave.}pdf Dist/$(RELEASE)
	cp -v Dist/Grizzards.Manual.txt Dist/$(RELEASE)
	@cd Dist/$(RELEASE) ; \
	for file in Grizzards.*.{pro,a26,pdf} Grizzards.pdf; do \
		mv -v $$file $$(echo $$file | perl -pne 's(Grizzards(\..+)\.(pdf|a26|pro)) (Grizzards\1.$(RELEASE).\2)'); \
	done
	@echo "AtariAge Release $(RELEASE) of Grizzards for the Atari 2600. © 2021-2022 Bruce-Robert Pocock." | \
		(cd Dist; zip --archive-comment -9 \
		$(RELEASE)/Grizzards.AtariAge.$(RELEASE).zip \
		$(RELEASE)/Grizzards.AA.$(RELEASE).{a26,pdf,pro} \
		$(RELEASE)/Grizzards.AA-book.$(RELEASE).pdf )
	@echo "Public Release $(RELEASE) of Grizzards for the Atari 2600. © 2021-2022 Bruce-Robert Pocock." | \
		(cd Dist; zip --archive-comment -9 \
		$(RELEASE)/Grizzards.$(RELEASE).zip \
		$(RELEASE)/Grizzards.{NTSC,PAL,SECAM}.$(RELEASE).{a26,pro} \
		$(RELEASE)/Grizzards.$(RELEASE).pdf )
	@echo "Demo Release $(RELEASE) of Grizzards for the Atari 2600. © 2021-2022 Bruce-Robert Pocock." | \
		(cd Dist; zip --archive-comment -9 \
		$(RELEASE)/Grizzards.Demo.$(RELEASE).zip \
		$(RELEASE)/Grizzards.Demo.{NTSC,PAL,SECAM}.$(RELEASE).{a26,pro} \
		$(RELEASE)/Grizzards.Demo.$(RELEASE).pdf )
	@echo "No-Save Demo Release $(RELEASE) of Grizzards for the Atari 2600. © 2021-2022 Bruce-Robert Pocock." | \
		(cd Dist; zip --archive-comment -9 \
		$(RELEASE)/Grizzards.NoSave.$(RELEASE).zip \
		$(RELEASE)/Grizzards.NoSave.{NTSC,PAL,SECAM}.$(RELEASE).{a26,pro} \
		$(RELEASE)/Grizzards.NoSave.$(RELEASE).pdf )

publish-release:	release
	until rsync -essh -v Dist/$(RELEASE)/*$(RELEASE)* \
		star-hope.org:star-hope.org/games/Grizzards ; do \
		sleep 1 ; done
	rsync -essh -rv Dist/$(RELEASE) Krishna.local:Projects/Grizzards/Dist/
