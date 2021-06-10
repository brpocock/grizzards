          BANK = $06

          .include "StartBank.s"

          .include "Combat.s"
          
          .include "VSync.s"
          .include "Prepare48pxMobBlob.s"
          .include "ShowPicture.s"
          .include "DecodeText.s"
          .include "ShowText.s"
          .include "48Pixels.s"

          .include "HapriCombat.s"
          .include "CombatIcons.s"

          .align $100
Monsters:
          .include "HapriMonsters.s"
MonsterColors:      
          .include "HapriMonsterColors.s"

          .align $100
          .include "Font.s"

          .include "EndBank.s"
