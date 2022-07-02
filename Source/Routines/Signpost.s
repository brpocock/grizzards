;;; Grizzards Source/Routines/Signpost.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; CRITICAL cross-bank alignment.
;;; This MUST start at the same address in every signpost bank, and
;;; the code must have the same byte length in every bank
;;; through the bank up/down switching code near IndexReady.
Signpost: .block

Setup:
          lda GameMode
          cmp #ModeSignpostInquire
          beq +
          .WaitScreenTop
          gne Silence

+
          stx WSYNC
          .WaitScreenTopMinus 1, 10

Silence:
          .KillMusic
          sta AUDC0
          sta AUDF0
          sta AUDV0
          sta CurrentUtterance + 1  ; zero from KillMusic

          .mvx s, #$ff

          .if BANK == SignpostBank
            jsr GetSignpostIndex
          .else
            nop                 ; Cross-bank alignment!
            ldx SignpostIndex
          .fi

IndexReady:
          .if !DEMO             ; Demo has only the one bank of text
          ;; is this index in this memory bank?
          cpx #FirstSignpost
          bge NoBankDown
BankDown:
          .if BANK > SignpostBank
            stx BankSwitch0 + BANK - 1
          .else
            brk                 ; cross-bank alignment!
            brk
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
            brk                 ; cross-bank alignment!
            brk
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
          bne DoneConditional

Conditional:
          iny
          lda (SignpostWork), y ; bit flag upon which it's conditional
          tay                   ; save bit flag index
          and #%00111000
          lsr a
          lsr a
          lsr a
          tax
          lda ProvinceFlags, x
          sta Temp              ; byte of bit flags
          tya                   ; recover original bit flag index
          and #%00000111
          tax
          lda BitMask, x
          and Temp              ; byte of bit flags
          beq ConditionFailed

          ldy # 4               ; jump to which alternative
          lda (SignpostWork), y
          tax
          jmp IndexReady        ; fetch new alternative

ConditionFailed:
          .Add16 SignpostText, # 5
          jmp ReadyToDraw

DoneConditional:
          .Add16 SignpostText, # 2
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

          ldy # 0
          sty REFP0
          sty REFP1
          sty GRP0
          sty GRP1
          sty VDELP0
          sty VDELP1
          lda #NUSIZ3CopiesClose
          sta NUSIZ0
          sta NUSIZ1

          stx WSYNC
          lda SignpostBG
          sta COLUBK
          lda SignpostFG
          sta COLUP0
          sta COLUP1

          lda # 5
          sta SignpostTextLine  ; each screen is 5 lines

NextTextLine:

          ldy # 8               ; each line is 9 bytes
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
          ;; ldy # 0   ; Y already = 0 here
          .SkipLines 3
          sty COLUBK

          lda AlarmCountdown      ; require 1-2s to tick before accepting button press; see #140
          bne DoneButtons

          lda NewButtons
          beq DoneButtons

          and #ButtonI
          bne DoneButtons

GetNextMode:
          ldy # (9 * 5)         ; length of text, skip over to command/mode byte
          lda (SignpostText), y
          sta GameMode

DoneButtons:
          lda NewSWCHB
          beq DoneSwitches

          and #SWCHBReset
          bne DoneSwitches

          .FarJMP SaveKeyBank, ServiceAttract

DoneSwitches:
          lda GameMode
          cmp #ModeSignpost
          bne Leave

          .WaitScreenBottom
          jmp Loop
;;; 
Leave:
          ldy # (9 * 5) + 1     ; length of text + command byte

          cmp #ModeSignpostDone
          beq ByeBye

          cmp #ModeSignpostSetFlag
          beq SetFlag

          cmp #ModeSignpostClearFlag
          beq ClearFlag

          cmp #ModeTrainLastMove
          beq TrainLastMove

          cmp #ModeSignpostSet0And63
          beq SetFlags0And63

          cmp #ModeSignpostWarp
          beq Warp

          cmp #ModeSignpostPotions
          beq GetPotions

          cmp #ModeSignpostPoints
          beq GetPoints

          cmp #ModeSignpostInquire
          beq Inquire

          cmp #ModeWinnerFireworks
          .if BANK == $0c
            beq WinnerFireworks
          .else
            beq Break
          .fi

          cmp #ModeSignpostNext
          beq GoNext

Break:
          brk

;;; 
ByeBye:
          .mvy CurrentUtterance, # 0
          sty CurrentUtterance + 1

          .WaitScreenBottom

          jmp GoMap

TrainLastMove:
          lda MovesKnown
          ora #$80
          sta MovesKnown
          gne ByeBye

SetFlag:
          lda (SignpostText), y
          sta Temp
          .SetBitFlag Temp
          jmp ByeBye

ClearFlag:
          lda (SignpostText), y
          sta Temp
          .ClearBitFlag Temp
          jmp ByeBye

GoNext:
          lda (SignpostText), y
          sta SignpostIndex
          .mva GameMode, #ModeSignpost
          .WaitScreenBottom
          jmp Setup

GetPotions:
          lda (SignpostText), y
          adc Potions
          sta Potions

          lda #SoundVictory
          sta NextSound

          .Add16 SignpostText, # 2
          jmp GetNextMode

GetPoints:
          sed
          lda Score
          clc
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
          .Add16 SignpostText, # 3
          jmp GetNextMode

SetFlags0And63:
          sed
          lda Score + 1
          clc
          adc # 4               ; 400 points earned
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

Warp:
ProvinceChange:
;;; Duplicated in Signpost.s and CheckPlayerCollision.s nearly exactly
          .mvx s, #$ff
          .if NTSC == TV
            .SkipLines KernelLines - 180
            jsr Overscan
          .else
            ldx INTIM
            dex
            stx TIM64T
            .WaitScreenBottom
          .fi
          .mva NextSound, #SoundShipSailing
          .FarJSR SaveKeyBank, ServiceSaveProvinceData
          .WaitScreenTopMinus 1, 0

          ldy #(9 * 5) + 1
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

          ldy # 8               ; 9 bytes gets both alternatives
-
          lda (SignpostText), y
          sta SignpostLineCompressed, y
          dey
          bpl -

          ;; Add back to get original signpost index
          ;; for banks above SignpostBank
          ;; see #441
          .if 0 < FirstSignpost
            lda SignpostIndex
            clc
            adc #FirstSignpost
            sta SignpostIndex
          .fi
          .FarJMP AnimationsBank, ServiceInquire

          .bend
;;; 
;;; Overscan is different, we don't have  sound effects nor music and we
;;; don't want Bank 7 to get confused by our speech.
Overscan: .block
          .switch TV
          .case NTSC
            .TimeLines OverscanLines
          .case PAL, SECAM
            .TimeLines OverscanLines + 10
          .endswitch

          jsr PlaySpeech

          .WaitForTimer

          stx WSYNC
          rts
          .bend

;;; Audited 2022-04-18 BRPocock
