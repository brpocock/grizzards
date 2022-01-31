;;; Grizzards Source/Routines/FinalScore.s
;;; Copyright © 2022 Bruce-Robert Pocock

FinalScore:         .block
          
          .SetPointer WinnerText
          jsr ShowPointerText
          .SetPointer WinnerText + 6
          jsr ShowPointerText

          jsr DecodeScore
          .FarJSR TextBank, ServiceDecodeAndShowText

          rts

WinnerText:
          .MiniText "YOU   "
          .MiniText "  WON!"

          .bend
