          BANK = $05

          ;; Combat for encounters $80 … $ff
          
          .include "StartBank.s"
          .include "Prepare48pxMobBlob.s"

DoLocal:  
          .include "CombatSetup.s"
          .include "CombatMainScreen.s"
          .include "GrizzardStatsScreen.s"
          .include "CombatAnnouncementScreen.s"
          .include "ExecuteCombatMove.s"
          
          .include "VSync.s"
          .include "Random.s"
          .include "48Pixels.s"
          .include "CombatSpriteTables.s"
          .include "MoveEffects.s"

          .include "Combat5.s"
          .include "Monsters5.s"
          .include "MonsterArt5.s"
          .include "MonsterMoves5.s"

          .include "EndBank.s"
