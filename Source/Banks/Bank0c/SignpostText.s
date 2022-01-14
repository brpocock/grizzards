;;; Grizzards Source/Banks/Bank0c/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 92

          Signs = ( NPC_DoTrain, NPC_DoNotTrain, Sign_Grue )

SignH:    .byte >(Signs)
SignL:    .byte <(Signs)

;;; 92
NPC_DoTrain:
          .colu COLBLUE, 0
          .colu COLCYAN, $9
          .SignText "NOW YOUR    "
          .SignText "GRIZZARD CAN"
          .SignText "USE THEIR   "
          .SignText "LAST MOVE   "
          .SignText "FOR SURE.   "
          .byte ModeTrainLastMove

;;; 93
NPC_DoNotTrain:
          .colu COLBLUE, 0
          .colu COLCYAN, $9
          .SignText "BRING ME ANY"
          .SignText "GRIZZARD YOU"
          .SignText "WANT ME TO  "
          .SignText "TRAIN AND I "
          .SignText "WILL DO IT. "
          .byte ModeSignpostDone

;;; 94
Sign_Grue:
          .colu COLRED, $4
          .colu COLGRAY, $a
          .SignText "CAVES BEYOND"
          .SignText "CAN BE DARK."
          .SignText "YOU MAY BE  "
          .SignText "EATEN BY A  "
          .SignText "GRUE.       "
          .byte ModeSignpostDone
