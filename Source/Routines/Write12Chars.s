;;; Grizzards Source/Routines/Write12Chars.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          .align $20            ; XXX alignment
Write12Chars:       .block

          ldy # 0
          sty REFP0
          sty REFP1
          sty GRP0
          sty GRP1
          sty VDELP0
          sty VDELP1
          lda #NUSIZ3CopiesMed
          sta NUSIZ0
          sta NUSIZ1
TextLineLoop:
;;; 
          ;; Unpack 6-bits-per-character packed text
          ;; This saves 25% of string storage space at the cost of
          ;; this increased complexity here.
          ldy # 4
          .UnpackRight SignpostLineCompressed

          jsr DecodeText

          ;; Move to the alternate pointers
          ldx # 12
-
          lda PixelPointers, x
          sta SignpostAltPixelPointers, x
          dex
          bpl -

          ;; Unpack left now and decode
          ldy # 0
          .UnpackLeft SignpostLineCompressed

          jsr DecodeText

          .Add16 SignpostWork, # 9

          jmp AlignedCode

          .align $20            ; XXX

AlignedCode:
          .page

          sta HMCLR
          stx WSYNC

PositionPlayers:
          .SleepX 9
          ldy #$80
          sty HMP0
          ldy #$a0
          sty HMP1
          .Sleep 10
          stx RESP0
          .Sleep 3
          stx RESP1             ; ends on cycle 38

          .SleepX 33
          stx HMOVE             ; Cycle 74 HMOVE

          lda ClockFrame
          ror a
          bcc +
          jmp AlignedLeft
+
          jmp AlignedRight

          .endp

;;; 
          .if DEMO
            .align $40          ; XXX
          .fi
AlignedLeft:
          ;; we enter on cycle 8 of the scan line
          .SleepX 57
          .page
          ;; align for cycle 73(76) HMOVE
          lda #$80              ; +8px
          sta HMP0
          sta HMP1
          stx HMOVE
          ldy # 4
          .Sleep 7
LeftyLoopy:
          lda (PixelPointers + 0), y
          sta GRP0
	lda (PixelPointers + 2), y
          sta GRP1
          .Sleep 4
          lax (PixelPointers + 4), y
          lda (PixelPointers + 6), y
          stx GRP0
          sta GRP1
          lda (PixelPointers + 8), y
          sta GRP0
          lda (PixelPointers + 10), y
          sta GRP1
          .Sleep 2
          ;; align for cycle 71(74) HMOVE
          lda # 0              ; -8px
          sta HMP0
          sta HMP1
          stx HMOVE
          .Sleep 7
	lda (SignpostAltPixelPointers + 0), y
          sta GRP0
	lda (SignpostAltPixelPointers + 2), y
          .Sleep 4
          sta GRP1
          lax (SignpostAltPixelPointers + 4), y
          lda (SignpostAltPixelPointers + 6), y
          stx GRP0
          sta GRP1
          lda (SignpostAltPixelPointers + 8), y
          sta GRP0
          lda (SignpostAltPixelPointers + 10), y
          sta GRP1
          .Sleep 8
          ;; align for cycle 73(76) HMOVE
          lda #$80              ; +8px
          sta HMP0
          sta HMP1
          stx HMOVE
          .Sleep 4
          dey
          bpl LeftyLoopy
          .endp
          ldy # 0
          sty GRP0
          sty GRP1
          stx WSYNC
          rts

          .if DEMO
            .align $40          ; XXX
          .fi
AlignedRight:
          .page
          stx WSYNC
          ldy # 4
          .Sleep 7
RightyLoopy:
          lda (SignpostAltPixelPointers + 0), y
          sta GRP0
	lda (SignpostAltPixelPointers + 2), y
          sta GRP1
          .Sleep 2
          lax (SignpostAltPixelPointers + 4), y
          lda (SignpostAltPixelPointers + 6), y
          stx GRP0
          sta GRP1
          lda (SignpostAltPixelPointers + 8), y
          sta GRP0
          lda (SignpostAltPixelPointers + 10), y
          sta GRP1
          .Sleep 6
          ;; align for cycle 73(76) HMOVE
          lda #$80              ; +8px
          sta HMP0
          sta HMP1
          stx HMOVE
          .Sleep 9
	lax (PixelPointers + 0), y
	lda (PixelPointers + 2), y
          stx GRP0
          sta GRP1
          .Sleep 3
          lax (PixelPointers + 4), y
          lda (PixelPointers + 6), y
          stx GRP0
          sta GRP1
          lda (PixelPointers + 8), y
          sta GRP0
          lda (PixelPointers + 10), y
          sta GRP1
          .Sleep 3
          ;; align for cycle 71(74) HMOVE
          lda # 0              ; -8px
          sta HMP0
          sta HMP1
          stx HMOVE
          .Sleep 6
          dey
          bpl RightyLoopy
          .endp
          ldy # 0
          sty GRP0
          sty GRP1
          stx WSYNC
          rts

          .bend
