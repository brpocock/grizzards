;;; Grizzards Source/Banks/Bank06/Bank06.s
;;; Copyright © 2021 Bruce-Robert Pocock
          BANK = $06

          ;; Combat for encounters $00 … $7f

          .include "StartBank.s"
          .include "Prepare48pxMobBlob.s"
          .include "SpeakJetIDs.s"
DoVBlankWork:
          .include "CombatVBlank.s"
DoLocal:  
          .include "CombatSetup.s"
          .include "CombatMainScreen.s"
          .include "GrizzardStatsScreen.s"
          .include "CombatAnnouncementScreen.s"
          .include "CombatOutcomeScreen.s"
          .include "ExecuteCombatMove.s"

          .include "ShowMonsterName.s"

          .include "VSync.s"
          .include "VBlank.s"
          .include "Overscan.s"
          .include "Random.s"
          .include "48Pixels.s"
          .include "MoveEffects.s"

          .include "Combat6.s"
          .include "Monsters6.s"          
          .include "MonsterMoves6.s"

          .include "EndBank.s"
