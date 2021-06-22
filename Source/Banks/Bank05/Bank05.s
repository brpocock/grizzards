          BANK = $05

          ;; Combat for encounters $80 … $ff
          
          .include "StartBank.s"
          .include "Prepare48pxMobBlob.s"

DoLocal:  
          .include "CombatSetup.s"
          .include "CombatMainScreen.s"
          .include "GrizzardStatsScreen.s"
          .include "CombatAnnouncementScreen.s"
          
          .include "VSync.s"

          .include "48Pixels.s"
          .include "Combat5.s"
          .include "CombatSpriteTables.s"
          .include "MoveEffects.s"

          .align $100
          .include "Monsters5.s"
          
          .align $100
          .include "MonsterArt5.s"


          .include "EndBank.s"
