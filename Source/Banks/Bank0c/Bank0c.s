;;; Grizzards Source/Banks/Bank0c/Bank0c.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $0c

          .include "StartBank.s"

          .include "SpeakJetIDs.s" ; from this bank, not bank 7

DoLocal:
          .include "Signpost.s"

          .include "WinnerFireworks.s"
          .align $100           ; XXX alignment
          .include "BossBearDies.s"
          .align $20            ; XXX alignment
          .include "ShowPicture.s"

          .include "CopyPointerText.s"
          .include "ShowPointerText.s"
          
          .include "Prepare48pxMobBlob.s"

          .include "VSync.s"
          .include "VBlank.s"
          .include "Random.s"
          .include "48Pixels.s"

          .include "SignpostText.s"
          .include "SignpostSpeech.s"
          .include "SpeakJetIndex.s"

          .include "PlaySpeech.s"

          .if ATARIAGESAVE
            .include "AtariAgeSave-EEPROM-Driver.s"
            .include "AtariVox-EEPROM-Driver-Alt.s"
            ;; must be the last thing in the bank
            .include "AtariAgeBackup.s"
          .fi

          .include "EndBank.s"
