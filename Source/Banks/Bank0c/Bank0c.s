;;; Grizzards Source/Banks/Bank0c/Bank0c.s
;;; Copyright © 2021 Bruce-Robert Pocock
          BANK = $0c

          .include "StartBank.s"

          .include "SpeakJetIDs.s" ; from this bank, not bank 7

          .align $100, "font"
          .include "Font.s"
          .include "FontExtended.s"

DoLocal:
          .include "Signpost.s"

          .include "VSync.s"
          .include "VBlank.s"
          .include "Random.s"
          .include "48Pixels.s"
          .include "DecodeText.s"

          .include "SignpostText.s"
          .include "SignpostSpeech.s"
          .include "SpeakJetIndex.s"

          .include "PlaySpeech.s"

          .include "EndBank.s"
