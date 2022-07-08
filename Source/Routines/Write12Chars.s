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
          stx RESP1

          stx WSYNC
          .SleepX 71
          stx HMOVE             ; Cycle 74 HMOVE

          lda ClockFrame
          ror a
          bcc +
          jmp AlignedLeft
+
          jmp AlignedRight

          .endp

;;; 
DrawInterleavedLine:       .macro origin

	lax (\origin + 0), y
	lda (\origin + 2), y
          stx GRP0
          sta GRP1
          lax (\origin + 4), y
          lda (\origin + 6), y
          stx GRP0
          sta GRP1
          lax (\origin + 8), y
          lda (\origin + 10), y
          stx GRP0
          sta GRP1
          nop
          nop
          nop
 
          .endm

ShiftLeft:         .macro
          ;; align for cycle 71(74) HMOVE
          lda # 0              ; -8px
          sta HMP0
          sta HMP1
          stx HMOVE
          nop $71
          nop
          .endm

ShiftRight:         .macro
          ;; align for cycle 73(76) HMOVE
          lda #$80              ; +8px
          sta HMP0
          sta HMP1
          nop
          stx HMOVE
          nop
          nop $69
          .endm

DrawLineLoop:       .macro first, second
          .block
InterleavedLoop:
          .DrawInterleavedLine \first
          .if \first == PixelPointers
            .ShiftLeft
          .else
            .ShiftRight
          .fi
          .Sleep 5
          .DrawInterleavedLine \second
          .if \first == PixelPointers
            .ShiftRight
          .else
            .ShiftLeft
          .fi
          dey
          bpl InterleavedLoop
          .bend
          .endm

;;; 
          .align $100           ; TODO
AlignedLeft:
          .page
          stx WSYNC
          stx WSYNC
          ldy # 4
          .Sleep 7
          .DrawLineLoop PixelPointers, SignpostAltPixelPointers
          .endp
          ldy # 0
          sty GRP0
          sty GRP1
          rts

AlignedRight:
          .page
          stx WSYNC
          ldy # 4
          .Sleep 7
          .DrawLineLoop PixelPointers, SignpostAltPixelPointers
          .endp
          ldy # 0
          sty GRP0
          sty GRP1
          stx WSYNC
          rts

          .bend
