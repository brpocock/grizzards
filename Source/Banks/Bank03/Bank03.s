;;; Grizzards Source/Banks/Bank03/Bank03.s
;;; Copyright © 2021 Bruce-Robert Pocock
	BANK = $03

          .include "StartBank.s"

          .if DEMO

          ;; Should never end up in this bank
DoLocal:
          brk

          .else
DoLocal:
          .include "MapSetup.s"
          .include "Map.s"

          .include "MapsProvince1.s"
          .include "Maps1RLE.s"

          .include "PlayerSprites.s"
          .include "MapSprites.s"
          .include "SpriteColor.s"
          .include "Province1.s"

          .include "VSync.s"
          .include "VBlank.s"
          .include "Overscan.s"
          .include "Random.s"
          .include "PlayMusic.s"
          rts

          .fi

          .include "EndBank.s"
