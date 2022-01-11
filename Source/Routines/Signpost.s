;;; Grizzards Source/Routines/Signpost.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

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

          lda AlarmCountdown      ; require 1s to tick before accepting button press; see #140
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
          lda GameMode
          cmp #ModeSignpost
          bne Leave
          .WaitScreenBottom
          jmp Loop

Leave:
          cmp #ModeTrainLastMove
          bne NotTrainLastMove

          lda MovesKnown
          ora #$80
          sta MovesKnown
          jmp Leave

NotTrainLastMove:
          cmp #ModeSignpostSet0And63
          bne NotSet0And63

          sed
          lda Score + 1
          clc
          adc # 1
          sta Score + 1
          bcc NCar100
          inc Score + 2
NCar100:
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
          sed
          lda Score
          clc
          adc #$04
          sta Score
          lda Score + 1
          adc # 0
          sta Score + 1
          bcc NCar1
          inc Score + 2
NCar1:
          cld
          ldy # (9 * 5) + 1
          lda (SignpostText), y
          sta Temp
          .ClearBitFlag Temp
          jmp ByeBye

NotClearFlag:
          cmp #ModeSignpostWarp
          bne NotWarp
          ldy # (9 * 5) + 1
          lda (SignpostText), y
          sta CurrentProvince
          iny
          lda (SignpostText), y
          sta NextMap
          lda #ModeMapNewRoom
          jmp GoMap

NotWarp:
          cmp #ModeSignpostSetFlag
          bne NotSetFlag
          sed
          lda Score
          clc
          adc #$03
          sta Score
          lda Score + 1
          adc # 0
          sta Score + 1
          bcc NCar0
          inc Score + 2
NCar0:
          cld
          ldy # (9 * 5) + 1
          lda (SignpostText), y
          sta Temp
          .SetBitFlag Temp
          jmp ByeBye

NotSetFlag:
          .if DEMO

          ;; none of the points or inquire code
          ;; fall through to NotInquire

          .else
          cmp #ModeSignpostPoints
          bne NotPoints
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
          lda # SoundVictory
          sta NextSound
          lda SignpostText
          clc
          adc # 3
          sta SignpostText
          bcc +
          inc SignpostText + 1
+
          jmp GetNextMode

NotPoints:
          cmp #ModeSignpostInquire
          bne NotInquire

          .Add16 SignpostText, #( 9 * 5 ) + 2
          .FarJSR AnimationsBank, ServiceInquire

          .fi                   ; !DEMO

NotInquire:
          cmp #ModeSignpostDone
          beq ByeBye

          brk

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
