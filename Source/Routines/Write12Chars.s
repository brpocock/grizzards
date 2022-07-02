;;; Grizzards Source/Routines/Write12Chars.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          .align $20            ; XXX alignment
Write12Chars:       .block

TextLineLoop:
;;; 
          .page

          stx WSYNC
          sta HMCLR
          ldy # 0
          sty HMP0
          sty HMP1

          lda ClockFrame
          clc
          adc SignpostTextLine
          ror a
          bcc +

          .Sleep 5
+
          .Sleep 6
          stx RESP0
          .SleepX 13
          stx RESP1
          .SleepX 15
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
	lda (PixelPointers + 6), y
          sta GRP1
          .Sleep 2
          lax (PixelPointers + 2), y
          lda (PixelPointers + 4), y
          stx GRP0
          sta GRP0
          lax (PixelPointers + 8), y
          lda (PixelPointers + 10), y
          stx GRP1
          sta GRP1
 
          .endm
;;; 
AlignedLeft:
          .page

          stx WSYNC
          ldy # 4
          sty SignpostScanline
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

