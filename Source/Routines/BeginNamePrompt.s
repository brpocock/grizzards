;;; Grizzards Source/Routines/BeginNamePrompt.s
;;; Copyright © 2022 Bruce-Robert Pocock

BeginNamePrompt:
          .enc "minifont"
          .SetUtterance Phrase_EnterName

          lda NameEntryBuffer
          bpl BufferReady

ClearName:
          lda #" "
          ldx # 5
BlankNameLoop:
          sta NameEntryBuffer, x
          dex
          bne BlankNameLoop

          lda #"A"
          sta NameEntryBuffer

BufferReady:
          ldy # 0               ; XXX necessary?
          sty NameEntryPosition

          .if NTSC != TV
            .WaitScreenBottom
            .SkipLines 1
            jmp LoopFirst
          .fi

Loop:
          .WaitScreenBottom
LoopFirst:
          .WaitScreenTop

          .ldacolu COLGREEN, 0
          sta COLUBK

          .ldacolu COLGREEN, $f
          sta COLUP0
          sta COLUP1

ShowEnterYourName:
          .SetPointer EnterText
          jsr ShowPointerText

          .SetPointer YourText
          jsr ShowPointerText

          .SetPointer NameText
          jsr ShowPointerText

          .SkipLines KernelLines / 3

NameEntryBox:
          .ldacolu COLGRAY, $e
          sta COLUBK
          .ldacolu COLGRAY, 0
          sta COLUP0
          sta COLUP1

          .ldacolu COLBLUE, $e
          ldx NameEntryPosition
          cpx # 5
          blt DoneCursorColor
          .ldacolu COLPURPLE, $e
DoneCursorColor:
          sta COLUPF

          ldx # 6
CopyNameLoop:
          lda NameEntryBuffer - 1, x
          sta StringBuffer - 1, x
          dex
          bne CopyNameLoop

          ldx NameEntryPosition
          jmp BeginGrossPosition

          .if 3 == BANK && NTSC == TV
            .align $10            ; XXX alignment
          .else
            .align $20            ; XXX alignment
          .fi

BeginGrossPosition:
          .page

          stx WSYNC
          .Sleep 10
          lda CursorPositionIndex, x
          sta HMBL
          and #$0f
          tay

CursorPosGross:
          dey
          bne CursorPosGross

          stx RESBL

          stx WSYNC
          .SleepX 71
          stx HMOVE

          .endp

          jsr Prepare48pxMobBlob

          .mva CTRLPF, #CTRLPFBALLSZ8
          .mva ENABL, #ENABLED

          .FarJSR TextBank, ServiceDecodeAndShowText

          .SkipLines 3

          ;; ldy # 0; Y = 0 since CursorPosGross
          sty ENABL

          .SkipLines 3

          .ldacolu COLGREEN, 0
          sta COLUBK

          ldx NameEntryPosition

          lda NewSWCHB
          beq DoneSwitches

          and #SWCHBReset
          bne DoneSwitches

          .WaitScreenBottom
          jmp GoWarmStart

DoneSwitches:
          lda NewSWCHA
          beq NoStick

          .BitBit P0StickUp
          beq LetterInc

          .BitBit P0StickDown
          beq LetterDec

          .BitBit P0StickLeft
          beq CursorMoveLeft

          .BitBit P0StickRight
          beq CursorMoveRight

NoStick:
          lda NewButtons
          beq Done

          and #ButtonI
          bne Done

ButtonPressed:
          cpx # 5               ; FIRE in last position is submit
          beq Submit

          ;; FIRE in previous position is advance and
          ;; default to A if the space is blank
          .if !DEMO

            ;; XXX This would be nice, but was cut for space.
            .mva NextSound, #SoundBlip

            inc NameEntryPosition
            inx
            lda NameEntryBuffer, x
            cmp #" "
            bne Done

            lda #"A"
            sta NameEntryBuffer, x

          .fi

          gne Done

LetterInc:
          .mva NextSound, #SoundChirp

          inc NameEntryBuffer, x
          lda NameEntryBuffer, x
          cmp #" " + 1              ; past end of font
          blt Done

          lda # 0
          sta NameEntryBuffer, x
          geq Done

LetterDec:
          .mva NextSound, #SoundChirp

          dec NameEntryBuffer, x
          lda NameEntryBuffer, x
          bpl Done

          ;; wrapped around to negative, advance to space
          lda #" "
          sta NameEntryBuffer, x
          gne Done

CursorMoveLeft:
          lda #SoundBlip

          dex
          bpl DoneMovingLeft

          ;; wrapped around, stop at zero instead
          ldx # 0
          txa                   ; no sound either
DoneMovingLeft:
          sta NextSound
          stx NameEntryPosition
          jmp Done

CursorMoveRight:
          lda #SoundBlip

          inx
          cpx # 6               ; one past end
          blt DoneMovingRight

          ldx # 5               ; stop in last position
          lda # 0               ; no sound
DoneMovingRight:
          sta NextSound
          stx NameEntryPosition
          ;; fall through to Done
Done:
          jmp Loop
;;; 
Submit:
          .mva NextSound, #SoundHappy

          .if !DEMO

            ;; Easter Egg, enter KINGME to start at the
            ;; "second quest" / "new game plus" level of
            ;; difficulty with 3 starter Grizzards

            ldx # 6
CompareKingMe:
            lda NameEntryBuffer - 1, x
            cmp SecondQuest - 1, x
            bne FirstQuest

            dex
            bne CompareKingMe

            .mva Potions, #$80 | 25
            .mva CurrentGrizzard, # 0
            .FarJSR SaveKeyBank, ServiceSaveGrizzard

            .mva CurrentGrizzard, # 1
            .FarJSR SaveKeyBank, ServiceSaveGrizzard

            .mva CurrentGrizzard, # 2
            .FarJSR SaveKeyBank, ServiceSaveGrizzard

            .mva NextSound, # SoundVictory
            jmp ClearName

FirstQuest:
            ldy # 0
            sty Potions
          .fi

          rts
;;; 
EnterText:
          .MiniText "ENTER "
YourText:
          .MiniText " YOUR "
NameText:
          .MiniText "  NAME"

          .if !DEMO
SecondQuest:
           .MiniText "KINGME"
          .fi
;;; 
CursorPositionIndex:
          .byte $a4
          .byte $15
          .byte $95
          .byte $06
          .byte $77
          .byte $f7

          .enc "none"
          rts

;;; Audited 2022-02-16 BRPocock
