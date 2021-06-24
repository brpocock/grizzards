;;; -*- fundamental -*-

          ;;; Sprite art for maps modes

SpriteArt:

PersonSprite:
          .byte %00110011
          .byte %00110011
          .byte %00111111
          .byte %00111111
          .byte %11111111
          .byte %00001100
          .byte %00011110
          .byte %00001100

          .byte %01100110
          .byte %01100110
          .byte %00111111
          .byte %11111111
          .byte %00111111
          .byte %00001100
          .byte %00011110
          .byte %00001100

MonsterSprite:
          .byte %11111111
          .byte %11111111
          .byte %01111110
          .byte %00111100
          .byte %00000000
          .byte %00000000
          .byte %00000000
          .byte %00000000

          .byte %11111111
          .byte %11111111
          .byte %11111111
          .byte %01111110
          .byte %00111100
          .byte %00000000
          .byte %00000000
          .byte %00000000

GrizzardDepotSprite:
          .byte %11111111
          .byte %11111111
          .byte %11111111
          .byte %11111111
          .byte %01000010
          .byte %11111111
          .byte %10000001
          .byte %11111111

          .byte %11111111
          .byte %11111111
          .byte %11111111
          .byte %11111111
          .byte %01000010
          .byte %11111111
          .byte %11111111
          .byte %11111111

GrizzardSprite:
          .byte %11000000
          .byte %11100000
          .byte %11101010
          .byte %01110001
          .byte %00111101
          .byte %00011101
          .byte %00001111
          .byte %00000110

          .byte %10100000
          .byte %11100000
          .byte %11110001
          .byte %01110101
          .byte %00111001
          .byte %00011101
          .byte %00001111
          .byte %00000110


SpriteColor:
          .colu COLRED, 8
          .colu COLGREEN, 8
          .colu COLINDIGO, $f
          .colu COLSPRINGGREEN, 8
