default:	game unerase doc

all:	game demo no-save unerase doc atariage

unerase:	Dist/Grizzards.Unerase.zip

atariage:	Dist/Grizzards.AtariAge.zip

publish:	demo game no-save doc unerase Dist/Grizzards.Source.tar.gz Dist/Grizzards.AtariAge.zip
	@until rsync -essh --progress \
		Dist/Grizzards.Demo.NTSC.a26 Dist/Grizzards.Demo.PAL.a26 Dist/Grizzards.Demo.SECAM.a26 \
		Dist/Grizzards.Demo.zip Dist/Grizzards.Source.tar.gz \
		Dist/Grizzards.Demo.NTSC.pdf Dist/Grizzards.Demo.PAL.pdf Dist/Grizzards.Demo.SECAM.pdf \
		Dist/Grizzards.NoSave.NTSC.a26 Dist/Grizzards.NoSave.PAL.a26 Dist/Grizzards.NoSave.SECAM.a26 \
		Dist/Grizzards.NoSave.NTSC.pdf Dist/Grizzards.NoSave.PAL.pdf Dist/Grizzards.NoSave.SECAM.pdf \
		Dist/Grizzards.Dirtex.NTSC.a26 Dist/Grizzards.Dirtex.PAL.a26 Dist/Grizzards.Dirtex.SECAM.a26 \
		Dist/Grizzards.Aquax.NTSC.a26 Dist/Grizzards.Aquax.PAL.a26 Dist/Grizzards.Aquax.SECAM.a26 \
		Dist/Grizzards.Airex.NTSC.a26 Dist/Grizzards.Airex.PAL.a26 Dist/Grizzards.Airex.SECAM.a26 \
		Dist/Grizzards.NTSC.pdf Dist/Grizzards.PAL.pdf Dist/Grizzards.SECAM.pdf \
		Dist/Grizzards.Unerase.NTSC.a26 \
		Dist/Grizzards.Unerase.PAL.a26 \
		Dist/Grizzards.Unerase.SECAM.a26 \
		Dist/Grizzards.AtariAge.zip \
		star-hope.org:star-hope.org/games/Grizzards/ ; \
	do sleep 1; done

plus:	Dist/Grizzards.Aquax.NTSC.a26 \
	Dist/Grizzards.Aquax.PAL.a26 \
	Dist/Grizzards.Aquax.SECAM.a26 \
	Dist/Grizzards.Dirtex.NTSC.a26 \
	Dist/Grizzards.Dirtex.PAL.a26 \
	Dist/Grizzards.Dirtex.SECAM.a26 \
	Dist/Grizzards.Airex.NTSC.a26 \
	Dist/Grizzards.Airex.PAL.a26 \
	Dist/Grizzards.Airex.SECAM.a26 \
	Dist/Grizzards.Demo.NTSC.a26 \
	Dist/Grizzards.Demo.PAL.a26 \
	Dist/Grizzards.Demo.SECAM.a26 \
	Dist/Grizzards.NoSave.NTSC.a26 \
	Dist/Grizzards.NoSave.PAL.a26 \
	Dist/Grizzards.NoSave.SECAM.a26 \
	Dist/Grizzards.Unerase.NTSC.a26 \
	Dist/Grizzards.Unerase.PAL.a26 \
	Dist/Grizzards.Unerase.SECAM.a26 \
	Dist/Grizzards.Manual.txt

	@echo -e 'put Dist/Grizzards.Aquax.NTSC.a26 Grizzards.Aquax.NTSC.EF\nput Dist/Grizzards.Aquax.PAL.a26 Grizzards.Aquax.PAL.EF\nput Dist/Grizzards.Aquax.SECAM.a26 Grizzards.Aquax.SECAM.EF\nput Dist/Grizzards.Airex.NTSC.a26 Grizzards.Airex.NTSC.EF\nput Dist/Grizzards.Airex.PAL.a26 Grizzards.Airex.PAL.EF\nput Dist/Grizzards.Airex.SECAM.a26 Grizzards.Airex.SECAM.EF\nput Dist/Grizzards.Dirtex.NTSC.a26 Grizzards.Dirtex.NTSC.EF\nput Dist/Grizzards.Dirtex.PAL.a26 Grizzards.Dirtex.PAL.EF\nput Dist/Grizzards.Dirtex.SECAM.a26 Grizzards.Dirtex.SECAM.EF\nput Dist/Grizzards.Demo.NTSC.a26 Grizzards.Demo.NTSC.F4\nput Dist/Grizzards.Demo.PAL.a26 Grizzards.Demo.PAL.F4\nput Dist/Grizzards.Demo.SECAM.a26 Grizzards.Demo.SECAM.F4\nput Dist/Grizzards.NoSave.NTSC.a26 Grizzards.NoSave.NTSC.F4\nput Dist/Grizzards.NoSave.PAL.a26 Grizzards.NoSave.PAL.F4\nput Dist/Grizzards.NoSave.SECAM.a26 Grizzards.NoSave.SECAM.F4\nput Dist/Grizzards.Unerase.NTSC.a26 Grizzards.Unerase.NTSC.a26\nput Dist/Grizzards.Unerase.PAL.a26 Grizzards.Unerase.PAL.a26\nput Dist/Grizzards.Unerase.SECAM.a26 Grizzards.Unerase.SECAM.a26\nput Dist/Grizzards.Manual.txt Grizzards.Manual.txt' | \
	cadaver https://plusstore.firmaplus.de/remote.php/dav/files/$(USER)/Grizzards

