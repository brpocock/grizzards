;;; Grizzards Source/Banks/Bank01/Bank01.s
;;; Copyright © 2021 Bruce-Robert Pocock
          BANK = $01

          ;; Map Services Bank

	.include "StartBank.s"

DoVBlankWork:
          .include "MapVBlank.s"

          .include "VSync.s"
          .include "VBlank.s"
          .include "Overscan.s"
          .include "48Pixels.s"
          .include "Prepare48pxMobBlob.s"

DoLocal:
          cpy #ServiceTopOfScreen
          beq TopOfScreenService
          cpy #ServiceBottomOfScreen
	beq BottomOfScreenService
          cpy #ServiceFireworks
          beq WinnerFireworks
          cpy #ServiceDrawMonsterGroup
          beq DrawMonsterGroup
          cpy #ServiceNewGrizzard
          beq NewGrizzard
          cpy #ServiceNewGame
          beq StartNewGame
          cpy #ServiceDeath
          beq Death
          brk

          .include "MapTopService.s"
          .include "MapBottomService.s"
          .include "DrawMonsterGroup.s"
          .include "WinnerFireworks.s"
          .include "NewGrizzard.s"
          .include "Random.s"
          .include "Death.s"
          .include "MonsterArt.s"
          .include "CombatSpriteTables.s"
          .include "GrizzardStartingStats.s"
          .include "StartNewGame.s"
          
          .include "AtariVox-EEPROM-Driver.s"

	.include "EndBank.s"
