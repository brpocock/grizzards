;;; Grizzards Source/Banks/Bank04/MapRLE.s
;;; Copyright © 2021 Bruce-Robert Pocock
;;; -*- fundamental -*-

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

Map_Shroom1:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 4,  %11110000, %11110000, %00000000
          .byte 4,  %01110000, %00000000, %00000000
          .byte 4,  %00110000, %00000000, %00000000
          .byte 8,  %00010000, %00000000, %00000000
          .byte 26, %00000000, %00000000, %00000000
          .byte 4,  %01110000, %00000000, %00000000
          .byte 20, %11110000, %11110000, %00000000

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

Map_Up3Way:
          .byte 4,  %11110000, %11111111, %00001111
          .byte 4,  %11110000, %11110000, %00000000
          .byte 4,  %01110000, %00000000, %00000000
          .byte 4,  %00110000, %00000000, %00000000
          .byte 8,  %00010000, %00000000, %00000000
          .byte 26, %00000000, %00000000, %00000000
          .byte 24, %11110000, %11111111, %11111111

Map_Arc: ; TODO not as designed
          .byte 8,  %11110000, %11111111, %11111111
          .byte 4,  %11110000, %11110000, %00000000
          .byte 4,  %01110000, %00000000, %00000000
          .byte 4,  %00110000, %00000000, %00000000
          .byte 4,  %00010000, %00000000, %00000000
          .byte 26, %00000000, %00000000, %00000000
          .byte 24, %11110000, %11111111, %00001111

Map_Wiggle: ; TODO garbage data
          .byte 4,  %11110000, %11111111, %11111111
          .byte 4,  %00110000, %00110011, %00110011
          .byte 4,  %00010000, %00010001, %00010001
          .byte 4,  %00110000, %00110011, %00110011
          .byte 8,  %00010000, %00010001, %00010001
          .byte 26, %00000000, %00000000, %00000000
          .byte 8,  %00010000, %00010001, %00010001
          .byte 4,  %00110000, %00110011, %00110011
          .byte 4,  %00010000, %00010001, %00010001
          .byte 4,  %00110000, %00110011, %00110011
          .byte 4,  %11110000, %11111111, %11111111

Map_Narrow:
          .byte 14, %11110000, %11111111, %00001111
          .byte 10, %11110000, %11111111, %00011111
          .byte 26, %11110000, %11111111, %00111111
          .byte 10, %11110000, %11111111, %00011111
          .byte 14, %11110000, %11111111, %00001111

Map_Bulge:
          .byte 14, %11110000, %11111111, %00001111
          .byte 10, %11110000, %11111111, %00000011
          .byte 26, %11110000, %11111111, %00000000
          .byte 10, %11110000, %11111111, %00000011
          .byte 14, %11110000, %11111111, %00001111

Map_NorthGlobe:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 4,  %11110000, %00111111, %00000000
          .byte 4,  %11110000, %00000011, %00000000
          .byte 4,  %11110000, %00000000, %00000000
          .byte 42, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %00000000, %00000000
          .byte 4,  %11110000, %00000011, %00000000
          .byte 4,  %11110000, %00111111, %00000000
          .byte 4,  %11110000, %11111111, %11110000

Map_SouthGlobe:
          .byte 4,  %11110000, %11111111, %11110000
          .byte 4,  %11110000, %00111111, %00000000
          .byte 4,  %11110000, %00000011, %00000000
          .byte 4,  %11110000, %00000000, %00000000
          .byte 42, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %00000000, %00000000
          .byte 4,  %11110000, %00000011, %00000000
          .byte 4,  %11110000, %00111111, %00000000
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
          .byte 21, %00000000, %00000000, %00000111
          .byte 10, %00010000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111
          .byte 10, %00010000, %00000000, %00000000
          .byte 21, %00000000, %00000000, %00000111
          .byte 4,  %11110000, %11111111, %11111111

Map_SplitMaze: ; TODO encode this screen
          .byte 4,  %11110000, %11111111, %11111111
          .byte 21, %00000000, %00000000, %00000111
          .byte 10, %00010000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111
          .byte 10, %00010000, %00000000, %00000000
          .byte 21, %00000000, %00000000, %00000111
          .byte 4,  %11110000, %11111111, %11111111

Map_EWFat:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 4,  %11110000, %11111111, %11110000
          .byte 4,  %11110000, %11111111, %00000000
          .byte 4,  %11110000, %00001111, %00000000
          .byte 8,  %11110000, %00000000, %00000000
          .byte 26, %00000000, %00000000, %00000000
          .byte 8,  %11110000, %00000000, %00000000
          .byte 4,  %11110000, %00001111, %00000000
          .byte 4,  %11110000, %11111111, %00000000
          .byte 4,  %11110000, %11111111, %11110000
          .byte 4,  %11110000, %11111111, %11111111

Map_OpenNorth:
          .byte 4,  %11110000, %11111111, %11110000
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

Map_Island: ; TODO fix up this map too
          .byte 24, %00000000, %00000000, %00000000
          .byte 6,  %00000000, %00000000, %00000111
          .byte 14, %00000000, %00000000, %00001111
          .byte 6,  %00000000, %00000000, %00000111
          .byte 24, %00000000, %00000000, %00000000

Map_Bow: ; TODO not as designed
          .byte 24, %11110000, %00000000, %11110000
          .byte 26, %00000000, %00000000, %00000000
          .byte 4,  %10000000, %00000000, %00000000
          .byte 4,  %11000000, %00000000, %00000000
          .byte 4,  %11100000, %00000000, %00000000
          .byte 4,  %11110000, %00001111, %00000000
          .byte 8,  %11110000, %11111111, %11111111

.byte 100, 0, 0, 0

.fill 60
