;;; Grizzards Source/Banks/Bank0f/Bank0f.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $0f

          .include "StartBank.s"

          .include "Source/Generated/Bank07/SpeakJetIDs.s"
          .include "6BitCompression.s"

          .include "Font.s"
          .include "FontExtended.s"

          ;; these have some annoying alignment requirements
          ;; keep them early to avoid adjusting it too often
          .include "Write12Chars.s"

          .include "DecodeText.s"
          .include "Inquire.s"
          .include "AttractStory.s"
          .include "DrawGrizzard.s"

          .include "CombatVBlank.s"

          .include "48Pixels.s"
          .include "VSync.s"
          .include "VBlank.s"
          
          .include "Prepare48pxMobBlob.s"
          .include "Random.s"

          .include "CopyPointerText.s"
          .include "ShowPointerText.s"

DoLocal:
          cpy #ServiceDrawGrizzard
          beq DrawGrizzard

          cpy #ServiceWrite12Chars
          beq Write12Chars

          cpy #ServiceCombatVBlank
          beq CombatVBlank

          cpy #ServiceAttractStory
          beq AttractStory

          cpy #ServiceInquire
          beq Inquire

          cpy #ServiceFinalScore
          beq FinalScore

          cpy #ServiceGrizzardMetamorphosis
          beq GrizzardMetamorphosis

          cpy #ServiceDeath
          beq Death

          cpy #ServiceConfirmErase
          beq ConfirmErase

          .if ATARIAGESAVE
            cpy #ServiceHighScore
            beq HighScore
          .fi

          brk

          .include "GrizzardMetamorphosis.s"
          .include "ConfirmErase.s"
          .include "Death.s"
          .include "FinalScore.s"
          .if ATARIAGESAVE
            .include "HighScore.s"
          .fi
          .include "AttractBestiary.s"
          .include "AttractChallenge.s"

          .include "DecodeScore.s"
          .include "CopyPointerText12.s"

          .include "GrizzardImages.s"
          .include "GrizzardArt.s"

          .include "EndBank.s"
