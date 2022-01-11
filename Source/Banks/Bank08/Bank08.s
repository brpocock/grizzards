;;; Grizzards Source/Banks/Bank08/Bank08.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $08

          .include "StartBank.s"


          .include "SpeakJetIDs.s" ; from this bank, not bank 7


DoLocal:
          .include "Signpost.s"
          .include "SignpostIndex.s" ; only in bank 8

          .include "VSync.s"
          .include "VBlank.s"
          .include "Random.s"
          .include "48Pixels.s"

          .include "SignpostText.s"
          .include "SignpostSpeech.s"
          .include "SpeakJetIndex.s"

          .include "PlaySpeech.s"

          .include "EndBank.s"
