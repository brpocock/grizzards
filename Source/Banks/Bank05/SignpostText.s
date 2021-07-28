;;; Grizzards Source/Banks/Bank05/SignpostText.s
;;; Copyright © 2021 Bruce-Robert Pocock

          Signs = (Sign_HelloWorld)

SignH:    .byte >(Signs)
SignL:    .byte <(Signs)

Sign_HelloWorld:
          .colu COLGRAY, 0
          .colu COLYELLOW, $f
          .SignText "BEWARE! THIS"
          .SignText "ROUTE LEADS "
          .SignText "TO MANY EVIL"
          .SignText "MONSTERS.   "
          .SignText "BE CAREFUL! "
          .byte ModeSignpostDone

