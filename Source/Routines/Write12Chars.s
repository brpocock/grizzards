;;; Grizzards Source/Routines/Write12Chars.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

Write12Chars:       .block

TextLineLoop:
          stx WSYNC
          lda ClockFrame
          and #$01
          bne DrawLeftField
          ;; fall through
;;; 
DrawRightField:

          .option allow_branch_across_page = false

          stx WSYNC
          sta HMCLR
          ldx #$00
          ldy #$00
          stx HMP0
          sty HMP1
          .SleepX 34
          sta RESP0
          sta RESP1
          .SleepX 13
          sta HMOVE             ; Cycle 74 HMOVE

          .option allow_branch_across_page = true
          .NoPageCrossSince AlignedLeft

          ldy # 4
          .UnpackRight SignpostLineCompressed

          jsr DecodeText

          .Add16 SignpostWork, # 9

          jmp AlignedRight
;;; 
DrawLeftField:
          .option allow_branch_across_page = false

          stx WSYNC
          sta HMCLR
          ldx #$a0
          ldy #$b0
          stx HMP0
          sty HMP1
          .SleepX 17
          sta RESP0
          sta RESP1
          .SleepX 35
          sta HMOVE             ; Cycle 74 HMOVE

          .option allow_branch_across_page = true

          ;; Unpack 6-bits-per-character packed text
          ;; This saves 25% of string storage space at the cost of
          ;; this increased complexity here.
          ldy # 0
          .UnpackLeft SignpostLineCompressed

          jsr DecodeText

          .Add16 SignpostWork, # 9

          jmp AlignedLeft
;;; 
          .fill $50             ; alignment XXX
AlignedLeft:
          .option allow_branch_across_page = false

          stx WSYNC
          ldy # 4
          sty SignpostScanline
          .SleepX 49
LeftLoop:
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

	.Sleep 8

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

	.Sleep 8

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
	dec SignpostScanline
          bpl LeftLoop

          stx WSYNC
          ;; fall through
;;; 
DrawCommon:
          lda # 0
          sta GRP0
          sta GRP1
          sta GRP0
          sta GRP1

          stx WSYNC
          stx WSYNC

DoneDrawing:
          rts
;;; 

          .align $100             ; alignment XXX

AlignedRight:
          .option allow_branch_across_page = false

          stx WSYNC
          ldy # 4
          sty SignpostScanline
          .SleepX 65
RightLoop:
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

	.Sleep 8

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

	.Sleep 8

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
	dec SignpostScanline
          bpl RightLoop

          .option allow_branch_across_page = true
          .NoPageCrossSince AlignedRight

          jmp DrawCommon

          .bend
