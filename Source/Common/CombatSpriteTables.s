;;; Grizzards Source/Common/CombatSpriteTables.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
;;; Combat sprite tables

          .if DEMO
            .align $08          ; XXX alignment
          .else
            .align $20          ; XXX alignment
          .fi
SpritePresence:
          .page
          .byte 0                 ; 0 0 0
          .byte NUSIZNorm         ; 1 0 0
          .byte NUSIZNorm         ; 0 1 0
          .byte NUSIZ2CopiesMed  ; 1 1 0
          .byte NUSIZNorm         ; 0 0 1
          .byte NUSIZ2CopiesWide ; 1 0 1
          .byte NUSIZ2CopiesMed  ; 0 1 1
          .byte NUSIZ3CopiesMed  ; 1 1 1
          .endp

;;; Cycle 74 HMOVEs:  (0) -8  -9 -10 -11 -12 -13 -14 -15  ($80)  0  -1  -2  -3  -4  -5  -6  ($f0) -7

SpritePosition:
          .page
          .byte $03             ; 0 0 0
          .byte $03             ; 1 0 0
          .byte $e5             ; 0 1 0
          .byte $03             ; 1 1 0
          .byte $c7             ; 0 0 1
          .byte $03             ; 1 0 1
          .byte $e5             ; 0 1 1
          .byte $03             ; 1 1 1
          .endp

CursorPosition:
          .page
          .byte $33             ; x - -
          .byte $15             ; - x -
          .byte $f7             ; - - x
          .endp
