;;; Grizzards Source/Banks/Bank16/Bank16.s
;;; Copyright © 2021-2022, Bruce-Robert Pocock

          BANK = $16

          .include "StartBank.s"

          ;; Combat for encounters $00 … $3f

          .include "Prepare48pxMobBlob.s"
          .include "6BitCompression.s"
          .include "SpeakJetIDs.s"

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

          .include "Combat16.s"
          .include "Monsters16.s"
          .include "MonsterMoves16.s"
          

          .include "EndBank.s"
