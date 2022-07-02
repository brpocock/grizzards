;;; Grizzards Source/Routines/Write12Chars.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          .align $20            ; XXX alignment
Write12Chars:       .block

TextLineLoop:
          stx WSYNC
          lda ClockFrame
          clc
          adc SignpostTextLine
          and #$01
          bne DrawLeftField
          ;; fall through
;;; 
DrawRightField:

          .page

          stx WSYNC
          sta HMCLR
          ldy # 0
          sty HMP0
          sty HMP1
          .SleepX 23
          stx RESP0
          .SleepX 13
          stx RESP1
          .SleepX 15
          stx HMOVE             ; Cycle 74 HMOVE

          .endp

          ldy # 4
          .UnpackRight SignpostLineCompressed

          jsr DecodeText

          .Add16 SignpostWork, # 9

          jmp AlignedRight
;;; 
DrawLeftField:
          .page

          stx WSYNC
          sta HMCLR
          ldx #$10
          ldy #$10
          stx HMP0
          sty HMP1
          .SleepX 19
          stx RESP0
          .SleepX 13
          stx RESP1
          .SleepX 18
          stx HMOVE             ; Cycle 74 HMOVE

          .endp

          ;; Unpack 6-bits-per-character packed text
          ;; This saves 25% of string storage space at the cost of
          ;; this increased complexity here.
          ldy # 0
          .UnpackLeft SignpostLineCompressed

          jsr DecodeText

          .Add16 SignpostWork, # 9

          jmp AlignedLeft
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
          .Sleep 15
 
          .endm
;;; 
          .if BANK > 3
            .align $100             ; alignment XXX
          .fi
AlignedLeft:
          .page

          stx WSYNC
          ldy # 4               ; 2 [ 6 ] 6
          sty SignpostScanline  ; 3 [ 9 ] 15
InterleavedLoop:
          .DrawInterleavedLine
          .Sleep 8
          .DrawInterleavedLine
          .Sleep 8
          .DrawInterleavedLine
          dec SignpostScanline
          bpl InterleavedLoop

          .endp

          stx WSYNC
          ;; fall through
;;; 
DrawCommon:
          ldy # 0
          sty GRP0
          sty GRP1

          stx WSYNC
          stx WSYNC

DoneDrawing:
          rts
;;; 
          .align $10             ; alignment XXX

AlignedRight:
          .page

          stx WSYNC
          ldy # 4
          sty SignpostScanline
          jmp InterleavedLoop

          .endp

          .bend

;;; Audited 2022-02-16 BRPocock
