ShowGrizzardName:
          jsr Prepare48pxMobBlob

          lda # >GrizzardNames
          sta Pointer + 1
          lda # 0 ;;; CurrentGrizzard 
          clc
          asl a                 ; × 2
          sta Temp
          asl a                 ; × 4
          adc Temp             ; × 6
          bcc +
          inc Pointer + 1
+
          sta Pointer

          jsr CopyPointerText
          jmp DecodeAndShowText
