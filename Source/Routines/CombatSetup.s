;;; Grizzards Source/Routines/CombatSetup.s
;;; Copyright © 2021 Bruce-Robert Pocock
;;; Common combat routines called from multiple banks
DoCombat:          .block

          jsr VSync
          jsr VBlank

          ldx # 215             ; 181 scan lines
          sta TIM64T

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

AnnounceMonsterSpeech:
          .switch BANK
          .case 5
          lda # >Phrase_Monster5_0
          sta CurrentUtterance + 1
          lda # <Phrase_Monster5_0

          .case 6
          lda # >Phrase_Monster6_0
          sta CurrentUtterance + 1
          lda # <Phrase_Monster6_0

          .default
          .error "What bank am I in?"
          .endswitch
          ldx CurrentCombatEncounter
          clc
          adc EncounterMonster, x
          bcc +
          inc CurrentUtterance + 1
+
          sta CurrentUtterance
          
SetUpMonsterHP:     
          ldy # 14              ; offset of ATK & DEF
          lda (CurrentMonsterPointer), y
          and #$0f
          lda LevelTable, y
          sta Temp
          
          ldy # 15              ; offset of count
          lda (CurrentMonsterPointer), y
          and #$07
          sta Temp
          dec Temp

PickNumMonsters:    
          jsr Random
          and #$07
          beq PickNumMonsters
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
          ldx #6
-
          sta EnemyStatusFX - 1, x
          dex
          bne -

-
          lda INTIM
          bpl -

          ldx # KernelLines - 181
-
          stx WSYNC
          dex
          bne -

          jsr Overscan

          jmp CombatMainScreen

          .bend
