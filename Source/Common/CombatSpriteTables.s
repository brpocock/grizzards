;;; Grizzards Source/Banks/Bank01/CombatSpriteTables.s
;;; Copyright © 2021 Bruce-Robert Pocock
;;; Combat sprite tables
          
SpritePresence:
          .byte 0                 ; 0 0 0
          .byte NUSIZNorm         ; 1 0 0
          .byte NUSIZNorm         ; 0 1 0
          .byte NUSIZ2CopiesMed  ; 1 1 0
          .byte NUSIZNorm         ; 0 0 1
          .byte NUSIZ2CopiesWide ; 1 0 1
          .byte NUSIZ2CopiesMed  ; 0 1 1
          .byte NUSIZ3CopiesMed  ; 1 1 1

SpritePosition:
          .byte $03             ; 0 0 0
          .byte $03             ; 1 0 0
          .byte $e5             ; 0 1 0
          .byte $03             ; 1 1 0
          .byte $c7             ; 0 0 1
          .byte $03             ; 1 0 1
          .byte $e5             ; 0 1 1
          .byte $03             ; 1 1 1

CursorPosition:
          .byte $03             ; x - -
          .byte $e5             ; - x -
          .byte $c7             ; - - x
