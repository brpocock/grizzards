;;; Grizzards Source/Common/SpriteColor.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

SpriteColor:                       ; For map sprites
          .block
Monsters:
          .colu COLGREEN, $6
Depot:
          .colu COLMAGENTA, $6
Grizzard:
          .colu COLSPRINGGREEN, $6
Door:
          .colu COLBLUE, $8

Signpost:
          .if TV == SECAM
            .byte COLWHITE
          .else
            .colu COLGRAY, $2
          .fi

NPC:
          .colu COLGOLD, $8
Boss:
          .colu COLGREEN, $4
Poof:
          .colu COLGRAY, $8

          .bend
