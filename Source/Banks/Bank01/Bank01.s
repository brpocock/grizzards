;;; Grizzards Source/Banks/Bank01/Bank01.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $01

          ;; Map Services Bank

          .include "StartBank.s"
          .include "Source/Generated/Bank07/SpeakJetIDs.s"

DoVBlankWork:
          .include "MapVBlank.s"

          .include "VSync.s"
          .include "VBlank.s"
          
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
          cpy #ServiceGrizzardStatsScreen
          beq GrizzardStatsScreen
          cpy #ServiceValidateMap
          beq ValidateMap
          cpy #$ff
          beq +
          brk

+
          ldx SelectJatibuProgress
          cmp #$ff
          bne +

          lda # 29
          sta CurrentGrizzard
          lda # 90
          sta GrizzardAttack
          sta GrizzardDefense
          sta MaxHP
          sta CurrentHP
          lda #$ff
          sta MovesKnown
          lda # 0
          sta GrizzardDefense + 1
          lda #$f0
          sta Score + 2
+
          rts

          .include "CopyPointerText.s"
          .include "MapTopService.s"
          .include "NewGrizzard.s"
          .include "Random.s"
          .include "GrizzardStartingStats.s"
          .include "StartNewGame.s"
          .include "DecodeScore.s"

          .include "GrizzardStatsScreen.s"
          .include "GrizzardDepot.s"
          .include "ValidateMap.s"

          .include "CheckSpriteCollision.s"
          .include "CheckPlayerCollision.s"
          .include "SpriteMovement.s"
          .include "UserInput.s"

          .if NOSAVE
          .else
          .include "AtariVox-EEPROM-Driver.s"
          .fi

          

          .include "SpriteColor.s"

ShowPointerText:
          jsr CopyPointerText
          .FarJMP TextBank, ServiceDecodeAndShowText ; tail call

	.include "EndBank.s"
