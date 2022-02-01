;;; Grizzards Source/Common/CombatSpriteTables.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
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
          .byte $f3             ; x - -
          .byte $f5             ; - x -
          .byte $d7             ; - - x
