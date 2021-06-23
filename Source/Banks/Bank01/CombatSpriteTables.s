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
          .byte 0               ; 0 0 0
          .byte $70             ; 0 0 1
          .byte $50             ; 0 1 0
          .byte $50             ; 0 1 1
          .byte $30             ; 1 0 0
          .byte $30             ; 1 0 1
          .byte $30             ; 1 1 0
          .byte $30             ; 1 1 1

