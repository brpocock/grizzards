;;; Grizzards Source/Routines/Signpost.s
;;; Copyright © 2021 Bruce-Robert Pocock

;;; CRITICAL cross-bank alignment.
;;; This MUST start at the same address in every signpost bank, and
;;; the code must have the same byte length in every bank
;;; through the bank up/down switching code near IndexReady.
Signpost: .block

Setup:
          .WaitScreenTop

          .KillMusic
          sta AUDC0
          sta AUDF0
          sta AUDV0
          sta CurrentUtterance + 1  ; zero from KillMusic

          .if BANK == SignpostBank
          jsr GetSignpostIndex
          .else
          nop
          nop
          nop
          .fi

IndexReady:
          .if !DEMO
          ;; is this index in this memory bank?
          cpx #FirstSignpost
          bge NoBankDown
BankDown:
          .if BANK > SignpostBank
          stx BankSwitch0 + BANK - 1
          .else
          nop
          nop
          brk
          .fi
          jmp IndexReady

NoBankDown:
          cpx #FirstSignpost + len(Signs)
          blt NoBankUp
BankUp:
          .if BANK < SignpostBank + SignpostBankCount - 1
          stx BankSwitch0 + BANK + 1
          .else
          nop
          nop
          brk
          .fi
          jmp IndexReady

          .fi                   ; end of .if ! DEMO

NoBankUp:
;;; Beyond this point, cross-bank alignment does not matter.
          ;; Adjust the index to be relative to this bank
          txa
          sec
          sbc #FirstSignpost
          tax
          stx SignpostIndex

          lda SignH, x
          sta SignpostText + 1
          sta SignpostWork + 1
          lda SignL, x
          sta SignpostText
          sta SignpostWork

          inx
          stx CurrentUtterance

          ldy # 0
          lda (SignpostWork), y
          sta SignpostFG
          iny
          lda (SignpostWork), y
          sta SignpostBG

          .Add16 SignpostText, #2

          lda ClockSeconds
          sta AlarmSeconds

          .WaitScreenBottom
;;; 
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

          ;; Unpack 6-bits-per-character packed text
          ;; This saves 25% of string storage space at the cost of
          ;; this increased complexity here.
          ldy # 0
          .UnpackLeft SignpostWork

          jsr DecodeText

          .Add16 SignpostWork, #9

          jmp AlignedLeft
          .align $100, $ea

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
          .UnpackRight SignpostWork

          jsr DecodeText

          .Add16 SignpostWork, #9

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

          jmp TextLineLoop

;;; 

DoneDrawing:
          lda # 0
          .SkipLines 3
          sta COLUBK

          lda AlarmSeconds      ; require 1s to tick before accepting button press
          cmp ClockSeconds      ; see #140
          beq NoButton
          lda NewButtons
          beq NoButton
          .BitBit PRESSED
          bne NoButton

          ldy # (9 * 5)
          lda (SignpostText), y
          sta GameMode

NoButton:
          lda GameMode
          cmp #ModeSignpost
          bne Leave
          .WaitScreenBottom
          jmp Loop

Leave:
          cmp #ModeSignpostSetFlag
          bne ByeBye
          sed
          lda Score
          adc #$03
          sta Score
          lda Score + 1
          adc # 0
          sta Score + 1
          bcc NCar0
          inc Score + 2
NCar0:
          sta Score
          cld
          ldy # (9 * 5) + 1
          lda (SignpostText), y
          sta Temp
          .SetBitFlag Temp

ByeBye:
          lda # 0
          sta CurrentUtterance
          sta CurrentUtterance + 1
          rts
          .bend

;;; 
;;; Overscan is different, we don't have  sound effects nor music and we
;;; don't want Bank 7 to get confused by our speech.
Overscan: .block
          .TimeLines OverscanLines

          jsr PlaySpeech

          .WaitForTimer

          sta WSYNC
          rts
          .bend
