;;; Grizzards Source/Banks/Bank03/MapsProvince1.s
;;; Copyright © 2021 Bruce-Robert Pocock

          ;; How many maps are in these tables?
MapCount = 47

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
          ;; ↑ 73

;;; Links up, down, left, right are map indices in this bank
MapLinks:
          .byte $ff, $ff, $ff, $ff
          .byte $ff, $ff, $ff, $ff
          .byte $ff, $ff, 3, $ff ; link back to province 0 room 8 FIXME
          .byte $ff, $ff, 4, 2
          .byte $ff, $ff, 5, 3
          ;; 5
          .byte $ff, $ff, 6, 4
          .byte $ff, $ff, 8, 7
          .byte $ff, $ff, 5, 8
          .byte 8, 9, 10, 6
          .byte 11, 12, 8, 7
          ;; 10
          .byte 11, 10, 9, 7
          .byte 9, 8, 9, 13
          .byte 10, 8, 11, 12
          .byte 8, 8, 8, 8

;;; RLE Map data for each screen.

;;; Note that it can be reused, so the same basic layout, potentially
;;; in different colors, can appear in several places.
          MapRLE = (
          Map_EWPassage,
          Map_EWFat,
          Map_Pinch,
          Map_Pinch,
          Map_EWFat,
          ;; 5
          Map_Pinch,
          Map_Pinch,
          Map_EWFat,
          Map_FourWay,
          Map_FourWay,
          ;; 10
          Map_FourWay,
          Map_FourWay,
          Map_FourWay,
          Map_FourWay
          )

MapRLEL:  .byte <MapRLE
MapRLEH:  .byte >MapRLE

;;; Maps can have left or right sides added by the Ball
;;;
;;; This lets the exits be asymmetrical, even though the playfield is in
;;; reflected mode
;;; $80 = left, $40 = right ball.
MapSides:
          .byte 0, $80, 0, 0, 0
          .byte 0, $40, 0, $80, 0
          ;; 10
          .byte 0, 0, 0, 0, 0
          .byte 0, $40, $40, 0, $80
          ;; 20
          .byte 0, 0, 0, 0, 0
          .byte 0, 0, 0, 0, $80
          ;; 30
          .byte 0, 0, 0, 0, 0
          .byte 0, 0, 0, 0, 0
          ;; 40
          .byte $40, $40, $40, 0, $80
          .byte $80, 0

;;; The Sprites Lists
;;;
;;; Each screen can have a list of sprites here, ending with a zero
;;; byte. Each sprite is a 5-byte structure, with its type, X, Y,
;;; action, and action-parameter listed.
;;;
;;; A fixed sprite appears at the given position and stays there.
;;; Moving sprites wander the screen, obeying walls.
;;; Random encounters occupy a sprite data slot but are not actually
;;; visible on the screen.
SpriteList:
          ;; Room 62
          .byte 0

          ;; Room 63
          .byte 0

          ;; Room 64
          .byte 0

          ;; Room 65
          .byte 0

          ;; Room 66
          .byte 0

          ;; Room 67
          .byte 0

          ;; Room 68
          .byte 0

          ;; Room 69
          .byte 0

          ;; Room 70
          .byte 0

          ;; Room 71
          .byte 0

          ;; Room 72
          .byte 0

          ;; Room 73
          .byte 0

          .fill 200
