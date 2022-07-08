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
DrawLineLoop:       .macro first, second
          .block
InterleavedLoop:
	lax (\first + 0), y
          stx GRP0
	lda (\first + 2), y
          sta GRP1
          .Sleep 3
          lax (\first + 4), y
          lda (\first + 6), y
          stx GRP0
          sta GRP1
          .Sleep 3
          lax (\first + 8), y
          lda (\first + 10), y
          stx GRP0
          sta GRP1
          .if \first == PixelPointers
            ;; align for cycle 71(74) HMOVE
            lda # 0              ; -8px
            sta HMP0
            sta HMP1
            stx HMOVE
            .Sleep 7
          .else
            .Sleep 2
            ;; align for cycle 73(76) HMOVE
            lda #$80              ; +8px
            sta HMP0
            sta HMP1
            stx HMOVE
            .Sleep 9
          .fi
	lax (\second + 0), y
	lda (\second + 2), y
          stx GRP0
          sta GRP1
          .Sleep 3
          lax (\second + 4), y
          lda (\second + 6), y
          stx GRP0
          sta GRP1
          .Sleep 3
          lax (\second + 8), y
          lda (\second + 10), y
          stx GRP0
          sta GRP1
          .if \first == PixelPointers
            .Sleep 6
            ;; align for cycle 73(76) HMOVE
            lda #$80              ; +8px
            sta HMP0
            sta HMP1
            stx HMOVE
            .Sleep 4
          .else
            ;; align for cycle 71(74) HMOVE
            lda # 0              ; -8px
            sta HMP0
            sta HMP1
            stx HMOVE
            .Sleep 6
          .fi
          dey
          bpl InterleavedLoop
          .bend
          .endm

;;; 
          .align $100           ; TODO
AlignedLeft:
          .page
          ;; we enter on cycle 8 of the scan line
          .SleepX 57
          ;; align for cycle 73(76) HMOVE
          lda #$80              ; +8px
          sta HMP0
          sta HMP1
          stx HMOVE
          ldy # 4
          .Sleep 7
          .DrawLineLoop PixelPointers, SignpostAltPixelPointers
          .endp
          ldy # 0
          sty GRP0
          sty GRP1
          stx WSYNC
          rts

AlignedRight:
          .page
          stx WSYNC
          ldy # 4
          .Sleep 7
          .DrawLineLoop SignpostAltPixelPointers, PixelPointers
          .endp
          ldy # 0
          sty GRP0
          sty GRP1
          stx WSYNC
          rts

          .bend
