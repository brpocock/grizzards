;;; Grizzards Source/Banks/Bank0a/Bank0a.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $0a

          .include "StartBank.s"

          .include "SpeakJetIDs.s" ; from this bank, not bank 7

DoLocal:
          .include "Signpost.s"

          .include "VSync.s"
          .include "VBlank.s"
          .include "Random.s"
          .include "48Pixels.s"

          .include "PlaySpeech.s"

          .include "SignpostText.s"
          .include "SignpostSpeech.s"
          .include "SpeakJetIndex.s"

          .include "EndBank.s"
