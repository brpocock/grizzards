;;; Grizzards Source/Banks/Bank06/Bank06.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $06

          .include "StartBank.s"

          .if DEMO
          .include "Bank06Demo.s"
          .else
          .include "Bank06Game.s"
          .fi

          .include "EndBank.s"
