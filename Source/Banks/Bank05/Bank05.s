;;; Grizzards Source/Banks/Bank05/Bank05.s
;;; Copyright © 2021 Bruce-Robert Pocock
          BANK = $05

          .include "StartBank.s"
          
          .if DEMO
          .include "Bank05Demo.s"
          .else
          .include "Bank05Game.s"
          .fi

          .include "EndBank.s"
