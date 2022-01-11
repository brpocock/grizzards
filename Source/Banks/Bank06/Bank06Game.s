;;; Grizzards Source/Banks/Bank06/Bank06Game.s
;;; Copyright © 2022 Bruce-Robert Pocock

          ;; The addresses of these must be known to the Map Services bank
          .include "PlayerSprites.s"
          .include "MapSprites.s"
DoLocal:
          .include "MapSetup.s"
          ;; falls through to
          .include "Map.s"

          .include "MapsProvince3.s"
          .include "Maps3RLE.s"

          .include "Province3.s"

          .include "VSync.s"
          .include "VBlank.s"

          .include "Random.s"

          .include "PlayMusic.s"
          rts
