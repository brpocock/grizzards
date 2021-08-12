;;; Grizzards Source/Routines/CombatVictoryScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock

          ;; follows CombatSetup

CombatVictoryScreen:  .block

          .SetUtterance Phrase_Victory

          lda #SoundVictory
          sta NextSound

          lda # 8
          sta AlarmCountdown
Loop:
          .WaitScreenTop
          .ldacolu COLGREEN, $6
          sta COLUBK

          .ldacolu COLGRAY, $e
          sta COLUP0
          sta COLUP1

          .SkipLines KernelLines / 3

          jsr Prepare48pxMobBlob

          .SetPointer CombatText
          jsr CopyPointerText
          jsr DecodeAndShowText

          .SetPointer Victory2Text
          jsr CopyPointerText
          jsr DecodeAndShowText

          .WaitScreenBottom

          lda AlarmCountdown
          bne Loop

          lda #ModeMap
          sta GameMode
          jmp GoMap

          .bend