demo:	Dist/Grizzards.Demo.zip

no-save:	Dist/Grizzards.NoSave.zip

Dist/Grizzards.Source.tar.gz:	game
	find Source Manual -name \*~ -exec rm {} \;
	tar zcf $@ Makefile README.md Source Manual

cart:	cart-aquax

cart-aquax:	Dist/Grizzards.AA.Aquax.NTSC.a26
	minipro -p AT27C512@DIP32 -w $<

cart-airex:	Dist/Grizzards.AA.Airex.NTSC.a26
	minipro -p AT27C512@DIP32 -w $<

cart-dirtex:	Dist/Grizzards.AA.Dirtex.NTSC.a26
	minipro -p AT27C512@DIP32 -w $<


USBMOUNT=$(shell echo \"$$(mount | grep /run/media/$$USER | grep vfat | head -n 1 | perl -pne 's#^/dev/.+ on (.+) type vfat (.*)#$$1#g')\")


# Basic Harmony cart only can handle 32k images
harmony:	Dist/Grizzards.Demo.NTSC.a26 \
		Dist/Grizzards.NoSave.NTSC.a26
	[ "$(USBMOUNT)" != "" ]
	@if [ $$(uname -s) = 'Linux' ] ; then \
	  mkdir $(USBMOUNT)/Grizzards ;\
	  cp -v Dist/Grizzards.Demo.NTSC.a26 $(USBMOUNT)/Grizzards/Grizzards.Demo.F4 ;\
	  cp -v Dist/Grizzards.NoSave.NTSC.a26 $(USBMOUNT)/Grizzards/Grizzards.NoSave.F4 ;\
	else \
	  echo "Patch Makefile for your $$(uname -s) OS" ; \
	fi

encore:	Dist/Grizzards.Demo.NTSC.a26 \
	Dist/Grizzards.NoSave.NTSC.a26 \
	Dist/Grizzards.Airex.NTSC.a26 \
	Dist/Grizzards.Dirtex.NTSC.a26 \
	Dist/Grizzards.Aquax.NTSC.a26
	[ "$(USBMOUNT)" != "" ]
	@if [ $$(uname -s) = 'Linux' ] ; then \
	  mkdir $(USBMOUNT)/Grizzards ;\
	  cp -v Dist/Grizzards.Demo.NTSC.a26 $(USBMOUNT)/Grizzards/Grizzards.Demo.F4 ;\
	  cp -v Dist/Grizzards.NoSave.NTSC.a26 $(USBMOUNT)/Grizzards/Grizzards.NoSave.F4 ;\
	  cp -v Dist/Grizzards.Airex.NTSC.a26 $(USBMOUNT)/Grizzards/Grizzards.Airex.EF ;\
	  cp -v Dist/Grizzards.Dirtex.NTSC.a26 $(USBMOUNT)/Grizzards/Grizzards.Dirtex.EF ;\
	  cp -v Dist/Grizzards.Aquax.NTSC.a26 $(USBMOUNT)/Grizzards/Grizzards.Aquax.EF ;\
	else \
	  echo "Patch Makefile for your $$(uname -s) OS" ; \
	fi

# Uno needs special extension to detect  us as an EF cartridge and shows
# fairly short names only
uno:	Dist/Grizzards.Dirtex.NTSC.a26 \
	Dist/Grizzards.Aquax.NTSC.a26 \
	Dist/Grizzards.Airex.NTSC.a26 \
	Dist/Grizzards.Demo.NTSC.a26 \
	Dist/Grizzards.NoSave.NTSC.a26 \
	Dist/Grizzards.Unerase.NTSC.a26
	[ "$(USBMOUNT)" != "" ]
	@if [ $$(uname -s) = 'Linux' ] ; then \
	  mkdir -p $(USBMOUNT)/GRIZZARDS/ ;\
	  cp -v Dist/Grizzards.Dirtex.NTSC.a26 $(USBMOUNT)/GRIZZARDS/DIRTEX.NTSC.EF ;\
	  cp -v Dist/Grizzards.Aquax.NTSC.a26 $(USBMOUNT)/GRIZZARDS/AQUAX.NTSC.EF ;\
	  cp -v Dist/Grizzards.Airex.NTSC.a26 $(USBMOUNT)/GRIZZARDS/AIREX.NTSC.EF ;\
	  cp -v Dist/Grizzards.Demo.NTSC.a26 $(USBMOUNT)/GRIZZARDS/DEMO.NTSC.F4 ;\
	  cp -v Dist/Grizzards.NoSave.NTSC.a26 $(USBMOUNT)/GRIZZARDS/NOSAVE.NTSC.F4 ;\
	  cp -v Dist/Grizzards.Unerase.NTSC.a26 $(USBMOUNT)/GRIZZARDS/UNERASE.NTSC.F4 ;\
	else \
	  echo "Patch Makefile for your $$(uname -s) OS" ; \
	fi

Dist/Grizzards.AtariAge.zip:	\
	Dist/Grizzards.AA.Dirtex.NTSC.a26 Dist/Grizzards.AA.Dirtex.PAL.a26 Dist/Grizzards.AA.Dirtex.SECAM.a26 \
	Dist/Grizzards.AA.Aquax.NTSC.a26 Dist/Grizzards.AA.Aquax.PAL.a26 Dist/Grizzards.AA.Aquax.SECAM.a26 \
	Dist/Grizzards.AA.Airex.NTSC.a26 Dist/Grizzards.AA.Airex.PAL.a26 Dist/Grizzards.AA.Airex.SECAM.a26 \
	Dist/Grizzards.AA.Dirtex.NTSC.pro Dist/Grizzards.AA.Dirtex.PAL.pro Dist/Grizzards.AA.Dirtex.SECAM.pro \
	Dist/Grizzards.AA.Aquax.NTSC.pro Dist/Grizzards.AA.Aquax.PAL.pro Dist/Grizzards.AA.Aquax.SECAM.pro \
	Dist/Grizzards.AA.Airex.NTSC.pro Dist/Grizzards.AA.Airex.PAL.pro Dist/Grizzards.AA.Airex.SECAM.pro \
	Dist/Grizzards.AA.NTSC-book.pdf Dist/Grizzards.AA.PAL-book.pdf Dist/Grizzards.AA.SECAM-book.pdf \
	Package/Box.svg Package/EndLabel.png Package/FrontLabel.png
	zip "$@" $^

Dist/Grizzards.zip:	\
	Dist/Grizzards.Dirtex.NTSC.a26 Dist/Grizzards.Dirtex.PAL.a26 Dist/Grizzards.Dirtex.SECAM.a26 \
	Dist/Grizzards.Aquax.NTSC.a26 Dist/Grizzards.Aquax.PAL.a26 Dist/Grizzards.Aquax.SECAM.a26 \
	Dist/Grizzards.Airex.NTSC.a26 Dist/Grizzards.Airex.PAL.a26 Dist/Grizzards.Airex.SECAM.a26 \
	Dist/Grizzards.Dirtex.NTSC.pro Dist/Grizzards.Dirtex.PAL.pro Dist/Grizzards.Dirtex.SECAM.pro \
	Dist/Grizzards.Aquax.NTSC.pro Dist/Grizzards.Aquax.PAL.pro Dist/Grizzards.Aquax.SECAM.pro \
	Dist/Grizzards.Airex.NTSC.pro Dist/Grizzards.Airex.PAL.pro Dist/Grizzards.Airex.SECAM.pro
	zip "$@" $^

Dist/Grizzards.Unerase.zip: Dist/Grizzards.Unerase.NTSC.a26 \
		Dist/Grizzards.Unerase.PAL.a26 \
		Dist/Grizzards.Unerase.SECAM.a26
	zip $@ $^

Dist/Grizzards.Demo.zip: \
	Dist/Grizzards.Demo.NTSC.a26 \
	Dist/Grizzards.Demo.PAL.a26 \
	Dist/Grizzards.Demo.SECAM.a26 \
	Dist/Grizzards.Demo.NTSC.pro \
	Dist/Grizzards.Demo.PAL.pro \
	Dist/Grizzards.Demo.SECAM.pro \
	Dist/Grizzards.Demo.NTSC.pdf \
	Dist/Grizzards.Demo.PAL.pdf \
	Dist/Grizzards.Demo.SECAM.pdf
	zip $@ $^

Dist/Grizzards.NoSave.zip: \
	Dist/Grizzards.NoSave.NTSC.a26 \
	Dist/Grizzards.NoSave.NTSC.pdf \
	Dist/Grizzards.NoSave.NTSC.pro \
	Dist/Grizzards.NoSave.PAL.a26 \
	Dist/Grizzards.NoSave.PAL.pdf \
	Dist/Grizzards.NoSave.PAL.pro \
	Dist/Grizzards.NoSave.SECAM.a26 \
	Dist/Grizzards.NoSave.SECAM.pdf \
	Dist/Grizzards.NoSave.SECAM.pro
	zip $@ $^

game:	Dist/Grizzards.zip

doc:	Dist/Grizzards.NTSC.pdf Dist/Grizzards.PAL.pdf Dist/Grizzards.SECAM.pdf \
	Dist/Grizzards.AA.NTSC-book.pdf Dist/Grizzards.AA.PAL-book.pdf Dist/Grizzards.AA.SECAM-book.pdf \
	Dist/Grizzards.Demo.NTSC.pdf Dist/Grizzards.Demo.PAL.pdf Dist/Grizzards.Demo.SECAM.pdf \
	Dist/Grizzards.Manual.txt \
	Dist/Grizzards.Unerase.pdf \
	Dist/Grizzards.NoSave.NTSC.pdf Dist/Grizzards.NoSave.PAL.pdf Dist/Grizzards.NoSave.SECAM.pdf

.PRECIOUS: %.s %.png %.a26 %.txt %.zip %.tar.gz

SOURCES=$(shell find Source -name \*.s -o -name \*.txt -o -name \*.png -o -name \*.midi -a -not -name .\#\*)

Dist/Grizzards.Manual.txt:	Manual/Manual.txt
	cp Manual/Manual.txt Dist/Grizzards.Manual.txt

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

Dist/Grizzards.AA.Dirtex.NTSC.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.AA.Dirtex.NTSC.a26

Dist/Grizzards.AA.Dirtex.PAL.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.AA.Dirtex.PAL.a26

Dist/Grizzards.AA.Dirtex.SECAM.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.AA.Dirtex.SECAM.a26

Dist/Grizzards.AA.Aquax.NTSC.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.AA.Aquax.NTSC.a26

Dist/Grizzards.AA.Aquax.PAL.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.AA.Aquax.PAL.a26

Dist/Grizzards.AA.Aquax.SECAM.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.AA.Aquax.SECAM.a26

Dist/Grizzards.AA.Airex.NTSC.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.AA.Airex.NTSC.a26

Dist/Grizzards.AA.Airex.PAL.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.AA.Airex.PAL.a26

Dist/Grizzards.AA.Airex.SECAM.a26:	${SOURCES} Source/Generated/Makefile bin/skyline-tool
	$(MAKE) -f Source/Generated/Makefile Dist/Grizzards.AA.Airex.SECAM.a26


Source/Generated/Makefile:	bin/write-master-makefile ${SOURCES}
	mkdir -p Source/Generated
	for bank in 5 7 8 9 a b c d e; do bin/make-speakjet-enums $$bank; done
	$< > Source/Generated/Makefile

Dist/Grizzards.AA.NTSC-book.pdf:	Dist/Grizzards.AA.NTSC.pdf
	pdfbook2 --paper=letterpaper -o 0 -i 0 -t 0 -b 0 $<

Dist/Grizzards.AA.PAL-book.pdf:	Dist/Grizzards.AA.PAL.pdf
	pdfbook2 --paper=letterpaper -o 0 -i 0 -t 0 -b 0 $<

Dist/Grizzards.AA.SECAM-book.pdf:	Dist/Grizzards.AA.SECAM.pdf
	pdfbook2 --paper=letterpaper -o 0 -i 0 -t 0 -b 0 $<

Dist/Grizzards.Unerase.pdf:	Manual/Unerase.tex
	mkdir -p Object/Unerase.pdf
	cp $< Object/Unerase.pdf/
	ln -sf ../Manual Object/
	-cd Object/Unerase.pdf ; xelatex -interaction=batchmode Unerase.tex
	-cd Object/Unerase.pdf ; xelatex -interaction=batchmode Unerase.tex
	-cd Object/Unerase.pdf ; xelatex -interaction=batchmode Unerase.tex
	mkdir -p Dist
	mv Object/Unerase.pdf/Unerase.pdf Dist/Grizzards.Unerase.pdf

Dist/Grizzards.NTSC.pdf: Manual/Grizzards.tex
	mkdir -p Object/NTSC.pdf
	cp $< Object/NTSC.pdf/
	ln -sf ../Manual Object/
	-cd Object/NTSC.pdf ; xelatex -interaction=batchmode "\def\TVNTSC{}\input{Grizzards}"
	-cd Object/NTSC.pdf ; xelatex -interaction=batchmode "\def\TVNTSC{}\input{Grizzards}"
	-cd Object/NTSC.pdf ; xelatex -interaction=batchmode "\def\TVNTSC{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/NTSC.pdf/Grizzards.pdf Dist/Grizzards.NTSC.pdf

Dist/Grizzards.PAL.pdf: Manual/Grizzards.tex
	mkdir -p Object/PAL.pdf
	cp $< Object/PAL.pdf/
	ln -sf ../Manual Object/
	-cd Object/PAL.pdf ; xelatex -interaction=batchmode "\def\TVPAL{}\input{Grizzards}"
	-cd Object/PAL.pdf ; xelatex -interaction=batchmode "\def\TVPAL{}\input{Grizzards}"
	-cd Object/PAL.pdf ; xelatex -interaction=batchmode "\def\TVPAL{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/PAL.pdf/Grizzards.pdf Dist/Grizzards.PAL.pdf

Dist/Grizzards.SECAM.pdf: Manual/Grizzards.tex
	mkdir -p Object/SECAM.pdf
	cp $< Object/SECAM.pdf/
	ln -sf ../Manual Object/
	-cd Object/SECAM.pdf ; xelatex -interaction=batchmode "\def\TVSECAM{}\input{Grizzards}"
	-cd Object/SECAM.pdf ; xelatex -interaction=batchmode "\def\TVSECAM{}\input{Grizzards}"
	-cd Object/SECAM.pdf ; xelatex -interaction=batchmode "\def\TVSECAM{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/SECAM.pdf/Grizzards.pdf Dist/Grizzards.SECAM.pdf

Dist/Grizzards.AA.NTSC.pdf: Manual/Grizzards.tex
	mkdir -p Object/AA.NTSC.pdf
	cp $< Object/AA.NTSC.pdf/
	ln -sf ../Manual Object/AA.
	-cd Object/AA.NTSC.pdf ; xelatex -interaction=batchmode "\def\TVNTSC{}\def\ATARIAGESAVE{}\input{Grizzards}"
	-cd Object/AA.NTSC.pdf ; xelatex -interaction=batchmode "\def\TVNTSC{}\def\ATARIAGESAVE{}\input{Grizzards}"
	-cd Object/AA.NTSC.pdf ; xelatex -interaction=batchmode "\def\TVNTSC{}\def\ATARIAGESAVE{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/AA.NTSC.pdf/Grizzards.pdf Dist/Grizzards.AA.NTSC.pdf

Dist/Grizzards.AA.PAL.pdf: Manual/Grizzards.tex
	mkdir -p Object/AA.PAL.pdf
	cp $< Object/AA.PAL.pdf/
	ln -sf ../Manual Object/AA.
	-cd Object/AA.PAL.pdf ; xelatex -interaction=batchmode "\def\TVPAL{}\def\ATARIAGESAVE{}\input{Grizzards}"
	-cd Object/AA.PAL.pdf ; xelatex -interaction=batchmode "\def\TVPAL{}\def\ATARIAGESAVE{}\input{Grizzards}"
	-cd Object/AA.PAL.pdf ; xelatex -interaction=batchmode "\def\TVPAL{}\def\ATARIAGESAVE{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/AA.PAL.pdf/Grizzards.pdf Dist/Grizzards.AA.PAL.pdf

Dist/Grizzards.AA.SECAM.pdf: Manual/Grizzards.tex
	mkdir -p Object/AA.SECAM.pdf
	cp $< Object/AA.SECAM.pdf/
	ln -sf ../Manual Object/AA.
	-cd Object/AA.SECAM.pdf ; xelatex -interaction=batchmode "\def\TVSECAM{}\def\ATARIAGESAVE{}\input{Grizzards}"
	-cd Object/AA.SECAM.pdf ; xelatex -interaction=batchmode "\def\TVSECAM{}\def\ATARIAGESAVE{}\input{Grizzards}"
	-cd Object/AA.SECAM.pdf ; xelatex -interaction=batchmode "\def\TVSECAM{}\def\ATARIAGESAVE{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/AA.SECAM.pdf/Grizzards.pdf Dist/Grizzards.AA.SECAM.pdf

Dist/Grizzards.Demo.NTSC.pdf: Manual/Grizzards.tex
	mkdir -p Object/Demo.NTSC.pdf
	cp $< Object/Demo.NTSC.pdf/
	ln -sf ../Manual Object/
	-cd Object/Demo.NTSC.pdf ; xelatex -interaction=batchmode "\def\TVNTSC{}\def\DEMO{}\input{Grizzards}"
	-cd Object/Demo.NTSC.pdf ; xelatex -interaction=batchmode "\def\TVNTSC{}\def\DEMO{}\input{Grizzards}"
	-cd Object/Demo.NTSC.pdf ; xelatex -interaction=batchmode "\def\TVNTSC{}\def\DEMO{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/Demo.NTSC.pdf/Grizzards.pdf Dist/Grizzards.Demo.NTSC.pdf

Dist/Grizzards.Demo.PAL.pdf: Manual/Grizzards.tex
	mkdir -p Object/Demo.PAL.pdf
	cp $< Object/Demo.PAL.pdf/
	ln -sf ../Manual Object/
	-cd Object/Demo.PAL.pdf ; xelatex -interaction=batchmode "\def\TVPAL{}\def\DEMO{}\input{Grizzards}"
	-cd Object/Demo.PAL.pdf ; xelatex -interaction=batchmode "\def\TVPAL{}\def\DEMO{}\input{Grizzards}"
	-cd Object/Demo.PAL.pdf ; xelatex -interaction=batchmode "\def\TVPAL{}\def\DEMO{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/Demo.PAL.pdf/Grizzards.pdf Dist/Grizzards.Demo.PAL.pdf

Dist/Grizzards.Demo.SECAM.pdf: Manual/Grizzards.tex
	mkdir -p Object/Demo.SECAM.pdf
	cp $< Object/Demo.SECAM.pdf/
	ln -sf ../Manual Object/
	-cd Object/Demo.SECAM.pdf ; xelatex -interaction=batchmode "\def\TVSECAM{}\def\DEMO{}\input{Grizzards}"
	-cd Object/Demo.SECAM.pdf ; xelatex -interaction=batchmode "\def\TVSECAM{}\def\DEMO{}\input{Grizzards}"
	-cd Object/Demo.SECAM.pdf ; xelatex -interaction=batchmode "\def\TVSECAM{}\def\DEMO{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/Demo.SECAM.pdf/Grizzards.pdf Dist/Grizzards.Demo.SECAM.pdf

Dist/Grizzards.NoSave.NTSC.pdf: Manual/Grizzards.tex
	mkdir -p Object/NoSave.NTSC.pdf
	cp $< Object/NoSave.NTSC.pdf/
	ln -sf ../Manual Object/
	-cd Object/NoSave.NTSC.pdf ; xelatex -interaction=batchmode "\def\TVNTSC{}\def\DEMO{}\def\NOSAVE{}\input{Grizzards}"
	-cd Object/NoSave.NTSC.pdf ; xelatex -interaction=batchmode "\def\TVNTSC{}\def\DEMO{}\def\NOSAVE{}\input{Grizzards}"
	-cd Object/NoSave.NTSC.pdf ; xelatex -interaction=batchmode "\def\TVNTSC{}\def\DEMO{}\def\NOSAVE{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/NoSave.NTSC.pdf/Grizzards.pdf Dist/Grizzards.NoSave.NTSC.pdf

Dist/Grizzards.NoSave.PAL.pdf: Manual/Grizzards.tex
	mkdir -p Object/NoSave.PAL.pdf
	cp $< Object/NoSave.PAL.pdf/
	ln -sf ../Manual Object/
	-cd Object/NoSave.PAL.pdf ; xelatex -interaction=batchmode "\def\TVPAL{}\def\DEMO{}\def\NOSAVE{}\input{Grizzards}"
	-cd Object/NoSave.PAL.pdf ; xelatex -interaction=batchmode "\def\TVPAL{}\def\DEMO{}\def\NOSAVE{}\input{Grizzards}"
	-cd Object/NoSave.PAL.pdf ; xelatex -interaction=batchmode "\def\TVPAL{}\def\DEMO{}\def\NOSAVE{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/NoSave.PAL.pdf/Grizzards.pdf Dist/Grizzards.NoSave.PAL.pdf

Dist/Grizzards.NoSave.SECAM.pdf: Manual/Grizzards.tex
	mkdir -p Object/NoSave.SECAM.pdf
	cp $< Object/NoSave.SECAM.pdf/
	ln -sf ../Manual Object/
	-cd Object/NoSave.SECAM.pdf ; xelatex -interaction=batchmode "\def\TVSECAM{}\def\DEMO{}\def\NOSAVE{}\input{Grizzards}"
	-cd Object/NoSave.SECAM.pdf ; xelatex -interaction=batchmode "\def\TVSECAM{}\def\DEMO{}\def\NOSAVE{}\input{Grizzards}"
	-cd Object/NoSave.SECAM.pdf ; xelatex -interaction=batchmode "\def\TVSECAM{}\def\DEMO{}\def\NOSAVE{}\input{Grizzards}"
	mkdir -p Dist
	mv Object/NoSave.SECAM.pdf/Grizzards.pdf Dist/Grizzards.NoSave.SECAM.pdf

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


Dist/Grizzards.Dirtex.NTSC.lst:	\
	$(shell bin/banks Object Dirtex.NTSC.lst)
	cat $^ > $@

Dist/Grizzards.Dirtex.PAL.lst:	\
	$(shell bin/banks Object Dirtex.PAL.lst)
	cat $^ > $@

Dist/Grizzards.Dirtex.SECAM.lst:	\
	$(shell bin/banks Object Dirtex.SECAM.lst)
	cat $^ > $@


Dist/Grizzards.Aquax.NTSC.lst:	\
	$(shell bin/banks Object Aquax.NTSC.lst)
	cat $^ > $@

Dist/Grizzards.Aquax.PAL.lst:	\
	$(shell bin/banks Object Aquax.PAL.lst)
	cat $^ > $@

Dist/Grizzards.Aquax.SECAM.lst:	\
	$(shell bin/banks Object Aquax.SECAM.lst)
	cat $^ > $@


Dist/Grizzards.Airex.NTSC.lst:	\
	$(shell bin/banks Object Airex.NTSC.lst)
	cat $^ > $@

Dist/Grizzards.Airex.PAL.lst:	\
	$(shell bin/banks Object Airex.PAL.lst)
	cat $^ > $@

Dist/Grizzards.Airex.SECAM.lst:	\
	$(shell bin/banks Object Airex.SECAM.lst)
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

Dist/Grizzards.Dirtex.NTSC.pro:	Source/Grizzards.pro Dist/Grizzards.Dirtex.NTSC.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/NTSC/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.Dirtex.NTSC.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Dirtex.PAL.pro:	Source/Grizzards.pro Dist/Grizzards.Dirtex.PAL.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/PAL/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.Dirtex.PAL.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Dirtex.SECAM.pro:	Source/Grizzards.pro Dist/Grizzards.Dirtex.SECAM.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/SECAM/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.Dirtex.SECAM.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Aquax.NTSC.pro:	Source/Grizzards.pro Dist/Grizzards.Aquax.NTSC.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/NTSC/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.Aquax.NTSC.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Aquax.PAL.pro:	Source/Grizzards.pro Dist/Grizzards.Aquax.PAL.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/PAL/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.Aquax.PAL.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Aquax.SECAM.pro:	Source/Grizzards.pro Dist/Grizzards.Aquax.SECAM.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/SECAM/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.Aquax.SECAM.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Airex.NTSC.pro:	Source/Grizzards.pro Dist/Grizzards.Airex.NTSC.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/NTSC/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.Airex.NTSC.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Airex.PAL.pro:	Source/Grizzards.pro Dist/Grizzards.Airex.PAL.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/PAL/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.Airex.PAL.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.Airex.SECAM.pro:	Source/Grizzards.pro Dist/Grizzards.Airex.SECAM.a26
	sed $< -e s/@@ATARIAGESAVE@@/0/ -e s/@@TV@@/SECAM/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.Airex.SECAM.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.AA.Dirtex.NTSC.pro:	Source/Grizzards.pro Dist/Grizzards.AA.Dirtex.NTSC.a26
	sed $< -e s/@@ATARIAGESAVE@@/1/ -e s/@@TV@@/NTSC/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.AA.Dirtex.NTSC.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.AA.Dirtex.PAL.pro:	Source/Grizzards.pro Dist/Grizzards.AA.Dirtex.PAL.a26
	sed $< -e s/@@ATARIAGESAVE@@/1/ -e s/@@TV@@/PAL/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.AA.Dirtex.PAL.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.AA.Dirtex.SECAM.pro:	Source/Grizzards.pro Dist/Grizzards.AA.Dirtex.SECAM.a26
	sed $< -e s/@@ATARIAGESAVE@@/1/ -e s/@@TV@@/SECAM/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.AA.Dirtex.SECAM.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.AA.Aquax.NTSC.pro:	Source/Grizzards.pro Dist/Grizzards.AA.Aquax.NTSC.a26
	sed $< -e s/@@ATARIAGESAVE@@/1/ -e s/@@TV@@/NTSC/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.AA.Aquax.NTSC.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.AA.Aquax.PAL.pro:	Source/Grizzards.pro Dist/Grizzards.AA.Aquax.PAL.a26
	sed $< -e s/@@ATARIAGESAVE@@/1/ -e s/@@TV@@/PAL/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.AA.Aquax.PAL.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.AA.Aquax.SECAM.pro:	Source/Grizzards.pro Dist/Grizzards.AA.Aquax.SECAM.a26
	sed $< -e s/@@ATARIAGESAVE@@/1/ -e s/@@TV@@/SECAM/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.AA.Aquax.SECAM.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.AA.Airex.NTSC.pro:	Source/Grizzards.pro Dist/Grizzards.AA.Airex.NTSC.a26
	sed $< -e s/@@ATARIAGESAVE@@/1/ -e s/@@TV@@/NTSC/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.AA.Airex.NTSC.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.AA.Airex.PAL.pro:	Source/Grizzards.pro Dist/Grizzards.AA.Airex.PAL.a26
	sed $< -e s/@@ATARIAGESAVE@@/1/ -e s/@@TV@@/PAL/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.AA.Airex.PAL.a26 | cut -d\  -f1)/g > $@

Dist/Grizzards.AA.Airex.SECAM.pro:	Source/Grizzards.pro Dist/Grizzards.AA.Airex.SECAM.a26
	sed $< -e s/@@ATARIAGESAVE@@/1/ -e s/@@TV@@/SECAM/g \
		-e s/@@MD5@@/$$(md5sum Dist/Grizzards.AA.Airex.SECAM.a26 | cut -d\  -f1)/g > $@

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

stella:	Dist/Grizzards.Aquax.NTSC.a26 Dist/Grizzards.Aquax.NTSC.lst \
	Dist/Grizzards.Aquax.NTSC.sym Dist/Grizzards.Aquax.NTSC.pro
	stella -tv.filter 3 -grabmouse 0 -bs EF \
		-lc Genesis -rc AtariVox \
		-format NTSC -pp Yes \
		-debug $<

stella-airex:	Dist/Grizzards.Airex.NTSC.a26 Dist/Grizzards.Airex.NTSC.lst \
	Dist/Grizzards.Airex.NTSC.sym Dist/Grizzards.Airex.NTSC.pro
	stella -tv.filter 3 -grabmouse 0 -bs EF \
		-lc Genesis -rc AtariVox \
		-format NTSC -pp Yes \
		-debug $<

stella-dirtex:	Dist/Grizzards.Dirtex.NTSC.a26 Dist/Grizzards.Dirtex.NTSC.lst \
	Dist/Grizzards.Dirtex.NTSC.sym Dist/Grizzards.Dirtex.NTSC.pro
	stella -tv.filter 3 -grabmouse 0 -bs EF \
		-lc Genesis -rc AtariVox \
		-format NTSC -pp Yes \
		-debug $<

stella-pal:	Dist/Grizzards.Aquax.PAL.a26 Dist/Grizzards.Aquax.PAL.lst \
	Dist/Grizzards.Aquax.PAL.sym Dist/Grizzards.Aquax.PAL.pro
	stella -tv.filter 3 -grabmouse 0 -bs EF \
		-lc Genesis -rc AtariVox \
		-format PAL -pp Yes \
		-debug $<

stella-secam:	Dist/Grizzards.Aquax.SECAM.a26 Dist/Grizzards.Aquax.SECAM.lst \
	Dist/Grizzards.Aquax.SECAM.sym Dist/Grizzards.Aquax.SECAM.pro
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

RELEASE=noreleasenamegiven
release:	all
	@if [ $(RELEASE) = noreleasenamegiven ]; then echo "Usage: make RELEASE=ident release" >&2; exit 1; fi
	mkdir -p Dist/$(RELEASE)
	-rm Dist/$(RELEASE)/*
	-cp -v Dist/Grizzards{.AA,}.{Demo,Airex,Aquax,Dirtex,NoSave,Unerase}.{NTSC,PAL,SECAM}.{a26,pro} \
		Dist/Grizzards.{Demo.{NTSC,PAL,SECAM},NoSave.{NTSC,PAL,SECAM},Unerase}.pdf \
		Dist/$(RELEASE) 2>/dev/null
	cp -v Dist/Grizzards{.AA,}.{NTSC,PAL,SECAM}.pdf Dist/$(RELEASE)
	cp -v Dist/Grizzards.AA.{NTSC,PAL,SECAM}-book.pdf Dist/$(RELEASE)
	cp -v Dist/Grizzards.Manual.txt Dist/$(RELEASE)
	@cd Dist/$(RELEASE) ; \
	for file in Grizzards.*.{zip,a26,pdf}; do \
		mv -v $$file $$(echo $$file | perl -pne 's(Grizzards.([^.]+).(.*)) (Grizzards.\1.$(RELEASE).\2)'); \
	done
	@echo "AtariAge Release $(RELEASE) of Grizzards for the Atari 2600. © 2021-2022 Bruce-Robert Pocock." | \
		zip -9 Dist/$(RELEASE)/Grizzards.AtariAge.$(RELEASE).zip \
		Dist/$(RELEASE)/Grizzards.AA.{Airex,Aquax,Dirtex}.*
	@echo "Release $(RELEASE) of Grizzards for the Atari 2600. © 2021-2022 Bruce-Robert Pocock." | \
		zip -9 Dist/$(RELEASE)/Grizzards.$(RELEASE).zip \
		Dist/$(RELEASE)/Grizzards.{Airex,Aquax,Dirtex}.* Dist/$(RELEASE)/Grizzards.{NTSC,PAL,SECAM}*pdf
	@echo "Demo Release $(RELEASE) of Grizzards for the Atari 2600. © 2021-2022 Bruce-Robert Pocock." | \
		zip -9 Dist/$(RELEASE)/Grizzards.Demo.$(RELEASE).zip \
		Dist/$(RELEASE)/Grizzards.Demo.*{a26,pdf,pro}
	@echo "No-Save Demo Release $(RELEASE) of Grizzards for the Atari 2600. © 2021-2022 Bruce-Robert Pocock." | \
		zip -9 Dist/$(RELEASE)/Grizzards.NoSave.$(RELEASE).zip \
		Dist/$(RELEASE)/Grizzards.NoSave.*{a26,pdf,pro}
	@echo "Unerase Tool Release $(RELEASE) of Grizzards for the Atari 2600. © 2021-2022 Bruce-Robert Pocock." | \
		zip -9 Dist/$(RELEASE)/Grizzards.Unerase.$(RELEASE).zip \
		Dist/$(RELEASE)/Grizzards.Unerase.*{a26,pdf,pro}

publish-release:	release
	until rsync -essh -v Dist/$(RELEASE)/*$(RELEASE)* \
		star-hope.org:star-hope.org/games/Grizzards ; \
		sleep 1 ; done
