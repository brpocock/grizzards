;;; Grizzards Source/Banks/Bank05/Bank05Game.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          ;; The addresses of these must be known to the Map Services bank
          .include "PlayerSprites.s"
          .include "MapSprites.s"
DoLocal:
          .include "MapSetup.s"
          ;; falls through to
          .include "Map.s"

          .include "MapsProvince2.s"
          .include "Maps2RLE.s"

          .include "Province2.s"

          .include "VSync.s"
          .include "VBlank.s"
          .include "Overscan.s"
          .include "Random.s"

          .include "PlayMusic.s"
          rts
          .include "WaitScreenBottom.s"
