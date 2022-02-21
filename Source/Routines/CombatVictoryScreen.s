;;; Grizzards Source/Routines/CombatVictoryScreen.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CombatVictoryScreen:  .block
          .if !NOSAVE           ; quite a long section here

          lda GrizzardXP
          cmp # GrizzardMetamorphosisXP
          blt AfterMetamorphosis

          .FarJSR MapServicesBank, ServiceGrizzardMetamorphoseP
          ;; returns with Y = metamorphosis target or zero

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

            .mva Temp, NextMap
            .FarJSR MapServicesBank, ServiceNewGrizzard

            .mva CurrentGrizzard, NextMap
            ;; We have to also switch the current Grizzard to the new form
            ;; or if they quit, they'll come back with a zombie Grizzard
            ;; with 0 HP still selected as their current companion.
            .FarJSR SaveKeyBank, ServiceSetCurrentGrizzard

            .mva NextMap, CurrentMap

            .mva NextSound, #SoundDepot

            ;; jmp AfterMetamorphosis ; fall through

          .else                 ; not the demo

            sty NextMap
            .FarJMP AnimationsBank, ServiceGrizzardMetamorphosis
            ;; returns by calling Victory anew from the top

          .fi

          .fi                   ; !NOSAVE
;;; 
AfterMetamorphosis:
          .SetUtterance Phrase_Victory

          ldy # 0
          sty DeltaY            ; no potion gained

          .if !DEMO

            lda Potions
            cmp #$7f            ; allow up to 127 potions
            bge AfterPotions

            jsr Random
            and #$03
            bne AfterPotions

            .mva DeltaY, #1          ; potion gained

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
          .mva NextSound, #SoundVictory
          .mva AlarmCountdown, # 8
          stx WSYNC
;;; 
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
          jsr ShowPointerText

          .SetPointer Victory2Text
          jsr ShowPointerText

          .SkipLines KernelLines / 5

          lda DeltaY            ; potion gained?
          beq DonePrintingPotions

          .SetPointer PotionText
          jsr ShowPointerText

          .SetPointer PotionText + 6
          jsr ShowPointerText

DonePrintingPotions:
          lda AlarmCountdown
          bne Loop

          .mva GameMode, #ModeMap

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
          .mva SignpostIndex, # 103             ; Game_Won
          .mva GameMode, #ModeSignpost
          .WaitScreenBottom
          ldx #SignpostBank
          jmp FarCall

          .bend

;;; Audited 2022-02-16 BRPocock
