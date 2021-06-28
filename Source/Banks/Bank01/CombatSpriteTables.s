;;; Grizzards Source/Banks/Bank01/CombatSpriteTables.s
;;; Copyright © 2021 Bruce-Robert Pocock
;;; Combat sprite tables
          
SpritePresence:
          .byte 0                ; 0 0 0
          .byte NUSIZNorm        ; 0 0 1
          .byte NUSIZNorm        ; 0 1 0
          .byte NUSIZ2CopiesMed  ; 0 1 1
          .byte NUSIZNorm        ; 1 0 0
          .byte NUSIZ2CopiesWide ; 1 0 1
          .byte NUSIZ2CopiesMed  ; 1 1 0
          .byte NUSIZ3CopiesMed  ; 1 1 1

SpritePosition:
          .byte $02             ; 0 0 0
          .byte $05             ; 0 0 1
          .byte $04             ; 0 1 0
          .byte $04             ; 0 1 1
          .byte $03             ; 1 0 0
          .byte $03             ; 1 0 1
          .byte $03             ; 1 1 0
          .byte $03             ; 1 1 1
