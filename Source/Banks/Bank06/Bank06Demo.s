;;; Grizzards Source/Banks/Bank06/Bank06Demo.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          .include "Prepare48pxMobBlob.s"
          .include "6BitCompression.s"
          .include "Source/Generated/Bank07/SpeakJetIDs.s"

          MonsterPhrase = Phrase_Monster6_0

DoVBlankWork:
          .include "CombatVBlank.s"
DoLocal:
          .include "CombatSetup.s"
          ;; falls through to:
          .FarJSR TextBank, ServiceCombatIntro
          ;; on return, falls through to:
          .include "CombatMainScreen.s"

          .include "GrizzardStatsScreen.s"
          .include "CombatAnnouncementScreen.s"
          .include "ExecuteCombatMove.s"
          .include "FindHighBit.s"
          .include "CopyPointerText.s"
          .include "ShowMonsterName.s"

          .include "VSync.s"
          .include "VBlank.s"
          
          .include "Random.s"
          .include "48Pixels.s"
          .include "MoveEffects.s"

          .include "Combat6.s"
          .include "Monsters6.s"
          .include "MonsterMoves6.s"
          
