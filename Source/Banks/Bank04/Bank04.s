	  BANK = $04

          .include "StartBank.s"

DoLocal:  
          .include "Map.s"
          .include "VSync.s"

          .include "OverworldMaps.s"

          .include "PlayerSprites.s"
          .include "EndBank.s"
