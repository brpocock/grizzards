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
          cpy #$fe
          beq JatibuFE
          cpy #$ff
          beq JatibuFF
          brk

JatibuCode:
          .byte P0StickUp, P0StickUp, P0StickDown, P0StickDown
          .byte P0StickLeft, P0StickRight, P0StickLeft, P0StickRight
          .byte 0

JatibuFE:
                    ;; No Jatibu code if either difficulty switch is in A/Expert
          lda SWCHB
          and #SWCHBP0Advanced | SWCHBP1Advanced
          bne NoJatibu

          ;; Did they already complete it?
          ldx SelectJatibuProgress
          cmp #$ff
          beq SkipStick

          ;; Check for the next step in the sequence
          lda NewSWCHA
          beq SkipStick         ; no movement, ignore
          and # P0StickLeft | P0StickRight | P0StickUp | P0StickDown
          cmp # P0StickLeft | P0StickRight | P0StickUp | P0StickDown
          beq SkipStick

          and JatibuCode, x
          cmp JatibuCode, x
          ;; if they're wrong, reset the code sequence
          beq NoJatibu

          ;; Success, did that complete the sequence?
          inx
          stx SelectJatibuProgress
          lda JatibuCode, x
          beq JatibuEntered

          lda # SoundChirp
          gne +
JatibuEntered:
          ldx #$ff
          stx SelectJatibuProgress
          lda # SoundVictory
+
          sta NextSound
          gne SkipStick

          ;; Land here if they have already completed the code
          ;; Any further stick action "breaks out" of the sequence
JatibuDone:
          lda NewSWCHA
          and #P0StickLeft | P0StickRight | P0StickUp | P0StickDown
          cmp #P0StickLeft | P0StickRight | P0StickUp | P0StickDown
          beq SkipStick

          ;; Either  they've failed  to enter  the Jatibu  Code or  they
	;; haven't tried
NoJatibu:
          ldx # 0
          stx SelectJatibuProgress

          ldy # 1
          rts
SkipStick:
          ldy # 0
          rts
          
JatibuFF: 
          ldx SelectJatibuProgress
          cpx #$ff
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
          .if ARIA
          .include "Aria-EEPROM-Driver.s"
          .else
          .include "AtariVox-EEPROM-Driver.s"
          .fi
          .fi

          

          .include "SpriteColor.s"

ShowPointerText:
          jsr CopyPointerText
          .FarJMP TextBank, ServiceDecodeAndShowText ; tail call

	.include "EndBank.s"
