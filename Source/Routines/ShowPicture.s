;;; -*- asm -*-
;;;
;;; Copyright © 2016,2017,2020,2021 Bruce-Robert Pocock (brpocock@star-hope.org)
;;;
;;; Most rights reserved. (See COPYING for details.)
;;;
;;; The “infamous” six-digit-score aka 48 pixel graphics code
;;; 
;;; This is some tricky (timing) stuff, and basically cribbed directly from:
;;;      https://www.biglist.com/lists/stella/archives/199704/msg00137.html
;;; and:
;;;      https://www.biglist.com/lists/stella/archives/199804/msg00198.html

ShowPicture:  .block
        ;; This  version  is  for  straight-up  displaying  some  bitmap  data.
        ;; It needs a table  of pointers to the bitmap data,  and it pushes one
        ;; byte into Temp
        ;; 
        ;; You'll need to set up everything else beforehand.

	.option allow_branch_across_page = false
	
          sta WSYNC
	.SleepX 61
Loop:
	ldy LineCounter
	lda (PixelPointers + 0), y
	sta GRP0
          .Sleep 5 + (BANK == 0 ? 0 : 1)
	lda (PixelPointers + 2), y
	sta GRP1
	lda (PixelPointers + 4), y
	sta GRP0
	lda (PixelPointers + 6), y
	sta Temp
	lax (PixelPointers + 8), y
	lda (PixelPointers + 10), y
	tay
	lda Temp
	sta GRP1
	stx GRP0
	sty GRP1
	sty GRP0
	dec LineCounter
	bne Loop

          .option allow_branch_across_page = true

	ldy #0
	sty GRP0
	sty GRP1
	sty GRP0
	sty GRP1
	rts

          .bend
