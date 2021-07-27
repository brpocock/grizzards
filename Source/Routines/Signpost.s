;;; Grizzards Source/Routines/Signpost.s
;;; Copyright © 2021 Bruce-Robert Pocock

Signpost: .block

Setup:
          .WaitScreenTop
          ldx SignpostIndex

          lda SignH, x
          sta SignpostText + 1
          sta SignpostWork + 1
          lda SignL, x
          sta SignpostText
          sta SignpostWork

          ldy # 0
          lda (SignpostWork), y
          sta SignpostFG
          iny
          lda (SignpostWork), y
          sta SignpostBG

          .Add16 SignpostText, #2

          .WaitScreenBottom

Loop:
          .WaitScreenTop

          lda SignpostText
          sta SignpostWork
          lda SignpostText + 1
          sta SignpostWork + 1

          .SkipLines KernelLines / 5

          lda # 0
          sta REFP0
          sta REFP1
          sta GRP0
          sta GRP1
          lda #NUSIZ3CopiesClose
          sta NUSIZ0
          sta NUSIZ1
          lda # 1
          sta VDELP0
          sta VDELP1

          sta WSYNC
          lda SignpostBG
          sta COLUBK
          lda SignpostFG
          sta COLUP0
          sta COLUP1

          lda # 5
          sta SignpostTextLine

TextLineLoop:
          dec SignpostTextLine
          bmi DoneDrawing
          
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

          ldy # 6
-
          lda (SignpostWork), y
          sta StringBuffer, y
          dey
          bpl -
          jsr DecodeText

          .Add16 SignpostWork, #12

          jmp AlignedLeft
          .align $80, $ea

AlignedLeft:
          .option allow_branch_across_page = false

          sta WSYNC
          ldy # 4
          sty SignpostScanline
          .SleepX 48
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
          .Add16 SignpostWork, #6

          .option allow_branch_across_page = false

          sta WSYNC
          sta HMCLR
          ldx #$b0
          ldy #$c0
          stx HMP0
          sty HMP1
          .Sleep 31
          sta RESP0
          sta RESP1
          .Sleep 23
          sta HMOVE             ; Cycle 74 HMOVE

          .option allow_branch_across_page = true

          ldy # 6
-
          lda (SignpostWork), y
          sta StringBuffer, y
          dey
          bpl -
          jsr DecodeText

          .Add16 SignpostWork, # 6

          jmp AlignedRight
          .align $80, $ea

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

          jmp TextLineLoop

;;; 
          
DoneDrawing:
          lda # 0
          .SkipLines 3
          sta COLUBK

          lda NewINPT4
          beq NoButton
          .BitBit PRESSED
          bne NoButton

          ldy # 2 + (12 * 5)
          lda (SignpostText), y
          sta GameMode

NoButton:

          .WaitScreenBottom

          lda GameMode
          cmp #ModeSignpost
          bne Leave
          jmp Loop

Leave:
          rts
          .bend

;;; 

          Signs = (Sign_HelloWorld)

SignH:    .byte >(Signs)
SignL:    .byte <(Signs)

Sign_HelloWorld:
          .colu COLGRAY, 0
          .colu COLYELLOW, $f
          .SignText "BEWARE! THIS"
          .SignText "ROUTE LEADS "
          .SignText "TO MANY EVIL"
          .SignText "MONSTERS.   "
          .SignText "BE CAREFUL! "
          .byte ModeSignpostDone
;;; 
