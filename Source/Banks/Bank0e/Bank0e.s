;;; Grizzards Source/Banks/Bank0e/Bank0e.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $0e

          .include "StartBank.s"
          .include "SpeakJetIndex.s"

DoLocal:
          cpy #ServiceRevealBear
          beq RevealBear
          cpy #ServiceFireworks
          beq WinnerFireworks
          brk

          .include "VSync.s"
          .include "VBlank.s"
          .include "Random.s"
          .include "48Pixels.s"

          .include "FinalText.s"
          .include "BossBear.s"
          .include "RevealBear.s"
          .include "BossBearDies.s"
          .include "Fireworks.s"
          .include "WinnerFireworks.s"

          .include "PlaySpeech.s"

          .include "EndBank.s"
