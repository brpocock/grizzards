;;; Grizzards Source/Routines/RevealBear.s
;;; Copyright © 2022 Bruce-Robert Pocock

RevealBear:         .block

          .WaitScreenBottom

          .ldacolu COLGREY, 0
          sta COLUBK

          lda # 5
          sta DeltaX            ; Using as an animation timer
          lda # 3
          sta AlarmCountdown
WaitForIt:
          .WaitScreenTop

          lda AlarmCountdown
          bne NotReadyYet

          dec DeltaX
          beq BearScare
          lda #SoundBump
          sta NextSound
          lda # 3
          sta AlarmCountdown

NotReadyYet:
          .WaitScreenBottom
          jmp WaitForIt

BearScare:
          lda #SoundRoar
          sta NextSound
          lda # 2
          sta AlarmCountdown
          lda # 0
          sta DeltaX

Raar:
          lda AlarmCountdown
          beq BearPop
          .WaitScreenBottom
          .WaitScreenTop
          jmp Raar

BearPop:
          lda # 1
          sta AlarmCountdown
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
          lda # 1
          sta AlarmCountdown
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

          lda # SoundDrone
          sta NextSound

          lda # 92              ; Boss Bear combat scenario
          sta CurrentCombatEncounter
          lda #$ff
          sta CombatMajorP
          .WaitScreenBottom
          jmp GoCombat

          .bend
