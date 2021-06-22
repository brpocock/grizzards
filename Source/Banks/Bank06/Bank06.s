          BANK = $06

          ;; Combat for encounters $00 … $7f
          
          .include "StartBank.s"
          .include "Prepare48pxMobBlob.s"

DoLocal:  
          .include "CombatSetup.s"
          .include "CombatMainScreen.s"
          .include "GrizzardStatsScreen.s"
          .include "CombatAnnouncementScreen.s"
          .align $200, $ea      ; filler TODO
          .include "ExecuteCombatMove.s"
          
          .include "VSync.s"
          .include "Random.s"
          .include "48Pixels.s"
          .include "Combat6.s"
          .include "CombatSpriteTables.s"
          .include "MoveEffects.s"

          .align $100
          .include "Monsters6.s"
          
          .align $100
          .include "MonsterArt6.s"


          .include "EndBank.s"
