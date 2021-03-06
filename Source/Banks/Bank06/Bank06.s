;;; Grizzards Source/Banks/Bank06/Bank06.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          BANK = $06

          ;; Combat for encounters $00 … $3f

          .include "StartBank.s"
          .include "Prepare48pxMobBlob.s"
          .include "6BitCompression.s"
          .include "Source/Generated/Bank07/SpeakJetIDs.s"

          MonsterPhrase = Phrase_Monster6_0

DoVBlankWork:
          lda GameMode
          cmp #ModeCombat
          beq +
          rts
+
          .FarJSR TextBank, ServiceFetchGrizzardMove
          ldx Temp
          lda MoveDeltaHP, x
          sta CombatMoveDeltaHP
          .FarJMP CombatServicesBank, ServiceCombatVBlank ; tail call

DoLocal:
          .include "CombatSetup.s"
          ;; falls through to:
          .FarJSR TextBank, ServiceCombatIntro
          ;; on return, falls through to:
          .include "CombatMainScreen.s"
          ;; falls through to:
          .include "CombatAnnouncementScreen.s"

          .include "GrizzardStatsScreen.s"
          .include "ExecuteCombatMove.s"
          .include "CoreAttack.s"
          .include "CoreHealing.s"

          .include "FindHighBit.s"
          .include "CopyPointerText.s"
          .include "ShowMonsterName.s"
          .include "FindMonsterMove.s"

          .include "VSync.s"
          .include "VBlank.s"

          .include "Random.s"
          .include "48Pixels.s"

          .include "MoveEffects.s"
          .include "Combat6.s"
          .include "Monsters6.s"
          .include "MonsterMoves6.s"

          .include "EndBank.s"
