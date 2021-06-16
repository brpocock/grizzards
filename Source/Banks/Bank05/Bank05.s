          BANK = $05

          ;;
          ;; CHAT Services (common routines and graphics)
          ;; 
          
          .include "StartBank.s"
          .include "48Pixels.s"
          .include "VSync.s"
          .include "Prepare48pxMobBlob.s"
          .include "DecodeText.s"
          .include "ShowPicture.s"
          .include "ShowText.s"

DoLocal:
          jmp FarReturn
          
          .align $100
          .include "Font.s"

;;; Also failure mode

          .include "Failure.s"
          

          .include "EndBank.s"
