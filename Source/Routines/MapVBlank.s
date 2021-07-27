;;; Grizzards Source/Routines/MapVBlank.s
;;; Copyright © 2021 Bruce-Robert Pocock

MapVBlank:        .block
          lda GameMode
          cmp #ModeMap
          beq MovementLogic
          rts

MovementLogic:
          jsr CheckSpriteCollision
          jsr SpriteMovement
          jsr CheckPlayerCollision
          jmp UserInput         ; tail call

          .bend
