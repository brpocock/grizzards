;;; Grizzards Source/Banks/Bank05Game.s
;;; Copyright © 2021 Bruce-Robert Pocock


DoLocal:
          .include "MapSetup.s"
          ;; falls through to
          .include "Map.s"

          .include "MapsProvince2.s"
          .include "Maps2RLE.s"
          .include "PlayerSprites.s"
          .include "MapSprites.s"
          .include "SpriteColor.s"

          .include "Province2.s"

          .include "VSync.s"
          .include "VBlank.s"
          .include "Overscan.s"
          .include "Random.s"

          .include "PlayMusic.s"
          rts
