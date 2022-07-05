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
          .page

          sta HMCLR
          stx WSYNC

          lda ClockFrame
          clc
          adc SignpostTextLine
          ror a
          bcc LeftLine

RightLine:
          ldy #$80
          sty HMP0
          ldy #$a0
          sty HMP1
          .Sleep 10
          stx RESP0
          .Sleep 3
          stx RESP1
          jmp CommonLine

LeftLine:
          ldy #$a0
          sty HMP0
          ldy #$c0
          sty HMP1
          .Sleep 7
          stx RESP0
          .Sleep 3
          stx RESP1

CommonLine:
          stx WSYNC
          .SleepX 71
          stx HMOVE             ; Cycle 74 HMOVE

          .endp

          lda ClockFrame
          clc
          adc SignpostTextLine
          ror a
          bcc DrawLeftField
          
          ldy # 4
          .UnpackRight SignpostLineCompressed

          jsr DecodeText

          .Add16 SignpostWork, # 9

          .page

          stx WSYNC
          ldy # 4
          sty SignpostScanline
          jmp InterleavedLoop

          .endp

;;; 
DrawLeftField:
          ;; Unpack 6-bits-per-character packed text
          ;; This saves 25% of string storage space at the cost of
          ;; this increased complexity here.
          ldy # 0
          .UnpackLeft SignpostLineCompressed

          jsr DecodeText

          .Add16 SignpostWork, # 9

          ;; falls through (disregard the macro definition here)
;;; 
DrawInterleavedLine:       .macro

          ldy SignpostScanline
	lda (PixelPointers + 0), y
          sta GRP0
	lda (PixelPointers + 2), y
          sta GRP1
          .Sleep 2
          lax (PixelPointers + 4), y
          lda (PixelPointers + 6), y
          stx GRP0
          sta GRP1
          lax (PixelPointers + 8), y
          lda (PixelPointers + 10), y
          stx GRP0
          sta GRP1
 
          .endm
;;; 
AlignedLeft:
          .page

          stx WSYNC
          ldy # 4
          sty SignpostScanline
          .if PORTABLE
            .Sleep 3
           .fi
InterleavedLoop:
          .DrawInterleavedLine
          .SleepX 23
          .DrawInterleavedLine
          .SleepX 23
          .DrawInterleavedLine
          ldy # 0
          sty GRP0
          sty GRP1
          .SleepX 7
          dec SignpostScanline
          bpl InterleavedLoop

          .endp

          stx WSYNC
          stx WSYNC
          stx WSYNC

DoneDrawing:
          rts

          .bend

