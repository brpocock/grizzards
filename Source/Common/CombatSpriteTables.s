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

HealthyPF2:
          .byte %00000000
          .byte %10000000
          .byte %11000000
          .byte %11100000
          .byte %11110000
          .byte %11111000
          .byte %11111100
          .byte %11111110

HealthyPF1:
          .byte %00000000
          .byte %00000001
          .byte %00000011
          .byte %00000111
          .byte %00001111
          .byte %00011111
          .byte %00111111
          .byte %01111111

