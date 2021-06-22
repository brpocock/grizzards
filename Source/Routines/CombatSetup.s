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

          sta CurrentMonsterPointer

          ldy # 15              ; offset of ACC & count
          lda (CurrentMonsterPointer), y
          and #$0f

          ;;  TODO choose a random number between 1 and this max count
          lda # 1
          
          tay

          ;; Zero HP for 5 monsters (we have at least 1), then …
          lda # 0
          ldx # 5
-
          sta EnemyHP + 1, x
          dex
          bne -

          ;; … actually set the HP for monsters present (per .y)
          lda EncounterHP, x
-
          sta EnemyHP, y
          dey
          bne -

          lda # 0              ; flee
          sta MoveSelection

          ;; ignore current switch position until it changes,
          ;; so we aren't reacting to map movement
          lda SWCHA
          sta DebounceSWCHA

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
          
