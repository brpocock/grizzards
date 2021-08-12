;;; Grizzards Source/Routines/CombatIntroScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock

          ;; follows CombatSetup

CombatIntroScreen:  .block

          lda #SoundSweepUp
          sta NextSound

          lda # 4
          sta AlarmCountdown
Loop:
          .WaitScreenTop
          .ldacolu COLRED, $6
          sta COLUBK

          .ldacolu COLGRAY, 0
          sta COLUP0
          sta COLUP1

          .SkipLines KernelLines / 3

          .SetPointer CombatText
          jsr CopyPointerText
          jsr Prepare48pxMobBlob
          jsr DecodeAndShowText

          .WaitScreenBottom

          lda AlarmCountdown
          bne Loop

          rts
          .bend

          ;; falls through to CombatMainScreen
