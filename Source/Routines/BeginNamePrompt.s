;;; Grizzards Source/Routines/BeginNamePrompt.s
;;; Copyright © 2022 Bruce-Robert Pocock

BeginNamePrompt:

          .SetUtterance Phrase_EnterName

          lda NameEntryBuffer
          bne BufferReady

          lda #$28              ; blank
          ldx # 5
-
          sta NameEntryBuffer, x
          dex
          bne -

          lda #$0a              ; letter “A”
          sta NameEntryBuffer

BufferReady:
          lda # 0
          sta NameEntryPosition

          .if NTSC != TV
          .WaitScreenBottom
          .SkipLines 1
          jmp FirstTime
          .fi

Loop:
          .WaitScreenBottom
FirstTime:
          .WaitScreenTop

          .ldacolu COLGREEN, 0
          sta COLUBK

          .ldacolu COLGREEN, $f
          sta COLUP0
          sta COLUP1

          .SetPointer EnterText
          jsr ShowPointerText
          .SetPointer YourText
          jsr ShowPointerText
          .SetPointer NameText
          jsr ShowPointerText

          .SkipLines KernelLines / 3

          .ldacolu COLGRAY, $e
          sta COLUBK
          .ldacolu COLGRAY, 0
          sta COLUP0
          sta COLUP1
          .ldacolu COLBLUE, $e
          ldx NameEntryPosition
          cpx # 5
          blt +
          .ldacolu COLPURPLE, $e
+
          sta COLUPF

          ldx # 6
-
          lda NameEntryBuffer - 1, x
          sta StringBuffer - 1, x
          dex
          bne -

          ldx NameEntryPosition
          jmp BeginGrossPosition

          .if 3 == BANK
          ;;.align $00            ; XXX alignment
          .else
          .align $20            ; XXX
          .fi

BeginGrossPosition:
          .page

          stx WSYNC
          .Sleep 13
          lda CursorPositionIndex, x
          and #$0f
          tay

CursorPosGross:
          dey
          bne CursorPosGross
          sta RESBL

          lda CursorPositionIndex, x
          sta HMBL

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

          lda # 0
          sta ENABL

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
          cpx # 5
          beq Submit

          .if !DEMO

          lda # SoundBlip
          sta NextSound

          inc NameEntryPosition
          inx
          lda NameEntryBuffer, x
          cmp #$28              ; blank
          bne Done
          lda #$0a              ; letter “A”
          sta NameEntryBuffer, x

          .fi

          gne Done

LetterInc:
          lda #SoundChirp
          sta NextSound

          inc NameEntryBuffer, x
          lda NameEntryBuffer, x
          cmp #$29              ; past end of font
          blt Done
          lda # 0
          sta NameEntryBuffer, x
          geq Done

LetterDec:
          lda #SoundChirp
          sta NextSound

          dec NameEntryBuffer, x
          lda NameEntryBuffer, x
          cmp #$ff
          bne Done
          lda #$28              ; blank
          sta NameEntryBuffer, x
          gne Done

CursorMoveLeft:
          lda #SoundBlip
          
          dex
          bpl +
          ldx # 0
          lda # 0
+
          sta NextSound
          stx NameEntryPosition
          jmp Done

CursorMoveRight:
          lda #SoundBlip

          inx
          cpx # 5
          blt +
          beq +
          lda # 0
          ldx # 5
+
          sta NextSound
          stx NameEntryPosition
          ;; fall through to Done

Done:     

          jmp Loop

Submit:
          lda #SoundHappy
          sta NextSound

          rts

EnterText:
          .MiniText "ENTER "
YourText:
          .MiniText " YOUR "
NameText:
          .MiniText "  NAME"

CursorPositionIndex:
          .byte $a4
          .byte $15
          .byte $95
          .byte $06
          .byte $77
          .byte $f7

          rts
