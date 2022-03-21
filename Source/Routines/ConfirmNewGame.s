;;; Grizzards Source/Routines/ConfirmNewGame.s
;;; Copyright © 2022 Bruce-Robert Pocock

ConfirmNewGame:    .block

          ldy # 0
          sty DeltaX            ; confirm? 0 = change

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
          ldx DeltaX            ; confirm? 0 = change
          bne +
          .ldacolu COLMAGENTA, $4
+
          stx WSYNC
          sta COLUBK

          .SetPointer ChangeText
          jsr ShowPointerText

          .SkipLines 2

          .ldacolu COLINDIGO, $4
          ldx DeltaX            ; confirm? 0 = change
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

          lda DeltaX            ; confirm? 0 = change
          eor # 1
          sta DeltaX            ; confirm? 0 = change

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

          ldy # 0
          sty DeltaX            ; confirm? 0 = change
          .mva NextSound, #SoundChirp
DoneUp:
          lda NewSWCHA
          and #P0StickDown
          bne DoneDown

          .mva DeltaX, # 1            ; confirm? 0 = change
          .mva NextSound, #SoundChirp
DoneDown:
DoneStick:
          lda NewButtons
          beq DoneButtons

          and #ButtonI
          bne DoneButtons

          .mva NextSound, #SoundBlip
          lda #ModeStartGame
          ldx DeltaX            ; confirm? 0 = change
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

;;; Audited 2022-02-16 BRPocock
