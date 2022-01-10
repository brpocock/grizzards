;;; Grizzards Source/Banks/Bank1f/Bank1f.s
;;; Copyright © 2022, Bruce-Robert Pocock

          BANK = $1f

          .include "StartBank.s"

DoLocal:
          brk


          .include "EndBank.s"
