;;; Grizzards Source/Common/SpriteColor.s
;;; Copyright © 2021 Bruce-Robert Pocock

SpriteColor:
          .colu COLGREEN, $a    ; monster
          .colu COLRED, $e      ; Grizzard Depot
          .colu COLSPRINGGREEN, $e ; new Grizzard
          .colu COLBLUE, $8        ; door

          ;; Signpost
          .if TV == SECAM
          .byte COLWHITE
          .else
          .colu COLGRAY, $2
          .fi

          .colu COLGOLD, $8     ; NPC

          .byte 0               ; unused
          .byte COLTURQUOISE, $8 ; province door
