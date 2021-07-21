;;; Grizzards Source/Routines/ShowMonsterName.s
;;; Copyright © 2021 Bruce-Robert Pocock
ShowMonsterName:    
          lda CurrentMonsterPointer
          sta Pointer
          lda CurrentMonsterPointer + 1
          sta Pointer + 1

          jsr ShowPointerText

          lda Pointer
          clc
          adc # 6
          bcc +
          inc Pointer + 1
+
          sta Pointer

          ;; tail call, fall through
          
ShowPointerText:
          jsr CopyPointerText
          .FarJMP TextBank, ServiceDecodeAndShowText ; tail call
