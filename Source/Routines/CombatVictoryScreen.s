;;; Grizzards Source/Routines/CombatVictoryScreen.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CombatVictoryScreen:  .block
          .if !NOSAVE

          lda GrizzardXP
          cmp # GrizzardMetamorphosisXP
          blt AfterMetamorphosis

          .FarJSR MapServicesBank, ServiceGrizzardMetamorphoseP

          cpy # 0
          beq AfterMetamorphosis

DoesMetamorphose:
          .if DEMO
          ;; No room for metamorphosis screen!
          ;; This logic is mostly duplicated in GrizzardMetamorphosis.s

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

          jmp AfterMetamorphosis

          .else

          sty NextMap
          .FarJMP AnimationsBank, ServiceGrizzardMetamorphosis

          .fi

          .fi                   ; !NOSAVE

AfterMetamorphosis:
          .SetUtterance Phrase_Victory

          ldy # 0
          sty DeltaY

          .if !DEMO

          lda Potions
          cmp # 99
          bge AfterPotions

          jsr Random
          and #$03
          bne AfterPotions

          lda # 1
          sta DeltaY

          inc Potions

          .SetUtterance Phrase_VictoryWithPotion

          .fi

AfterPotions:
          lda CurrentCombatEncounter
          cmp # 92               ; Boss Bear Battle
          beq WonGame
          ;; after Boss Bear are the 3 dragons
          bge DefeatDragon

NormalVictory:
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

          .SkipLines KernelLines / 5

          lda DeltaY
          beq DonePrintingPotions

          .SetPointer PotionText
          jsr CopyPointerText
          jsr DecodeAndShowText

          .SetPointer PotionText + 6
          jsr CopyPointerText
          jsr DecodeAndShowText

DonePrintingPotions:

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

          lda ProvinceFlags + 6
          and #%00011100        ; Dragon Bits
          cmp #%00011100
          bne NormalVictory

          .FarJMP StretchBank, ServiceRevealBear
          
WonGame:
          lda # 103             ; Game_Won
          sta SignpostIndex
          lda #ModeSignpost
          sta GameMode
          .WaitScreenBottom
          ldx #SignpostBank
          jmp FarCall
           
          .bend
