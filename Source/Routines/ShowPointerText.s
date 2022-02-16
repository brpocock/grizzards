;;; Grizzards Source/Routines/ShowPointerText.s
;;; Copyright © 2021-2022, Bruce-Robert Pocock

ShowPointerText:
          jsr CopyPointerText
          ;; fall through
ShowText:
          .FarJMP TextBank, ServiceDecodeAndShowText

