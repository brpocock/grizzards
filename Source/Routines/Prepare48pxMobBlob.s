;;; Grizzards Source/Routines/Prepare48pxMobBlob.s
;;; -*- asm -*-
;;;
;;; Copyright © 2016,2017,2020-2022 Bruce-Robert Pocock (brpocock@star-hope.org)
;;;
;;; Most rights reserved. (See COPYING for details.)
;;;
;;; The “infamous” six-digit-score aka 48 pixel graphics code
;;; 
;;; This is some tricky (timing) stuff, and basically cribbed directly from:
;;;      https://www.biglist.com/lists/stella/archives/199704/msg00137.html
;;; and:
;;;      https://www.biglist.com/lists/stella/archives/199804/msg00198.html

Prepare48pxMobBlob: .block
          ;; Sets up the horizontal positioning before the 48px
          ;; routine can be used.

          ;; Sets P0₀ position to 55px, P1₀ to 63px

          ldy # 0
          sty REFP0
          sty REFP1
          sty GRP0
          sty GRP1
          lda #NUSIZ3CopiesClose
          sta NUSIZ0
          sta NUSIZ1
          lda # 1
          sta VDELP0
          sta VDELP1

          .page

          stx WSYNC           ; Critical timing from here …
          sta HMCLR 
          ldx #$a0
          ldy #$b0
          stx HMP0
          sty HMP1
          .Sleep 24
          sta RESP0
          sta RESP1
          .Sleep 28
          sta HMOVE		; Cycle 74 HMOVE

          .endp

          rts

          .bend

;;; Audited 2022-02-16 BRPocock
