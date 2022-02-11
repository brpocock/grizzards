;;; Grizzards Source/Routines/CombatSetup.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
;;; Common combat routines called from multiple banks
DoCombat:          .block
          stx WSYNC
          .WaitScreenTop
          .KillMusic

          jsr SeedRandom
          
          ldx CurrentCombatEncounter
          lda EncounterMonster, x
          sta CurrentMonsterNumber

SetUpMonsterPointer:
          ldy # 0
          sta CurrentMonsterPointer
          sty CurrentMonsterPointer + 1

          ldx # 4
-
          clc
          asl CurrentMonsterPointer
          rol CurrentMonsterPointer + 1
          dex
          bne -

          clc
          lda CurrentMonsterPointer
          adc #<Monsters
          bcc +
          inc CurrentMonsterPointer + 1
+
          sta CurrentMonsterPointer
          clc
          lda CurrentMonsterPointer + 1
          adc #>Monsters
          sta CurrentMonsterPointer + 1

AnnounceMonsterSpeech:
          lda #>MonsterPhrase
          sta CurrentUtterance + 1
          lda #<MonsterPhrase
          ldx CurrentCombatEncounter
          ;; clc ; unneeded, the adc #>Monsters won't have overflowed
          adc EncounterMonster, x
          sta CurrentUtterance
          
SetUpMonsterHP:     
          ldy #MonsterHPIndex
          lda (CurrentMonsterPointer), y
          sta Temp

          lda Potions
          bpl NotCrowned
          asl Temp
NotCrowned:
          ldy CombatMajorP
          beq NoHPBoost
          asl Temp
          bcc NoHPBoost
          lda #$ff
          sta Temp
NoHPBoost:

          lda EncounterQuantity, x
          tay

          ;; Zero HP for 5 monsters (we have at least 1), then …
          lda # 0
          ldx # 5
-
          sta MonsterHP, x
          dex
          bne -

          ;; … actually set the HP for monsters present (per .y)
          lda Temp
-  
          sta MonsterHP - 1, y
          dey
          bne -
                    
SetUpOtherCombatVars:         
          ;; Y = 0 from above
          sty WhoseTurn         ; Player's turn
          sty MoveAnnouncement
          sty StatusFX
          tya
          ldx #6
-
          sty EnemyStatusFX - 1, x
          dex
          bne -

          ;; fall through to CombatIntroScreen, which does WaitScreenBottom
          .bend
