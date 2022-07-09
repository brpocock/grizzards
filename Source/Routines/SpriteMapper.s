;;; Grizzards Source/Routines/SpriteMapper.s
;;; Copyright © 2022 Bruce-Robert Pocock

SpriteMapper:       .block

          ldx # Province0MapBank
          jmp ReturnFromSpriteMapperToMap

          .fill $100
          .bend
