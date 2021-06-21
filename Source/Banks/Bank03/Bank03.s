	BANK = $03

          .include "StartBank.s"

DoLocal:  
          .include "Map.s"
          .include "VSync.s"

          .include "MapsPart2.s"

          .include "PlayerSprites.s"
          .include "MapSprites.s"

          .include "EndBank.s"
