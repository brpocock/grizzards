;;; Grizzards Source/Banks/Bank03/Bank03Game.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          
          ;; The addresses of these must be known to the Map Services bank
          .include "PlayerSprites.s"
          .include "MapSprites.s"
DoLocal:
          .include "MapSetup.s"
          .include "Map.s"

          .include "MapsProvince1.s"
          .include "Maps1RLE.s"

SongProvince:
          .include "Province1.s"

          .include "VSync.s"
          .include "VBlank.s"
          
          .include "Random.s"
          .include "PlayMusic.s"
          rts

          
