;;; Common combat routines called from multiple banks
DoCombat:          .block

          jsr SeedRandom
          
          ldx CurrentCombatEncounter
          lda EncounterMonster, x

          ;;  Set up the monster pointer
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
          sta EnemyHP, x
          dex
          bne -

          ;; … actually set the HP for monsters present (per .y)
          lda Temp
-  
          sta EnemyHP - 1, y
          dey
          bne -

          lda # 0              ; RUN AWAY
          sta MoveSelection

          ;; ignore current switch position until it changes,
          ;; so we aren't reacting to map movement
          lda SWCHA
          sta DebounceSWCHA

PrepareMonsterArt:  
          
          lda #>MonsterArt
          sta CombatSpritePointer + 1

          ldx # 12              ; offset of art index
          lda Monsters, x
          clc
          asl a
          asl a
          bcc +
          inc CombatSpritePointer + 1
+
          adc #<MonsterArt
          bcc +
          inc CombatSpritePointer + 1
+
          sta CombatSpritePointer
          
          jmp CombatMainScreen

          .bend

ShowPointerText:
          ldy # 0
-
          lda (Pointer), y
          sta StringBuffer, y
          iny
          cpy # 6
          bne -

          ldx #TextBank
          ldy #ServiceDecodeAndShowText
          jmp FarCall
          
