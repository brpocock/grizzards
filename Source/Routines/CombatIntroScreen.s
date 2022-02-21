;;; Grizzards Source/Routines/CombatIntroScreen.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CombatIntroScreen:  .block

          .mva NextSound, #SoundSweepUp
          .mva AlarmCountdown, # 4

Loop:
          .WaitScreenBottom
          .WaitScreenTop

          stx WSYNC
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

          lda AlarmCountdown
          bne Loop

          rts

          .bend

;;; Audited 2022-02-16 BRPocock
