;;; Grizzards Source/Routines/SpriteMapperFlicker.s
;;; Copyright © 2022 Bruce-Robert Pocock

SpriteMapper:       .block

          ldx # Province0MapBank
          jmp ReturnFromSpriteMapperToMap

          .bend
