;;; Grizzards Source/Banks/Bank01/Bank01.s
;;; Copyright © 2021 Bruce-Robert Pocock
          BANK = $01

          ;; Map Services Bank

          .include "StartBank.s"
          .include "Source/Generated/Bank07/SpeakJetIDs.s"

DoVBlankWork:
          .include "MapVBlank.s"

          .include "VSync.s"
          .include "VBlank.s"
          .include "Overscan.s"
          .include "48Pixels.s"
          .include "Prepare48pxMobBlob.s"
          .include "LearntMove.s"
          .include "Failure.s"

DoLocal:
          cpy #ServiceTopOfScreen
          beq TopOfScreenService
          cpy #ServiceNewGrizzard
          beq NewGrizzard
          cpy #ServiceNewGame
          beq StartNewGame
          cpy #ServiceLearntMove
          beq LearntMove
          cpy #ServiceGrizzardDepot
          beq GrizzardDepot
          brk

          .include "CopyPointerText.s"
          .include "MapTopService.s"
          .include "NewGrizzard.s"
          .include "Random.s"
          .include "GrizzardStartingStats.s"
          .include "StartNewGame.s"
          .include "SetNextAlarm.s"

          .include "GrizzardStatsScreen.s"
          .include "GrizzardDepot.s"


          .include "CheckSpriteCollision.s"
          .include "CheckPlayerCollision.s"
          .include "SpriteMovement.s"
          .include "UserInput.s"

          .include "AtariVox-EEPROM-Driver.s"

	.include "EndBank.s"
