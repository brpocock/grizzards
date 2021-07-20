;;; Grizzards Source/Banks/Bank03/Bank03.s
;;; Copyright © 2021 Bruce-Robert Pocock
	BANK = $03

          .include "StartBank.s"

DoLocal:
          .include "MapSetup.s"
          .include "Map.s"

          .include "MapsPart2.s"
          .include "Maps3RLE.s"

          .include "PlayerSprites.s"
          .include "MapSprites.s"

SpriteColor:
          .colu COLGREEN, $a
          .colu COLRED, $e
          .colu COLSPRINGGREEN, $e
          .colu COLBLUE, $8

          .include "Province1.s"

          .include "VSync.s"
          .include "VBlank.s"
          .include "Overscan.s"
          .include "Random.s"
          .include "PlayMusic.s"
          rts
          .include "EndBank.s"
