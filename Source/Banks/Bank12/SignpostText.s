;;; Grizzards Source/Banks/Bank12/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 0

          Signs = ()
          ;;; , Sign_TunnelClosed, Sign_SpiralWoodsOpen, Sign_PortLionShip
          
SignH:    .byte >(Signs)
SignL:    .byte <(Signs)

;;; 0
