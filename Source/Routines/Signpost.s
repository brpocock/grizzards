;;; Grizzards Source/Routines/Signpost.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; CRITICAL cross-bank alignment.
;;; This MUST start at the same address in every signpost bank, and
;;; the code must have the same byte length in every bank
;;; through the bank up/down switching code near IndexReady.
Signpost: .block

Setup:
          ldx #$ff
          txs

          lda GameMode
          cmp #ModeSignpostInquire
          beq +
          .WaitScreenTop
          jmp Silence

+
          .WaitScreenTopMinus 1, 0

Silence:
          .KillMusic
          sta AUDC0
          sta AUDF0
          sta AUDV0
          sta CurrentUtterance + 1  ; zero from KillMusic

          ldx #$ff
          txs

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
          lda #BANK - 1
          sta BankControl
          .else
          nop                   ; lda#
          nop                   ; BANK - 1
          nop                   ; sta
          nop                   ; $f9
          brk                   ; $ff
          .fi
          jmp IndexReady

NoBankDown:
          cpx #FirstSignpost + len(Signs)
          blt NoBankUp
BankUp:
          .if BANK < SignpostBank + SignpostBankCount - 1
          lda #BANK + 1
          sta BankControl
          .else
          nop                   ;lda #
          nop                   ; BANK + 1
          nop                   ; sta
          nop                   ; $f9
          brk                   ; $ff
          .fi
          jmp IndexReady

          .fi                   ; end of .if ! DEMO

NoBankUp:
;;; 
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
          lda (SignpostWork), y ; FG color
          sta SignpostFG
          iny
          lda (SignpostWork), y ; BG color
          sta SignpostBG
          iny
          lda (SignpostWork), y ; conditional?
          cmp #$ff
          bne Unconditional
Conditional:
          iny
          lda (SignpostWork), y ; bit flag upon which it's conditional
          tay
          and #$38
          lsr a
          lsr a
          lsr a
          tax
          lda ProvinceFlags, x
          sta Temp
          tya
          and #$07
          tax
          lda BitMask, x
          and Temp
          beq ConditionFailed

          ldy # 4               ; jump to which alternative
          lda (SignpostWork), y
          tax
          jmp IndexReady

ConditionFailed:
          .Add16 SignpostText, #5
          jmp ReadyToDraw

Unconditional:
          .Add16 SignpostText, #2
ReadyToDraw:
          lda # 2
          sta AlarmCountdown

          .WaitScreenBottom
          .if NTSC != TV
          lda GameMode
          cmp #ModeSignpostInquire
          bne +
          stx WSYNC
          stx WSYNC
+
          .fi

          lda #ModeSignpost
          sta GameMode
;;; 
Loop:
          .WaitScreenTop

          lda SignpostText
          sta SignpostWork
          lda SignpostText + 1
          sta SignpostWork + 1

          .SkipLines KernelLines / 6

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

          stx WSYNC
          lda SignpostBG
          sta COLUBK
          lda SignpostFG
          sta COLUP0
          sta COLUP1

          lda # 5
          sta SignpostTextLine

NextTextLine:

          ldy # 8
-
          lda (SignpostWork), y
          sta SignpostLineCompressed, y
          dey
          bpl -

          .FarJSR AnimationsBank, ServiceWrite12Chars
          dec SignpostTextLine
          bne NextTextLine
;;; 
DoneDrawing:
          lda # 0
          .SkipLines 3
          sta COLUBK

          lda AlarmCountdown      ; require 1-2s to tick before accepting button press; see #140
          bne NoButton
          lda NewButtons
          beq NoButton
          .BitBit PRESSED
          bne NoButton

GetNextMode:
          ldy # (9 * 5)
          lda (SignpostText), y
          sta GameMode

NoButton:
          lda NewSWCHB
          beq NoSwitches
          and #SWCHBReset
          bne NoSwitches

          ;; TODO reset the game

NoSwitches:
          lda GameMode
          cmp #ModeSignpost
          bne Leave
          .WaitScreenBottom
          jmp Loop
;;; 
Leave:
          cmp #ModeTrainLastMove
          bne NotTrainLastMove

TrainLastMove:
          lda MovesKnown
          ora #$80
          sta MovesKnown
          gne ByeBye

NotTrainLastMove:
          cmp #ModeSignpostSet0And63
          bne NotSet0And63

