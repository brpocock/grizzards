;;; Grizzards Source/Routines/CombatSetup.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
;;; Common combat routines called from multiple banks
DoCombat:          .block
          .if NTSC == TV
            stx WSYNC
          .fi
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
MonsterMul16:
          clc
          asl CurrentMonsterPointer
          rol CurrentMonsterPointer + 1
          dex
          bne MonsterMul16

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
          .mva CurrentUtterance + 1, #>MonsterPhrase
          lda #<MonsterPhrase
          ldx CurrentCombatEncounter
          clc
          adc EncounterMonster, x
          sta CurrentUtterance

SetUpEnemyHP:
          ldy #EnemyHPIndex
          lda (CurrentMonsterPointer), y
          sta MonsterMaxHP

          lda Potions
          bpl NotCrowned

          asl MonsterMaxHP
NotCrowned:
          ldy CombatMajorP
          bpl DoneHPBoost

          asl MonsterMaxHP
          bcc DoneHPBoost

          .mva MonsterMaxHP, #$ff       ; enemy HP max
DoneHPBoost:

          ;; Zero HP for 5 monsters (we have at least 1), then …
          lda # 0
          ldx # 5
ZeroEnemyHP:
          sta EnemyHP, x
          dex
          bne ZeroEnemyHP

          ;; … actually set the HP for monsters present (per Y = quantity)
          ldy EncounterQuantity, x
          lda MonsterMaxHP
FillEnemyHP:
          sta EnemyHP - 1, y
          dey
          bne FillEnemyHP

SetUpMonsterArt:
          ldy # MonsterArtIndex
          lda (CurrentMonsterPointer), y
          sta CurrentMonsterArt

SetUpOtherCombatVars:
          ldy # 0               ; necessary
          sty WhoseTurn         ; Player's turn
          sty MoveAnnouncement
          sty StatusFX
          ldx # 6
ZeroEnemyStatusFX:
          sty EnemyStatusFX - 1, x
          dex
          bne ZeroEnemyStatusFX

          ;; fall through to (far call to) CombatIntroScreen, which does WaitScreenBottom
          .bend
