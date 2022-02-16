;;; Grizzards Source/Routines/ShowPointerText12.s
;;; Copyright © 2021-2022, Bruce-Robert Pocock

ShowPointerText12:
          jsr CopyPointerText12
          ;; fall through
ShowText12:
          .FarJMP AnimationsBank, ServiceWrite12Chars

;;; Audited 2022-02-16 BRPocock
