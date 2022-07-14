;;; -*- fundamental -*-
;;; Grizzards Source/Banks/Bank04/Maps0RLE.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; RLE data for each screen layout
;;;
;;; Repeat count, PF0, PF1, PF2
Map_ClosedSouth:
          .byte 4,  %11110000, %11111111, %00000000
          .byte 66, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111

Map_OpenSouth:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 66, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %00000000

Map_OpenSides:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 66, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111

Map_Funnels:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 4,  %11110000, %11110000, %00000000
          .byte 4,  %01110000, %00000000, %00000000
          .byte 4,  %00110000, %00000000, %00000000
          .byte 8,  %00010000, %00000000, %00000000
          .byte 26, %00000000, %00000000, %00000000
          .byte 8,  %00010000, %00000000, %00000000
          .byte 4,  %00110000, %00000000, %00000000
          .byte 4,  %01110000, %00000000, %00000000
          .byte 4,  %11110000, %11110000, %00000000
          .byte 4,  %11110000, %11111111, %11111111
          
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

Map_Up3Way:
          .byte 4,  %11110000, %11111111, %00001111
          .byte 4,  %11110000, %11110000, %00000000
          .byte 4,  %01110000, %00000000, %00000000
          .byte 4,  %00110000, %00000000, %00000000
          .byte 8,  %00010000, %00000000, %00000000
          .byte 26, %00000000, %00000000, %00000000
          .byte 24, %11110000, %11111111, %11111111

Map_Arc:
          .byte 8,  %11110000, %11111111, %11111111
          .byte 2,  %11110000, %11110000, %00000000
          .byte 2,  %11110000, %11000000, %00000000
          .byte 4,  %11110000, %00000000, %00000000
          .byte 4,  %00110000, %00000000, %00000000
          .byte 4,  %00010000, %00000000, %00000000
          .byte 3,  %00000000, %00000011, %00000111
          .byte 4,  %00000000, %00000111, %00000111
          .byte 6,  %00000000, %00001111, %00001111
          .byte 6,  %00000000, %00011111, %00001111
          .byte 3,  %00000000, %00111111, %00001111
          .byte 4,  %00000000, %11111111, %00001111
          .byte 24, %11110000, %11111111, %00001111

Map_Wiggle:
          ;; top section
          .byte 6,  %11110000, %11111111, %11111111
          .byte 2,  %11110000, %11111111, %00011111
          .byte 4,  %11110000, %11111111, %00000001
          .byte 3,  %11110000, %11111110, %00000000
          .byte 3,  %11110000, %11111100, %00000000
          .byte 3,  %11110000, %11111000, %00000000
          .byte 3,  %11110000, %11110000, %00000000
          ;; middle section
          .byte 2,  %11000000, %11100000, %10000000
          .byte 7,  %10000000, %11100000, %11100000
          .byte 4,  %00000000, %11100000, %11110000
          .byte 4,  %00000000, %01100000, %11110000
          .byte 9,  %00000000, %00000000, %11111000
          ;; bottom section
          .byte 3,  %00010000, %00000000, %11111100
          .byte 3,  %00110000, %00000000, %11111100
          .byte 3,  %01110000, %00000000, %11111100
          .byte 2,  %01110000, %00000000, %11111100
          .byte 2,  %11110000, %00000000, %11111100
          .byte 3,  %11110000, %10000000, %11111110
          .byte 3,  %11110000, %11000000, %11111111
          .byte 6,  %11110000, %11111111, %11111111

Map_Narrow:
          .byte 14, %11110000, %11111111, %00001111
          .byte 8,  %11110000, %11111111, %00011111
          .byte 8,  %11110000, %11111111, %00111111
          .byte 10, %11110000, %11111111, %01111111
          .byte 8,  %11110000, %11111111, %00111111
          .byte 8,  %11110000, %11111111, %00011111
          .byte 14, %11110000, %11111111, %00001111

Map_Bulge:
          .byte 14, %11110000, %11111111, %00001111
          .byte 5,  %11110000, %11111111, %00000111
          .byte 5,  %11110000, %11111111, %00000011
          .byte 3,  %11110000, %11111111, %00000001
          .byte 26, %11110000, %11111111, %00000000
          .byte 3,  %11110000, %11111111, %00000001
          .byte 5,  %11110000, %11111111, %00000011
          .byte 5,  %11110000, %11111111, %00000111
          .byte 14, %11110000, %11111111, %00001111

Map_NorthGlobe:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 4,  %11110000, %11111100, %00000000
          .byte 4,  %11110000, %11000000, %00000000
          .byte 4,  %11110000, %00000000, %00000000
          .byte 42, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %00000000, %00000000
          .byte 4,  %11110000, %11000000, %00000000
          .byte 4,  %11110000, %11111100, %00000000
          .byte 4,  %11110000, %11111111, %00001111

