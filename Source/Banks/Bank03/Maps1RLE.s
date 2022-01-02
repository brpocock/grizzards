;;; -*- fundamental -*-
;;; Grizzards Source/Banks/Bank03/Maps1RLE.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; RLE data for each screen layout
;;;
;;; Repeat count, PF0, PF1, PF2
          
Map_FourWay:
          .byte 4,  %11110000, %11111111, %00001111
          .byte 4,  %11110000, %11110000, %00000000
          .byte 4,  %01110000, %00000000, %00000000
          .byte 4,  %00110000, %00000000, %00000000
          .byte 8,  %00010000, %00000000, %00000000
          .byte 26, %00000000, %00000000, %00000000
          .byte 8,  %00010000, %00000000, %00000000
          .byte 4,  %00110000, %00000000, %00000000
          .byte 4,  %01110000, %00000000, %00000000
          .byte 4,  %11110000, %11110000, %00000000
          .byte 4,  %11110000, %11111111, %00001111

Map_EWPassage:
          .byte 24, %11110000, %11111111, %11111111
          .byte 26, %00000000, %00000000, %00000000
          .byte 24, %11110000, %11111111, %11111111

Map_Pinch:
          .byte 24, %11110000, %11111111, %11111111
          .byte 8,  %00000000, %00000000, %11110000
          .byte 10, %00000000, %00000000, %00000000
          .byte 8,  %00000000, %00000000, %11110000
          .byte 24, %11110000, %11111111, %11111111

Map_EWFat:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 1,  %11110000, %11111111, %00011111
          .byte 1,  %11110000, %11111111, %00001111
          .byte 1,  %11110000, %11111111, %00000111
          .byte 1,  %11110000, %11111111, %00000011
          .byte 2,  %11110000, %11111111, %00000001
          .byte 2,  %11110000, %11111111, %00000000
          .byte 1,  %11110000, %11111110, %00000000
          .byte 1,  %11110000, %11111100, %00000000
          .byte 1,  %11110000, %11111000, %00000000
          .byte 1,  %11110000, %11110000, %00000000
          .byte 4,  %11110000, %11100000, %00000000
          .byte 4,  %11110000, %11000000, %00000000
          .byte 26, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %11000000, %00000000
          .byte 4,  %11110000, %11100000, %00000000
          .byte 1,  %11110000, %11110000, %00000000
          .byte 1,  %11110000, %11111000, %00000000
          .byte 1,  %11110000, %11111100, %00000000
          .byte 1,  %11110000, %11111110, %00000000
          .byte 2,  %11110000, %11111111, %00000001
          .byte 2,  %11110000, %11111111, %00000011
          .byte 1,  %11110000, %11111111, %00000111
          .byte 1,  %11110000, %11111111, %00001111
          .byte 1,  %11110000, %11111111, %00011111
          .byte 1,  %11110000, %11111111, %00111111
          .byte 4,  %11110000, %11111111, %11111111

Map_ABCEF:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111

Map_ABCF:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111

Map_ABDE:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111

Map_ABDEF:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %10000000
          .byte 4,  %11110000, %11111111, %11111111
Map_ABE:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %00000000, %11111111

Map_ABEF:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111

Map_ABFG:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00000000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111

Map_ACE:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00000000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %00000000, %11111111

Map_ACEF:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00000000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111

Map_ACF:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111

Map_AD:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111

Map_ADG:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111

Map_AF:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111

Map_AG:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %00000000, %11111111

Map_B:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %00000000, %11111111

Map_BCDE:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111

Map_BCDEF:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %11111111, %11111111

Map_BCE:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %00000000, %11111111

Map_BCEF:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111

Map_BCEG:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %00000000, %11111111

Map_BCFG:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111

Map_BDE:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111

Map_BDF:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %10000000
          .byte 4,  %11110000, %11111111, %11111111

Map_BEF:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111

Map_BEFG:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00000000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111

Map_BFG:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00000000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111

Map_CDEF:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %11111111, %11111111

Map_CEF:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00110000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111

Map_DE:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111

Map_DEF:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %10000000
          .byte 4,  %11110000, %11111111, %11111111

Map_DG:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111
          .byte 31, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111

Map_EF:
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111
          .byte 31, %00000000, %00000000, %10000000
          .byte 4,  %11110000, %00000000, %11111111

          .byte 100, 0, 0, 0

