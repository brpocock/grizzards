;;; -*- fundamental -*-
;;; Grizzards Source/Common/MapSprites.s
;;; Copyright © 2021 Bruce-Robert Pocock

          ;;; Sprite art for maps modes

SpriteArt:

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

DoorSprite:
          .byte %11111111
          .byte %10000001
          .byte %10000001
          .byte %10000001
          .byte %10000101
          .byte %10000001
          .byte %11111111
          .byte %00000000

          .byte %11111111
          .byte %10001111
          .byte %10000001
          .byte %10000001
          .byte %10000001
          .byte %10000101
          .byte %11110001
          .byte %00001111

SpriteColor:
          .colu COLGREEN, 8
          .colu COLPURPLE, 8
          .colu COLSPRINGGREEN, 8
          .colu COLGOLD, 4
