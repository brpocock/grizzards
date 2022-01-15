;;; Grizzards Source/Banks/Bank0c/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 90

          Signs = ( NPC_GetArtifacts, NPC_NoArtifacts, NPC_DoTrain, NPC_DoNotTrain, Sign_Grue )

SignH:    .byte >(Signs)
SignL:    .byte <(Signs)

;;; 90
NPC_GetArtifacts:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "THERE ARE   "
          .SignText "2 ARTIFACTS "
          .SignText "THAT WERE IN"
          .SignText "TREBLE. FIND"
          .SignText "THEM BOTH.  "
          .byte ModeSignpostSetFlag, 16

;;; 91
NPC_NoArtifacts:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "THE PEOPLE  "
          .SignText "IN ANCHOR   "
          .SignText "NEED YOUR   "
          .SignText "HELP AGAINST"
          .SignText "THE MONSTERS"
          .byte ModeSignpostSetFlag, 16

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
