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
          sta pp2h
          sta pp3h
          ldx CurrentGrizzard
          lda GrizzardPictureSelect, x
          clc
          asl a
          asl a
          asl a
          adc # <GrizzardImages - 1
          bcc +
          inc pp2h
          inc pp3h
+
          sta pp2l
          clc
          adc # GrizzardImages.Height
          bcc +
          inc pp3h
+
          sta pp3l

          ldy # 8
-
          lda (pp2l), y
          sta GRP0
          lda (pp3l), y
          sta GRP1
          sta WSYNC
          sta WSYNC
          .if TV != NTSC
          sta WSYNC
          .fi
          dey
          bne -

          sty GRP0
          sty GRP1

          rts
