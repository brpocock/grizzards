;;; Grizzards Source/Banks/Bank03/MapsProvince1.s
;;; Copyright © 2021 Bruce-Robert Pocock

          ;; How many maps are in these tables?
MapCount = 13

;;; Foreground and background colors
;;; Remember SECAM and don't make these too similar

MapColors:
          ;; 0
          .colors COLBLUE, COLBLUE ; unused
          .colors COLBLUE, COLBLUE ; unused
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          ;; 10
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          ;; ↑ 13

;;; Links up, down, left, right are map indices in this bank
MapLinks:
          .byte $ff, $ff, $ff, $ff
          .byte $ff, $ff, $ff, $ff
          .byte $ff, $ff, 3, $ff
          .byte $ff, $ff, 4, 2
          .byte $ff, $ff, 5, 3
          ;; 5
          .byte $ff, $ff, 6, 4
          .byte $ff, $ff, 8, 7
          .byte $ff, $ff, 6, 2
          .byte 11, 9, 10, 6
          .byte 10, 12, 8, 7
          ;; 10
          .byte 11, 12, 9, 7
          .byte 9, 8, 10, 13
          .byte 10, 8, 11, 13
          .byte 8, 8, 8, 8

;;; RLE Map data for each screen.

;;; Note that it can be reused, so the same basic layout, potentially
;;; in different colors, can appear in several places.
          _ := ( Map_EWPassage, Map_EWFat, Map_Pinch, Map_Pinch, Map_EWFat )
          _ ..= ( Map_Pinch, Map_Pinch, Map_EWFat, Map_FourWay, Map_FourWay)
          _ ..= ( Map_FourWay, Map_FourWay, Map_FourWay, Map_FourWay)
          MapRLE = _

MapRLEL:  .byte <MapRLE
MapRLEH:  .byte >MapRLE

;;; Maps can have left or right sides added by the Ball
;;;
;;; This lets the exits be asymmetrical, even though the playfield is in
;;; reflected mode
;;; $80 = left, $40 = right ball.
MapSides:
          .byte 0, 0, $40, 0, 0
          .byte 0, 0, 0, 0, 0
          ;; 10
          .byte 0, 0, 0, 0

;;; 
SpriteList:
          ;; Room 0
          .byte 0

          ;; Room 1
          .byte 0

          ;; Room 2
          .byte $ff, SpriteFixed
          .byte $b6, $20
          .byte SpriteProvinceDoor | $00, 8

          .byte 0

          ;; Room 3
          .byte 0

          ;; Room 4
          .byte 0

          ;; Room 5
          .byte 0

          ;; Room 6
          .byte 0

          ;; Room 7
          .byte 0

          ;; Room 8
          .byte 0

          ;; Room 9
          .byte 0

          ;; Room 10
          .byte 0

          ;; Room 11
          .byte 0

          ;; Room 12
          .byte 0
 
          ;; Room 13
          .byte $ff, SpriteFixed
          .byte $ac, $3c
          .byte SpriteGrizzardDepot, 0

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteGrizzard, 8 ; Lander

          .byte 0

          .fill 200
