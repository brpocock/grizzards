          BANK = $05

          ;;
          ;; CHAT Services (common routines and graphics)
          ;; 
          
          .include "StartBank.s"
          .include "VSync.s"

DoLocal:
          rts
          
;;; Also failure mode

          .include "Failure.s"
          

          .include "EndBank.s"
