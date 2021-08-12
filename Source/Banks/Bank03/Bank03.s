;;; Grizzards Source/Banks/Bank03/Bank03.s
;;; Copyright © 2021 Bruce-Robert Pocock
	BANK = $03

          .include "StartBank.s"

          .if DEMO

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

          .else
DoLocal:
          .include "MapSetup.s"
          .include "Map.s"

          .include "MapsProvince1.s"
          .include "Maps1RLE.s"

          .include "PlayerSprites.s"
          .include "MapSprites.s"
          .include "SpriteColor.s"
          .include "Province1.s"

          .include "VSync.s"
          .include "VBlank.s"
          .include "Overscan.s"
          .include "Random.s"
          .include "PlayMusic.s"
          rts

          .include "WaitScreenBottom.s"
          .fi

          .include "EndBank.s"
