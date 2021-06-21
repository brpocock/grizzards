          BANK = $06

          ;; Combat for encounters $00 … $7f
          
          .include "StartBank.s"
          .include "Prepare48pxMobBlob.s"

DoLocal:  
          .include "Combat.s"
          .include "CombatMainScreen.s"
          .include "GrizzardStatsScreen.s"
          .include "CombatAnnouncementScreen.s"
          
          .include "VSync.s"

          .include "48Pixels.s"
          .include "Combat6.s"

          .align $100
          .include "Monsters6.s"
          
          .align $100
          .include "MonsterArt6.s"


          .include "EndBank.s"
