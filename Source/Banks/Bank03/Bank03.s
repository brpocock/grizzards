;;; Grizzards Source/Banks/Bank03/Bank03.s
;;; Copyright © 2021 Bruce-Robert Pocock
	BANK = $03

          .include "StartBank.s"

DoLocal:  
          .include "Map.s"
          .include "VSync.s"
          .include "Random.s"

          .include "MapsPart2.s"

          .include "PlayerSprites.s"
          .include "MapSprites.s"

          .include "EndBank.s"
