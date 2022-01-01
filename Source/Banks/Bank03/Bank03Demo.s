;;; Grizzards Source/Banks/Bank03/Bank03Demo.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          .include "Source/Generated/Bank07/SpeakJetIDs.s"

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
          .include "Overscan.s"
          .include "Prepare48pxMobBlob.s"
          .include "Random.s"
          .include "WaitScreenBottom.s"
          
DoLocal:
          cpy #ServiceAttractStory
          beq AttractStory
          cpy #ServiceDeath
          beq Death
          cpy #ServiceDrawMonsterGroup
          beq DrawMonsterGroup
          cpy #ServiceDrawGrizzard
          beq DrawGrizzard
          brk
