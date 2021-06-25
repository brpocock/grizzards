;;; Grizzards Source/Banks/Bank04/Bank04.s
;;; Copyright © 2021 Bruce-Robert Pocock
	  BANK = $04

          .include "StartBank.s"

DoLocal:  
          .include "Map.s"
          .include "VSync.s"
          .include "Random.s"

          .include "OverworldMaps.s"

          .include "PlayerSprites.s"
          .include "MapSprites.s"
          
          .include "EndBank.s"
