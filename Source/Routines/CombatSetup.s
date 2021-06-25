;;; Grizzards Source/Routines/CombatSetup.s
;;; Copyright © 2021 Bruce-Robert Pocock
;;; Common combat routines called from multiple banks
DoCombat:          .block

          jsr SeedRandom
          
          ldx CurrentCombatEncounter
          lda EncounterMonster, x

SetUpMonsterPointer:          
          ldx #>Monsters
          stx CurrentMonsterPointer + 1
          
          ;; × 16
          ldx #4
-
          clc
          asl a
          bcc +
          inc CurrentMonsterPointer + 1
+
          dex
          bne -

          clc
          adc #<Monsters
          bcc +
          inc CurrentMonsterPointer + 1
+
          sta CurrentMonsterPointer

SetUpMonsterHP:     
          ldy # 14              ; offset of ATK & DEF
          lda (CurrentMonsterPointer), y
          and #$0f
          lda LevelTable, y
          sta Temp
          
          ldy # 15              ; offset of ACC & count
          lda (CurrentMonsterPointer), y
          and #$0f
          sta Temp
          dec Temp

PickNumMonsters:    
          jsr Random
          and #$07
          cmp Temp
          bpl PickNumMonsters
          
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

SetUpMonsterArt:
          ldy # 12              ; art index
          lda (CurrentMonsterPointer), y
          sta CurrentMonsterArt
                    
SetUpOtherCombatVars:         
          lda # 0
          sta MoveSelection     ; RUN AWAY
          sta WhoseTurn         ; Player's turn
          sta MoveTarget        ; no target selected
          sta MoveAnnouncement
          sta DisplayedHP
          ldx #6
-
          sta EnemyStatusFX - 1, x
          dex
          bne -

          ;; ignore current stick position until it changes,
          ;; so we aren't reacting to map movement
          lda SWCHA
          sta DebounceSWCHA

          jmp CombatMainScreen

          .bend

          
