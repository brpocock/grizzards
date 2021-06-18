          BANK = $06

          .include "StartBank.s"

          .include "Combat.s"
          
          .include "VSync.s"
          .include "Prepare48pxMobBlob.s"
          .include "ShowPicture.s"
          .include "DecodeText.s"
          .include "ShowText.s"
          .include "48Pixels.s"

          .include "Combat6.s"
          .include "GrizzardNames.s"
          .include "GrizzardImages.s"

          .align $100
          .include "Monsters6.s"
          
          .align $100
          .include "MonsterArt6.s"

          .align $100
          .include "Font.s"

          .include "EndBank.s"
