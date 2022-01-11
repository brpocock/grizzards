;;; Grizzards Source/Routines/Write12Chars.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

Write12Chars:       .block

TextLineLoop:
          lda ClockFrame
          and #$01
          beq DrawRightField

DrawLeftField:
          .option allow_branch_across_page = false

          sta WSYNC
          sta HMCLR
          ldx #$a0
          ldy #$b0
          stx HMP0
          sty HMP1
          .Sleep 17
          sta RESP0
          sta RESP1
          .Sleep 35
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
          .align $b0, $ea

AlignedLeft:
          .option allow_branch_across_page = false

          sta WSYNC
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

          sta WSYNC

          jmp DrawCommon

DrawRightField:

          .option allow_branch_across_page = false

          sta WSYNC
          sta HMCLR
          ldx #$00
          ldy #$00
          stx HMP0
          sty HMP1
          .Sleep 34
          sta RESP0
          sta RESP1
          .Sleep 13
          sta HMOVE             ; Cycle 74 HMOVE

          .option allow_branch_across_page = true

          ldy # 4
          .UnpackRight SignpostLineCompressed

          jsr DecodeText

          .Add16 SignpostWork, # 9

          jmp AlignedRight
          .align $40, $ea

AlignedRight:
          .option allow_branch_across_page = false

          sta WSYNC
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

DrawCommon:
          lda # 0
          sta GRP0
          sta GRP1
          sta GRP0
          sta GRP1

          sta WSYNC
          sta WSYNC

DoneDrawing:
          rts

          .bend
