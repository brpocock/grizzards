;;; Grizzards Source/Banks/Bank04/Bank04.s
;;; Copyright © 2021 Bruce-Robert Pocock
	BANK = $04

          .include "StartBank.s"

DoLocal:
          .include "MapSetup.s"
          ;; falls through to
          .include "Map.s"

          .include "OverworldMaps.s"
          .include "MapRLE.s"
          .include "PlayerSprites.s"
          .include "MapSprites.s"

SpriteColor:
          .colu COLGREEN, $a    ; Grizzard
          .colu COLRED, $8      ; Grizzard Depot
          .colu COLSPRINGGREEN, $e ; Monsters
          .colu COLBLUE, $8        ; Doors

          .include "Province0.s"

          .include "VSync.s"
          .include "VBlank.s"
          .include "Overscan.s"
          .include "Random.s"

          .include "PlayMusic.s"
          rts

          .include "EndBank.s"
