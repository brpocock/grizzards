;;; Grizzards Source/Banks/Bank1e/Bank1e.s
;;; Copyright © 2022, Bruce-Robert Pocock

          BANK = $1e

          .include "StartBank.s"

DoLocal:
          .include "PlayMusic.s"
          rts

          .include "../../Generated/Bank07/Theme.s"

          .include "EndBank.s"
