;;; Grizzards Source/Common/GrizzardArt.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

GrizzardPictureSelect:

          .byte 0, 3, 1, 8, 5, 2, 6, 7, 0, 3
          ;; 10
          .byte 1, 8, 4, 9, 2, 5, 6, 7, 5, 7
          ;; 20
          .byte 4, 0, 3, 1, 8, 0, 3, 1, 8, 9

GrizzardColor:

          .colu COLGREEN, $c
          .colu COLBROWN, $6
          .colu COLTEAL, $c
          .colu COLRED, $c
          .colu COLBROWN, $4
          .colu COLTURQUOISE, $c
          .colu COLTEAL, $c
          .colu COLGREEN, $6
          .colu COLSEAFOAM, $c
          .colu COLGOLD, $6
          ;; 10
          .colu COLBROWN, $c
          .colu COLTURQUOISE, $c
          .colu COLTEAL, $6
          .colu COLYELLOW, $c
          .colu COLBLUE, $6
          .colu COLINDIGO, $6
          .colu COLMAGENTA, $c
          .colu COLORANGE, $c
          .colu COLCYAN, $6
          .colu COLGREEN, $c
          ;; 20
          .colu COLBROWN, $c
          .colu COLTEAL, $6
          .colu COLRED, $c
          .colu COLTURQUOISE, $c
          .colu COLTEAL, $6
          .colu COLSEAFOAM, $c
          .colu COLGOLD, $c
          .colu COLPURPLE, $6
          .colu COLYELLOW, $c
          .colu COLINDIGO, $8
