;;; Grizzards Source/Common/ExecuteCombatMove.s
;;; Copyright © 2021 Bruce-Robert Pocock
ExecuteCombatMove:  .block
          lda WhoseTurn
          beq ExecutePlayerMove

ExecuteMonsterMove:
          ldx MoveSelection
          lda MoveTargets, x
          beq MonsterHits

          ;; Determine whether the move is a Hit or Miss first
          ldy #15               ; ACU/HP byte
          lda (CurrentMonsterPointer), y
          and #$f0
          ror a
          ror a
          ror a
          ror a
          tax
          lda LevelTable, x
          tax                   ; Acuity of monster
          
          jsr Random
          and #$0f
          bne +
          dex                   ; critical fail
+
          cmp #$0f
          bne +
          inx                   ; critical success
+
          ldy WhoseTurn
          lda EnemyStatusFX - 1, y
          and #StatusAcuityDown
          bne +
          txa
          ror a
          tax
+
          lda EnemyStatusFX - 1, y
          and #StatusAcuityUp
          bne +
          txa
          asl a
          tax
+
          stx Temp

          lda GrizzardDefense

          cmp Temp
          bpl MonsterHits

          lda #SoundMiss
          sta NextSound

          jmp NextTurn

MonsterHits:
          lda #SoundHit
          sta NextSound

          ldx MoveSelection
          lda MoveEffects, x
          and #MoveEffectsToEnemy
          ora StatusFX
          sta StatusFX

          lda MoveDeltaHP, x
          bmi MonsterBoostHP
          sta Temp
          lda CurrentHP
          sec
          sbc Temp
          bpl +
          lda # 0
+
          sta CurrentHP

          jmp NextTurn

MonsterBoostHP:
          eor #$ff
          clc
          ldx WhoseTurn
          adc MonsterHP - 1, x
          cmp # 99
          bpl +
          lda # 99
+
          sta MonsterHP - 1, x

          rts

ExecutePlayerMove:
          ldx MoveSelection
          lda MoveTargets, x
          beq PlayerHits
          
          ;; Determine whether the move is a Hit or Miss first
          ldx GrizzardAcuity
          jsr Random
          and #$0f
          bne +
          dex                   ; critical fail
+
          cmp #$0f
          bne +
          inx                   ; critical success
+
          lda StatusFX
          and #StatusAcuityDown
          bne +
          txa
          ror a
          tax
+
          lda StatusFX
          and #StatusAcuityUp
          bne +
          txa
          asl a
          tax
+          
          stx Temp

          ldy #14               ; ATK/DEF byte
          lda (CurrentMonsterPointer), y
          and #$0f              ; DEF level
          tay
          lda LevelTable, y

          cmp Temp
          bpl PlayerHits

          lda #SoundMiss
          sta NextSound

          jmp CheckForWin

PlayerHits:
          lda #SoundHit
          sta NextSound
          
          ldx MoveSelection
          lda MoveTargets, x
          beq PlayerTargetsSelf
          cmp #1
          beq PlayerTargetsOne

PlayerTargetsAOE:
          lda MoveEffects, x
          and #MoveEffectsToEnemy
          sta Temp
          ldx # 6
-
          lda EnemyStatusFX - 1, x
          ora Temp
          sta EnemyStatusFX - 1, x
          dex
          bne -

          ldx MoveSelection
          lda MoveDeltaHP, x

          sta Temp
          ldx # 6
-
          lda MonsterHP - 1, x
          sec
          sbc Temp
          bpl +
          lda # 0
+
	sta MonsterHP - 1, x
          dex
          bne -

          jmp PlayerMoveDone

PlayerTargetsOne:
          lda MoveEffects, x
          and #MoveEffectsToEnemy
          sta Temp
          ldx MoveTarget
          lda EnemyStatusFX - 1, x
          ora Temp
          sta EnemyStatusFX - 1, x

          ldx MoveSelection
          lda MoveDeltaHP, x
          bmi PlayerBoostHP

          sta Temp
          ldx MoveTarget
          lda MonsterHP - 1, x
          sec
          sbc Temp
          bpl +
          lda # 0
+
	sta MonsterHP - 1, x

          jmp PlayerMoveDone
          
PlayerTargetsSelf:
          .align $40, $ea
          
PlayerBoostHP:
          ;; .a has the MoveDeltaHP value
          eor #$ff
          clc
          adc CurrentHP
          cmp MaxHP
          bpl +
          lda MaxHP
+
          sta CurrentHP

          ;; jmp PlayerMoveDone ; fall through

PlayerMoveDone:
          ldx MoveSelection
          lda MoveEffects, x
          and #MoveEffectsToSelf
          ora StatusFX
          sta StatusFX
        

          .bend

LevelTable:
          ;; monsters have levels 0…$b for each of their stats
          ;; this table maps those to actual values
          .byte 1, 2, 5, 10,  15, 25, 35, 50
          .byte 60, 70, 80, 90, 99, 99, 99, 99
