;;; Grizzards Source/Routines/ShowGrizzardName.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
ShowGrizzardName:
          jsr Prepare48pxMobBlob

          lda # >GrizzardNames
          sta Pointer + 1
          lda CurrentGrizzard
          clc
          asl a                 ; × 2
          sta Temp
          asl a                 ; × 4
          adc Temp             ; × 6
          adc # <GrizzardNames
          bcc +
          inc Pointer + 1
+
          sta Pointer

          jsr CopyPointerText
          jmp DecodeAndShowText
