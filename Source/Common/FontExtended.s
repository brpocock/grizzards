;;; -*- fundamental -*-
;;; Grizzards Source/Common/FontExtended.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; The text font is an 8 × 15px font stored at 8 × 5px resolution,
;;; inverted.

;;; This file provides additional characters:

;;;  ,'<>

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

          .byte %00000111
          .byte %00011111
          .byte %11111111
          .byte %00011111
          .byte %00000111

          .byte %11100000
          .byte %11111000
          .byte %11111111
          .byte %11111000
          .byte %11100000
	.bend

;; Audited 2022-02-16 BRPocock
