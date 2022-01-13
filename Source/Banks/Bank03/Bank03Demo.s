;;; Grizzards Source/Banks/Bank03/Bank03Demo.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          .include "Source/Generated/Bank07/SpeakJetIDs.s"

          .include "Font.s"
          .include "FontExtended.s"
          .include "6BitCompression.s"
          .include "DecodeText.s"
          .include "Write12Chars.s"
          .include "Inquire.s"

          .include "AttractStory.s"
          .include "Death.s"
          .include "DrawMonsterGroup.s"
          .include "DrawGrizzard.s"

          .include "MonsterArt.s"
          .include "GrizzardImages.s"
          .include "GrizzardArt.s"
          .include "CombatSpriteTables.s"

          .include "48Pixels.s"
          .include "VSync.s"
          .include "VBlank.s"
          
          .include "Prepare48pxMobBlob.s"
          .include "Random.s"
          
          
DoLocal:
          cpy #ServiceWrite12Chars
          beq Write12Chars
          cpy #ServiceAttractStory
          beq AttractStory
          cpy #ServiceDeath
          beq Death
          cpy #ServiceDrawMonsterGroup
          beq DrawMonsterGroup
          cpy #ServiceDrawGrizzard
          beq DrawGrizzard
          cpy #ServiceInquire
          beq Inquire
          brk
