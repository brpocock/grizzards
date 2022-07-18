;;; Grizzards Source/Routines/SpriteMapperFlicker.s
;;; Copyright © 2022 Bruce-Robert Pocock

SpriteMapper:       .block

Entry:
          ldx # Province0MapBank
          jmp ReturnFromSpriteMapperToMap

          .bend