Map_SouthGlobe:
          .byte 4,  %11110000, %11111111, %00001111
          .byte 4,  %11110000, %11111100, %00000000
          .byte 4,  %11110000, %11000000, %00000000
          .byte 4,  %11110000, %00000000, %00000000
          .byte 42, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %00000000, %00000000
          .byte 4,  %11110000, %11000000, %00000000
          .byte 4,  %11110000, %11111100, %00000000
          .byte 4,  %11110000, %11111111, %11111111

Map_Split:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 21, %00000000, %00000000, %00000000
          .byte 10, %00010000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111
          .byte 10, %00010000, %00000000, %00000000
          .byte 21, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111

Map_SplitBoxes:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 21, %00000000, %00001111, %00000111
          .byte 10, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111
          .byte 10, %00110000, %00000000, %00000000
          .byte 21, %00000000, %00001111, %00000111
          .byte 4,  %11110000, %11111111, %11111111

Map_SplitMaze:
          .byte 4,  %11110000, %11111111, %00001111
          .byte 21, %00000000, %00000000, %00000011
          .byte 10, %00110000, %00000000, %00110000
          .byte 4,  %11110000, %11111111, %00111111
          .byte 10, %00110000, %00000000, %00110000
          .byte 21, %00000000, %00000000, %00000011
          .byte 4,  %11110000, %11111111, %00001111

Map_EWFat:
          .byte 3,  %11110000, %11111111, %11111111
          .byte 4,  %11110000, %11111111, %00011111
          .byte 4,  %11110000, %11111111, %00000001
          .byte 4,  %11110000, %11111110, %00000000
          .byte 4,  %11110000, %11100000, %00000000
          .byte 4,  %11110000, %11000000, %00000000
          .byte 26, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %11000000, %00000000
          .byte 4,  %11110000, %11100000, %00000000
          .byte 4,  %11110000, %11110000, %00000000
          .byte 4,  %11110000, %11111111, %00000001
          .byte 4,  %11110000, %11111111, %00000111
          .byte 3,  %11110000, %11111111, %11111111

Map_OpenNorth:
          .byte 4,  %11110000, %11111111, %00001111
          .byte 4,  %11110000, %00000000, %00000000
          .byte 4,  %01110000, %00000000, %00000000
          .byte 4,  %00110000, %00000000, %00000000
          .byte 8,  %00010000, %00000000, %00000000
          .byte 50, %00000000, %00000000, %00000000

Map_ClosedNorth:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 4,  %11110000, %00000000, %00000000
          .byte 4,  %01110000, %00000000, %00000000
          .byte 4,  %00110000, %00000000, %00000000
          .byte 8,  %00010000, %00000000, %00000000
          .byte 50, %00000000, %00000000, %00000000

Map_Clear:
          .byte 74, %00000000, %00000000, %00000000

Map_FullTop:
          .byte 24, %11110000, %11111111, %11111111
          .byte 50, %00000000, %00000000, %00000000

Map_BottomLine:
          .byte 70, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111

Map_Island:
          .byte 24, %00000000, %00000000, %00000000
          .byte 6,  %00000000, %00000000, %11100000
          .byte 14, %00000000, %00000000, %11110000
          .byte 6,  %00000000, %00000000, %11100000
          .byte 24, %00000000, %00000000, %00000000

Map_Bow:
          .byte 24, %11110000, %11111111, %00001111
          .byte 26, %00000000, %00000000, %00000000
          .byte 4,  %00010000, %00000000, %00000000
          .byte 4,  %00110000, %00000000, %00000000
          .byte 4,  %01110000, %00000000, %00000000
          .byte 4,  %11110000, %11110000, %00000000
          .byte 8,  %11110000, %11111111, %11111111

Map_BowClosed:
          .byte 24, %11110000, %11111111, %00001111
          .byte 26, %00010000, %00000000, %00000000
          .byte 4,  %00010000, %00000000, %00000000
          .byte 4,  %00110000, %00000000, %00000000
          .byte 4,  %01110000, %00000000, %00000000
          .byte 4,  %11110000, %11110000, %00000000
          .byte 8,  %11110000, %11111111, %11111111

Map_House:
          .byte 16, %00000000, %00000000, %00000000
          .byte 2,  %00000000, %00000000, %10000000
          .byte 2,  %00000000, %00000000, %11000000
          .byte 2,  %00000000, %00000000, %11100000
          .byte 2,  %00000000, %00000000, %11110000
          .byte 2,  %00000000, %00000000, %11111000
          .byte 2,  %00000000, %00000000, %11111100
          .byte 2,  %00000000, %00000000, %11111110
          .byte 10, %00000000, %00000000, %11111111
          .byte 10, %00000000, %00000000, %01111111
          .byte 24, %00000000, %00000000, %00000000

Map_Indoors:
          .byte 10, %11110000, %11111111, %11111111
          .byte 54, %11110000, %11110000, %00000000
          .byte 10, %11110000, %11111111, %11111111

Map_Closed:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 66, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111

.byte 100, 0, 0, 0

