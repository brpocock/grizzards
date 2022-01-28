;;; Grizzards Source/Banks/Bank0d/Bank0d.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $0d

          .include "StartBank.s"

DoLocal:
          cpy #ServiceDrawStarter
          beq DrawStarter
          cpy #ServiceChooseGrizzard
          cpy #ServiceConfirmNewGame
          cpy #ServiceUnerase
          cpy #ServiceConfirmErase
          cpy #ServiceDrawBoss
          brk

          .include "DrawStarter.s"
          .include "ShowPicture.s"
          .include "VSync.s"
          .include "VBlank.s"
          .include "Random.s"
          .include "48Pixels.s"

          .align $100
          .include "Grizzard0-0.s"
          .align $100
          .include "Grizzard0-1.s"
          .align $100
          .include "Grizzard1-0.s"
          .align $100
          .include "Grizzard1-1.s"
          .align $100
          .include "Grizzard2-0.s"
          .align $100
          .include "Grizzard2-1.s"


          .include "EndBank.s"
