;;; Grizzards Source/Banks/Bank0f/Bank0f.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $0f

          .include "StartBank.s"

          .include "Source/Generated/Bank07/SpeakJetIDs.s"

          .include "AttractStory.s"
          .include "Death.s"
          .include "DrawMonsterGroup.s"
          .include "WinnerFireworks.s"
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

DoLocal:
          cpy #ServiceAttractStory
          beq AttractStory
          cpy #ServiceDeath
          beq Death
          cpy #ServiceDrawMonsterGroup
          beq DrawMonsterGroup
          cpy #ServiceFireworks
          beq WinnerFireworks
          cpy #ServiceDrawGrizzard
          beq DrawGrizzard
          brk

          .include "WaitScreenBottom.s"

          .include "EndBank.s"
