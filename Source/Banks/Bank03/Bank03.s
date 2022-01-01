;;; Grizzards Source/Banks/Bank03/Bank03.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
	BANK = $03

          .include "StartBank.s"

          .if DEMO
          .include "Bank03Demo.s"
          .else
          .include "Bank03Game.s"
          .fi

          .include "EndBank.s"
