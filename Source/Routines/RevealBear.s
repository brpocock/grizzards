;;; Grizzards Source/Routines/RevealBear.s
;;; Copyright © 2022 Bruce-Robert Pocock

RevealBear:         .block

          .WaitScreenBottom

          .ldacolu COLGREY, 0
          sta COLUBK

          .mva DeltaX, # 5      ; Using as an animation timer
          .mva AlarmCountdown, # 3
WaitForIt:
          .WaitScreenTop

          lda AlarmCountdown
          bne NotReadyYet

          dec DeltaX
          beq BearScare

          .mva NextSound, #SoundBump
          .mva AlarmCountdown, # 3
NotReadyYet:
          .WaitScreenBottom
          jmp WaitForIt

BearScare:
          .mva NextSound, #SoundRoar
          .mva AlarmCountdown, # 2
          .mva DeltaX, # 0
Raar:
          lda AlarmCountdown
          beq BearPop

          .WaitScreenBottom
          .WaitScreenTop
          jmp Raar

BearPop:
          .mva AlarmCountdown, # 1
BearLoop:
          .WaitScreenBottom
          .WaitScreenTop
          .if SECAM == TV
            lda #COLRED
          .else
            lda #COLRED
            ora DeltaX
          .fi
          sta COLUBK
          .ldacolu COLGREY, 0
          sta COLUP0
          sta COLUP1

          .SkipLines KernelLines / 3

          jsr ShowBossBear
          
          lda AlarmCountdown
          bne BearLoop

          lda DeltaX
          cmp # $a
          bge BearDelay2

          .mva AlarmCountdown, # 1
          inc DeltaX
          inc DeltaX
          inc DeltaX
          bne BearLoop

BearDelay2:
          .SetPointer BossText
          jsr ShowPointerText

          .SetPointer BearText
          jsr ShowPointerText

          lda NewButtons
          beq BearLoop

          .BitBit PRESSED
          bne BearLoop

          .mva NextSound, # SoundDrone
          .mva CurrentCombatEncounter, # 92 ; Boss Bear combat scenario
          .mva CombatMajorP, #$ff
          .WaitScreenBottom
          jmp GoCombat

          .bend

;;; Audited 2022-02-16 BRPocock
