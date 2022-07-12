;;; Grizzards Source/Routines/MapVBlank.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

MapVBlank:        .block
          lda GameMode
          cmp #ModeMap
          beq MovementLogic

          rts

MovementLogic:

          ;; Ensure last or only sprite is logged properly
          ldx SpriteFlicker
          lda BitMask, x
          ora DrawnSprites
          sta DrawnSprites

          jsr CheckSpriteCollision

          jsr SpriteMovement

          jsr UserInput

          jmp CheckPlayerCollision ; tail call

          .bend

;;; Audited 2022-02-16 BRPocock
