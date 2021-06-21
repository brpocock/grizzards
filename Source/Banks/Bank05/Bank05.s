          BANK = $05

          ;; Combat for encounters $80 … $ff
          
          .include "StartBank.s"
          .include "VSync.s"

DoLocal:
          rts
          
          

          .include "EndBank.s"
