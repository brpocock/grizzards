;;; Grizzards Source/Routines/ConfirmNewGame.s
;;; Copyright © 2022 Bruce-Robert Pocock

ConfirmNewGame:    .block

          lda # 0
          sta DeltaX

          .SetUtterance Phrase_ConfirmNewGame

Loop:
          .WaitScreenBottom
          .WaitScreenTop

          jsr Prepare48pxMobBlob

          .ldacolu COLGREEN, $0
          stx WSYNC
          sta COLUBK

          .ldacolu COLGREEN, $e
          sta COLUP0
          sta COLUP1

          ldx # 6
-
          lda NameEntryBuffer - 1, x
          sta StringBuffer - 1, x
          dex
          bne -

          .FarJSR TextBank, ServiceDecodeAndShowText

          jsr FindGrizzardName
          jsr ShowPointerText

          .SkipLines KernelLines / 3

          .ldacolu COLGREEN, $0
          ldx DeltaX
          bne +
          .ldacolu COLMAGENTA, $4
+
          stx WSYNC
          sta COLUBK

          .SetPointer ChangeText
          jsr ShowPointerText
          .SkipLines 2

          .ldacolu COLINDIGO, $4
          ldx DeltaX
          bne +
          .ldacolu COLGREEN, $0
+
          stx WSYNC
          sta COLUBK

          .SetPointer BeginText
          jsr ShowPointerText
          .SkipLines 2

          .ldacolu COLGREEN, $0
          stx WSYNC
          sta COLUBK

          lda NewSWCHB
          beq DoneSwitches
          and #SWCHBSelect
          bne DoneSelect

          lda DeltaX
          eor # 1
          sta DeltaX

DoneSelect:
          lda NewSWCHB
          and #SWCHBReset
          bne DoneSwitches
          .WaitScreenBottom
          jmp GoColdStart

DoneSwitches:       
          lda NewSWCHA
          beq DoneStick
          and #P0StickUp
          bne DoneUp

          lda # 0
          sta DeltaX
DoneUp:
          lda NewSWCHA
          and #P0StickDown
          bne DoneDown

          lda # 1
          sta DeltaX
DoneDown:
DoneStick:
          lda NewButtons
          beq DoneButtons
          and #PRESSED
          bne DoneButtons

          lda #ModeStartGame
          ldx DeltaX
          bne +
          lda #ModeEnterName
+
          sta GameMode

DoneButtons:

          lda GameMode
          cmp #ModeConfirmNewGame
          bne Leave

          jmp Loop

Leave:
          rts

          .bend