SetFlags0And63:
          sed
          lda Score + 1
          clc
          adc # 1
          sta Score + 1
          bcc +
          inc Score + 2
+
          cld
          lda ProvinceFlags + 0
          ora #$01
          sta ProvinceFlags + 0
          lda ProvinceFlags + 7
          ora #$80
          sta ProvinceFlags + 7
          gne ByeBye

NotSet0And63:
          cmp #ModeSignpostClearFlag
          bne NotClearFlag

ClearFlag:
          ldy # (9 * 5) + 1
          lda (SignpostText), y
          sta Temp
          .ClearBitFlag Temp
          jmp ByeBye

NotClearFlag:
          cmp #ModeSignpostWarp
          bne NotWarp

Warp:
ProvinceChange:
;;; Duplicated in Signpost.s and CheckPlayerCollision.s nearly exactly
          ldx #$ff              ; smash the stack
          txs
          .if NTSC == TV
            .SkipLines KernelLines - 179
            jsr Overscan
          .else
            ldx INTIM
            dex
            stx TIM64T
            .WaitScreenBottom
          .fi
          lda #SoundShipSailing
          sta NextSound
          .FarJSR SaveKeyBank, ServiceSaveProvinceData
          .WaitScreenTopMinus 1, 0

          ldy # (9 * 5) + 1
          lda (SignpostText), y
          sta CurrentProvince
          iny
          lda (SignpostText), y
          sta NextMap
          ldy #ModeMapNewRoom
          sty GameMode
          
          .FarJSR SaveKeyBank, ServiceLoadProvinceData
          .WaitScreenBottom
          .if TV != NTSC
          .SkipLines 2
          .fi
          jmp GoMap

NotWarp:
          cmp #ModeSignpostSetFlag
          bne NotSetFlag
SetFlag:
          ldy # (9 * 5) + 1
          lda (SignpostText), y
          sta Temp
          .SetBitFlag Temp
          jmp ByeBye

NotSetFlag:
          cmp #ModeSignpostPotions
          bne NotPotions
GetPotions:
          ldy # (9 * 5) + 1
          lda (SignpostText), y
          adc Potions
          sta Potions

          lda #SoundVictory
          sta NextSound

          .Add16 SignpostText, # 2
          jmp GetNextMode

NotPotions:
          cmp #ModeSignpostPoints
          bne NotPoints
GetPoints:
          sed
          lda Score
          clc
          ldy # (9 * 5) + 1
          adc (SignpostText), y
          sta Score
          lda Score + 1
          iny
          adc (SignpostText), y
          sta Score + 1
          bcc +
          inc Score + 2
+
          cld
          lda SignpostText
          clc
          .Add16 SignpostText, # 3
          jmp GetNextMode

NotPoints:
          cmp #ModeSignpostInquire
          bne NotInquire
Inquire:
          .Add16 SignpostText, # (9 * 5) + 1

          ldy # 0
          sty SignpostInquiry
          lda (SignpostText), y
          sta SignpostFG
          iny
          lda (SignpostText), y
          sta SignpostBG

          .Add16 SignpostText, # 2

          ldy # 8
-
          lda (SignpostText), y
          sta SignpostLineCompressed, y
          dey
          bpl -

          .FarJMP AnimationsBank, ServiceInquire

NotInquire:
          cmp #ModeWinnerFireworks
          bne NotFireworks

          sta GameMode
          .if BANK == $0c
          jmp WinnerFireworks
          .else
          brk
          .fi

NotFireworks:
          cmp #ModeSignpostNext
          bne NotNext

          ldy # (9 * 5) + 1
          lda (SignpostText), y
          sta SignpostIndex

          lda #ModeSignpost
          sta GameMode

NotNext:
          cmp #ModeSignpostDone
          beq ByeBye

          brk
;;; 
ByeBye:
          lda # 0
          sta CurrentUtterance
          sta CurrentUtterance + 1

          .WaitScreenBottom

          jmp GoMap
          .bend

;;; 
;;; Overscan is different, we don't have  sound effects nor music and we
;;; don't want Bank 7 to get confused by our speech.
Overscan: .block
          .TimeLines OverscanLines

          jsr PlaySpeech

          .WaitForTimer

          stx WSYNC
          rts
          .bend
