;;; Grizzards Source/Routines/CombatVictoryScreen.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CombatVictoryScreen:  .block
          .if !NOSAVE

          lda GrizzardXP
          cmp # 40
          blt AfterEvolution

          .FarJSR MapServicesBank, ServiceGrizzardEvolveP

          cpy # 0
          beq AfterEvolution

DoesEvolve:
          .if DEMO
          ;; No room for evolution screen!
          ;; This logic is mostly duplicated in GrizzardEvolution.s

          sty NextMap

          ;; Destroy current Grizzard's file
          ;; (also destroys Temp var though)
          ldy # 0
          sty MaxHP
          .FarJSR SaveKeyBank, ServiceSaveGrizzard

          lda NextMap
          sta Temp
          .FarJSR MapServicesBank, ServiceNewGrizzard

          lda NextMap
          sta CurrentGrizzard
          ;; We have to also switch the current Grizzard to the new form
          ;; or if they quit, they'll come back with a zombie Grizzard
          ;; with 0 HP still selected as their current companion.
          .FarJSR SaveKeyBank, ServiceSetCurrentGrizzard

          lda CurrentMap
          sta NextMap

          lda #SoundDepot
          sta NextSound

          jmp AfterEvolution

          .else

          sty NextMap
          .FarJMP EndAnimationsBank, ServiceGrizzardEvolution

          .fi

          .fi                   ; !NOSAVE
AfterEvolution:
          lda CurrentCombatEncounter
          cmp # 92               ; Boss Bear Battle
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
