;;; Grizzards Source/Routines/ConfirmErase.s
;;; Copyright © 2022 Bruce-Robert Pocock

ConfirmErase:       .block
          .SetUtterance Phrase_ConfirmErase
          ldx # 1
          stx DeltaX            ; current selection = not to erase

          .mva GameMode, #ModeConfirmEraseSlot
Loop:
          .WaitScreenBottom
          .WaitScreenTop
          .ldacolu COLRED, 0
          stx WSYNC
          sta COLUBK
          .ldacolu COLGRAY, $e
          sta COLUP0
          sta COLUP1

          jsr Prepare48pxMobBlob

          .SetPointer EraseQText
          jsr ShowPointerText

          .SkipLines 10

          ldx # 6
CopyNameForPrint:
          lda NameEntryBuffer - 1, x
          sta StringBuffer - 1, x
          dex
          bne CopyNameForPrint

          .FarJSR TextBank, ServiceDecodeAndShowText

          .SetPointer SlotOneText
          jsr CopyPointerText

          ldx SaveGameSlot
          inx
          stx StringBuffer + 5
          .FarJSR TextBank, ServiceDecodeAndShowText

          .SkipLines KernelLines / 4

          .ldacolu COLORANGE, $a
          ldx DeltaX            ; erase? 0 = erase
          beq +
          .ldacolu COLRED, 0
+
          stx WSYNC
          sta COLUBK

          .SetPointer EraseText
          jsr ShowPointerText

          .SkipLines 2

          .ldacolu COLSPRINGGREEN, $a
          ldx DeltaX            ; erase? 0 = erase
          bne +
          .ldacolu COLRED, 0
+
          stx WSYNC
          sta COLUBK

          .SetPointer KeepText
          jsr ShowPointerText

          .SkipLines 2

          .ldacolu COLRED, 0
          stx WSYNC
          sta COLUBK

          lda NewSWCHB
          beq DoneSwitches

          and #SWCHBSelect
          bne DoneSelect

          lda DeltaX            ; erase?
          eor # 1
          sta DeltaX            ; erase?

DoneSelect:
          lda NewSWCHB
          and #SWCHBReset
          bne DoneSwitches

          .WaitScreenBottom
          jmp GoWarmStart

DoneSwitches:
          lda NewSWCHA
          beq DoneStick

          and #P0StickUp
          bne DoneUp

          .mva DeltaX, # 0            ; erase? 0 = erase
          .mva NextSound, #SoundChirp
DoneUp:
          lda NewSWCHA
          and #P0StickDown
          bne DoneDown

          .mva DeltaX, # 1            ; erase? 0 = erase
          .mva NextSound, #SoundChirp
DoneDown:
DoneStick:
          lda NewButtons
          beq DoneButtons

          and #ButtonI
          bne DoneButtons

          .mva NextSound, #SoundBlip
          lda #ModeSelectSlot
          ldx DeltaX            ; erase? 0 = erase
          bne +
          .mva NextSound, #SoundDeleted
          lda #ModeErasing
+
          sta GameMode

DoneButtons:

          lda GameMode
          cmp #ModeConfirmEraseSlot
          bne Leave

          jmp Loop

Leave:
          rts
;;; 
EraseQText:
          .MiniText "ERASE?"
EraseText:
          .MiniText "ERASE "
KeepText:
          .MiniText "KEEP  "
SlotOneText:
          .MiniText "SLOT 1"

          .bend

;;; Audited 2022-02-16 BRPocock
