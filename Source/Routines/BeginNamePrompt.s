;;; Grizzards Source/Routines/BeginNamePrompt.s
;;; Copyright © 2022 Bruce-Robert Pocock

BeginNamePrompt:
          .enc "minifont"
          .SetUtterance Phrase_EnterName

          lda NameEntryBuffer
          bne BufferReady

          lda #$28              ; blank
          ldx # 5
BlankNameLoop:
          sta NameEntryBuffer, x
          dex
          bne BlankNameLoop

          lda #$0a              ; letter “A”
          sta NameEntryBuffer

BufferReady:
          lda # 0
          sta NameEntryPosition

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
          sta RESBL

          stx WSYNC
          .SleepX 71
          sta HMOVE

          .endp

          jsr Prepare48pxMobBlob

          lda #CTRLPFBALLSZ8
          sta CTRLPF
          lda #ENABLED
          sta ENABL

          .FarJSR TextBank, ServiceDecodeAndShowText

          .SkipLines 3

          ldy # 0
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
          jmp GoColdStart

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

          and # PRESSED
          bne Done

ButtonPressed:
          cpx # 5               ; FIRE in last position is submit
          beq Submit

          ;; FIRE in previous position is advance and
          ;; default to A if the space is blank
          .if !DEMO

            ;; This would be nice, but was cut for space.
            lda # SoundBlip
            sta NextSound

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
          lda #SoundChirp
          sta NextSound

          inc NameEntryBuffer, x
          lda NameEntryBuffer, x
          cmp #" " + 1              ; past end of font
          blt Done

          lda # 0
          sta NameEntryBuffer, x
          geq Done

LetterDec:
          lda #SoundChirp
          sta NextSound

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
          lda #SoundHappy
          sta NextSound

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

            lda #$80 | 25
            sta Potions

            lda # 0
            sta CurrentGrizzard
            .FarJSR SaveKeyBank, ServiceSaveGrizzard

            lda # 1
            sta CurrentGrizzard
            .FarJSR SaveKeyBank, ServiceSaveGrizzard

            lda # 2
            sta CurrentGrizzard
            .FarJSR SaveKeyBank, ServiceSaveGrizzard

            rts

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

;;; Audited 2022-02-15 BRPocock
