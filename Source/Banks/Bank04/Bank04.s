;;; Grizzards Source/Banks/Bank04/Bank04.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
	BANK = $04

          .include "StartBank.s"

          ;; The addresses of these must be known to the Map Services bank
          .include "PlayerSprites.s"
          .include "MapSprites.s"
DoLocal:
          .include "MapSetup.s"
          ;; falls through to
          .include "Map.s"

          .include "VSync.s"
          .include "VBlank.s"
          
          .include "Random.s"

          .include "PlayMusic.s"
          rts

          .include "MapsProvince0.s"
          .include "Maps0RLE.s"

SongProvince:
          .include "Province0.s"

          
          .include "EndBank.s"
