;;; Grizzards Source/Routines/CombatVictoryScreen.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          ;; follows CombatSetup

CombatVictoryScreen:  .block
          lda CurrentCombatEncounter
          cmp #92               ; Boss Bear Battle
          beq WonGame
          ;; after Boss Bear are the 3 dragons
          bge DefeatDragon

NormalVictory:
          .SetUtterance Phrase_Victory

          lda #SoundVictory
          sta NextSound

          lda # 8
          sta AlarmCountdown

          stx WSYNC
Loop:
          .WaitScreenBottom
          .WaitScreenTop

          stx WSYNC
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

          lda AlarmCountdown
          bne Loop

          lda #ModeMap
          sta GameMode

          .WaitScreenBottom

          jmp GoMap

DefeatDragon:
          lda CurrentProvince
          cmp # 2
          bne NormalVictory

          lda ProvinceFlags + 5
          and #%00011100        ; Dragon Bits
          cmp #%00011100
          bne NormalVictory

          .FarJMP EndAnimationsBank, ServiceRevealBear
          
WonGame:
          .FarJMP EndAnimationsBank, ServiceFireworks
           
          .bend
