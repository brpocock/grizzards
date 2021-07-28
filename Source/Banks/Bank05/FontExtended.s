;;; -*- fundamental -*-
;;; Grizzards Source/Banks/Bank05/FontExtended.s
;;; Copyright © 2021 Bruce-Robert Pocock

;;; The text font is an 8 × 15px font stored at 8 × 5px resolution,
;;; inverted.

;;; This file provides additional characters:

;;;  ,'

FontExtended:	.block

	Height = 5

          .byte %00000100
          .byte %00000110
          .byte %00000000
          .byte %00000000
          .byte %00000000

          .byte %00000000
          .byte %00000000
          .byte %00000000
          .byte %00000100
          .byte %00001100

	.bend
