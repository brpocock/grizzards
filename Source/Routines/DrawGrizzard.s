DrawGrizzard:
          lda #0
          sta VDELP0
          sta VDELP1
          sta NUSIZ0
          sta NUSIZ1

          ldx CurrentGrizzard
          lda GrizzardColor, x
          sta COLUP0
          sta COLUP1

          ;; TODO center Grizzard image
          ;; sta WSYNC
          ;; sta HMCLR
          ;; .SleepX 37
          ;; sta RESP0
          ;; sta RESP1

          lda # >GrizzardImages
          sta Pointer + 1
          lda GrizzardPictureSelect, x
          clc
          asl a
          asl a
          asl a
          adc # <GrizzardImages
          bcc +
          inc Pointer + 1
+
          sta Pointer
          
          ldy # 8
-
          lda GrizzardImages - 1, y
          sta GRP0
          lda GrizzardImages + 7, y
          sta GRP1
          sta WSYNC
          sta WSYNC
          dey
          bne -

          sty GRP0
          sty GRP1

          rts
