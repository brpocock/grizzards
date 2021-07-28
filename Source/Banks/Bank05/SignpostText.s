;;; Grizzards Source/Banks/Bank05/SignpostText.s
;;; Copyright © 2021 Bruce-Robert Pocock

          Signs = (Sign_Beware, Sign_FireSwamp, NPC_SouthGate, NPC_TunnelBlocked, NPC_TunnelOpen, NPC_Artefact, NPC_TakeArtefact)

SignH:    .byte >(Signs)
SignL:    .byte <(Signs)

Sign_Beware:
          .colu COLGRAY, 0
          .colu COLYELLOW, $f
          .SignText "BEWARE! THIS"
          .SignText "ROUTE LEADS "
          .SignText "TO MANY EVIL"
          .SignText "MONSTERS.   "
          .SignText "BE CAREFUL! "
          .byte ModeSignpostDone

Sign_FireSwamp:
          .colu COLRED, 0
          .colu COLRED, $f
          .SignText "NOW ENTERING"
          .SignText "THE FIRE BOG"
          .SignText "BE WARY OF  "
          .SignText "FLAME DOGGOS"
          .SignText "AND R.O.U.S."
          .byte ModeSignpostDone

NPC_SouthGate:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "TO THE SOUTH"
          .SignText "ARE TUNNELS "
          .SignText "TO THE FIELD"
          .SignText "WHERE MANY  "
          .SignText "PEOPLE LIVE."
          .byte ModeSignpostDone

NPC_TunnelBlocked:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "I CAN'T OPEN"
          .SignText "THE TUNNELS "
          .SignText "WITHOUT THE "
          .SignText "2 ARTEFACTS."
          .SignText "BRING THEM. "
          .byte ModeSignpostDone

NPC_TunnelOpen:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "NOW THAT YOU"
          .SignText "BROUGHT THEM"
          .SignText "I CAN OPEN  "
          .SignText "THE TUNNELS."
          .SignText "END OF DEMO."
          .byte ModeSignpostDone

NPC_Artefact:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "I HAVE 1 OF "
          .SignText "THE TWO     "
          .SignText "ARTEFACTS.   "
          .SignText "WHO SAYS YOU "
          .SignText "CAN TAKE IT?"
          .byte ModeSignpostDone

NPC_TakeArtefact:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "I HAVE 1 OF "
          .SignText "THE TWO     "
          .SignText "ARTEFACTS.   "
          .SignText "TAKE THIS TO"
          .SignText "THE TUNNELS."
          .byte ModeSignpostDone          
