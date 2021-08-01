;;; Grizzards Source/Routines/Signpost.s
;;; Copyright © 2021 Bruce-Robert Pocock

Signpost: .block

Setup:
          .WaitScreenTop

          .KillMusic
          sta AUDC0
          sta AUDF0
          sta AUDV0
          sta CurrentUtterance + 1  ; zero from KillMusic

          ldx SignpostIndex

          cpx # 3
          beq CheckTunnelBlocked
          cpx # 6
          beq CheckTunnelVisited
          cpx # 7
          beq CheckTunnelVisited

          jmp IndexReady

CheckTunnelBlocked:
          lda ProvinceFlags + 2
          and # %00000110   ; Do they have both artifacts?
          cmp # %00000110
          bne IndexReady        ; no, tunnel blocked
          .if DEMO
          inx                   ; yes, tunnel open now — end of demo message
          .else
          ldx #16               ; tunnel open, full game
          .fi
          bne IndexReady        ; alway taken

CheckTunnelVisited:
          lda ProvinceFlags + 2
          and # $01
          bne VisitedTunnel   ; did they visit the tunnel?
          ldx # 5               ; no, can't have artifact
          bne IndexReady        ; always taken

VisitedTunnel:
          lda ProvinceFlags + 2
          cpx # 6
          beq Artifact1
          and # $02
          beq IndexReady        ; get artifact
TookArtifact:
          ldx # 8
          bne IndexReady        ; always taken

Artifact1Scared:
          ldx # 15
          bne IndexReady        ; always taken
          
Artifact1:
          and # $04
          bne TookArtifact
          lda ProvinceFlags + 2
          and #$30
          cmp #$30
          bne Artifact1Scared
          ;; fall through

IndexReady:
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

          ldy # 6
-
          lda (SignpostWork), y
          sta StringBuffer, y
          dey
          bpl -
          jsr DecodeText

          .Add16 SignpostWork, #12

          jmp AlignedLeft
          .align $40, $ea

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

          ldy # 6
-
          lda (SignpostWork), y
          sta StringBuffer, y
          dey
          bpl -
          jsr DecodeText

          .Add16 SignpostWork, # 6

          jmp AlignedRight
          .align $20, $ea

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

          ldy # (12 * 5)
          lda (SignpostText), y
          sta GameMode

NoButton:

          .WaitScreenBottom

          lda GameMode
          cmp #ModeSignpost
          bne Leave
          jmp Loop

Leave:
          cmp #ModeSignpostSetFlag
          bne ByeBye
          ldy # (12 * 5) + 1
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
          lda # ( 76 * OverscanLines ) / 64 - 1
          sta TIM64T

          jsr PlaySpeech

FillOverscan:
          lda INSTAT
          bpl FillOverscan

          sta WSYNC
          rts
          .bend          
