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
          .include "ShowPortrait.s"          
          jmp FarReturn
          
          .align $100
          .include "Font.s"
          
          .align $100
Portraits:          
          .align $100
          .include "ManPortrait.s"
          .align $100
          .include "WomanPortrait.s"
          .align $100
          .include "ChildPortrait.s"
          .align $100
          .include "Portrait4.s"
          .align $100
          .include "Portrait5.s"
          .align $100
          .include "Portrait6.s"


;;; Also failure mode

          .include "Failure.s"
          

          .include "EndBank.s"
