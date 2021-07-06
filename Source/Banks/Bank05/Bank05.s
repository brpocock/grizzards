;;; Grizzards Source/Banks/Bank05/Bank05.s
;;; Copyright © 2021 Bruce-Robert Pocock
          BANK = $05

          ;; Combat for encounters $80 … $ff
          
          .include "StartBank.s"
          .include "Prepare48pxMobBlob.s"
          .include "SpeakJetIDs.s"

DoLocal:  
          .include "CombatSetup.s"
          .include "CombatMainScreen.s"
          .include "GrizzardStatsScreen.s"
          .include "CombatAnnouncementScreen.s"
          .include "CombatOutcomeScreen.s"
          .align $200, $ea      ; filler TODO
          .include "ExecuteCombatMove.s"

          .include "ShowMonsterName.s"

          .include "VSync.s"
          .include "VBlank.s"
          .include "Overscan.s"
          .include "Random.s"
          .include "48Pixels.s"
          .include "MoveEffects.s"

          .include "Combat5.s"
          .include "Monsters5.s"
          .include "MonsterMoves5.s"

          .include "EndBank.s"
