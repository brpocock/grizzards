;;; Grizzards Source/Routines/DrawGrizzard.s
;;; Copyright © 2021 Bruce-Robert Pocock
DrawGrizzard:
          lda #0
          sta VDELP0
          sta VDELP1
          lda #NUSIZDouble
          sta NUSIZ0
          sta NUSIZ1

          ldx CurrentGrizzard
          lda GrizzardColor, x
          sta COLUP0
          sta COLUP1

          sta WSYNC
          sta HMCLR
          .SleepX 36
          sta RESP0
          nop
          sta RESP1

          lda # >GrizzardImages
          sta Pointer + 1
          ldx CurrentGrizzard
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
          lda GrizzardImages + GrizzardImages.Height - 1, y
          sta GRP1
          sta WSYNC
          sta WSYNC
          dey
          bne -

          sty GRP0
          sty GRP1

          rts
