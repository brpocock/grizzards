;;; Grizzards Source/Routines/MapVBlank.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

MapVBlank:        .block
          lda GameMode
          cmp #ModeMap
          beq MovementLogic
          rts

MovementLogic:
          jsr CheckSpriteCollision
          jsr SpriteMovement
          jsr UserInput
          jmp CheckPlayerCollision ; tail call

          .bend
