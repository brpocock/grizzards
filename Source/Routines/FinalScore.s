;;; Grizzards Source/Routines/FinalScore.s
;;; Copyright © 2022 Bruce-Robert Pocock

FinalScore:         .block

          .SetPointer NameEntryBuffer
          jsr ShowPointerText

          .SetPointer WinnerText
          jsr ShowPointerText

          jsr DecodeScore

          .FarJSR TextBank, ServiceDecodeAndShowText

          rts

WinnerText:
          .MiniText "  WON!"

          .bend

;;; Audited 2022-02-15 BRPocock
