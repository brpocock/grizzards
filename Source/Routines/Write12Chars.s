;;; Grizzards Source/Routines/Write12Chars.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          .align $20            ; XXX alignment
Write12Chars:       .block

TextLineLoop:
          stx WSYNC
          lda ClockFrame
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
          .SleepX 36
          stx RESP0
          stx RESP1
          .SleepX 13
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
          ldx #$a0
          ldy #$b0
          stx HMP0
          sty HMP1
          .SleepX 17
          stx RESP0
          stx RESP1
          .SleepX 35
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
DrawLeftLine:       .macro

	ldy SignpostScanline
	lda (PixelPointers + 0), y
	sta GRP0
          .Sleep 6
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

          .endm
;;; 
          .if BANK > 3
            .align $100             ; alignment XXX
          .fi
AlignedLeft:
          .page

          stx WSYNC
          ldy # 4
          sty SignpostScanline
          .SleepX 49
LeftLoop:
          .DrawLeftLine
          .Sleep 8
          .DrawLeftLine
          .Sleep 8
          .DrawLeftLine
          dec SignpostScanline
          bpl LeftLoop

          .endp

          stx WSYNC
          ;; fall through
;;; 
DrawCommon:
          ldy # 0
          sty GRP0
          sty GRP1
          sty GRP0
          sty GRP1

          stx WSYNC
          stx WSYNC

DoneDrawing:
          rts
;;; 
DrawRightLine:      .macro
          ldy SignpostScanline
          lda (PixelPointers + 0), y
          sta GRP0
          .Sleep 6
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
          .endm
;;; 
          .align $100             ; alignment XXX

AlignedRight:
          .page

          stx WSYNC
          ldy # 4
          sty SignpostScanline
          .SleepX 66
RightLoop:
          .DrawRightLine
          .Sleep 8
          .DrawRightLine
          .Sleep 8
          .DrawRightLine
          dec SignpostScanline
          bpl RightLoop

          .endp

          jmp DrawCommon

          .bend

;;; Audited 2022-02-16 BRPocock
