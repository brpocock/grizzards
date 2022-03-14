;;; Grizzards Source/Routines/NoSavePassword.s
;;; Copyright © 2022 Bruce-Robert Pocock

NoSavePassword:     .block

          lda # 0
          ;; 14 for GlobalGameData + 8 for ProvinceFlags + 5 for additional Grizzard info
          ldy # 27
-
          sta GlobalGameData - 1, y
          dey
          bne -

Loop:     
          .WaitScreenBottom
          .WaitScreenTop

          .ldacolu COLBLUE, 0
          stx WSYNC
          sta COLUBK

          .ldacolu COLYELLOW, $f
          sta COLUP0
          sta COLUP1

          .SetPointer CodeText
          jsr ShowPointerText

          

          jmp Loop

;;; 

CodeText:
          .MiniText " CODE "

          .bend
