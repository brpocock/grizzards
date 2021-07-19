;;; Grizzards Source/Banks/Bank04/Bank04.s
;;; Copyright © 2021 Bruce-Robert Pocock
	  BANK = $04

          .include "StartBank.s"

DoLocal:
          .include "MapSetup.s"
          .include "Map.s"

          .include "OverworldMaps.s"
          .include "MapRLE.s"

          .include "PlayerSprites.s"
          .include "MapSprites.s"

SpriteColor:
          .colu COLGREEN, $a
          .colu COLRED, $e
          .colu COLSPRINGGREEN, $e
          .colu COLBLUE, $8

          .include "Province0.s"

          .include "VSync.s"
          .include "VBlank.s"
          .include "Overscan.s"
          .include "Random.s"
          .include "PlayMusic.s"
          rts
          .include "EndBank.s"
