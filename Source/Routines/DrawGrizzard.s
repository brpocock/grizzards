;;; Grizzards Source/Routines/DrawGrizzard.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
DrawGrizzard:       .block
          ldy #0
          sty VDELP0
          sty VDELP1
          sty REFP0
          .mva NUSIZ0, #NUSIZDouble
          sta NUSIZ1

          ldx CurrentGrizzard

          stx WSYNC
          sta HMCLR
          .SleepX 36
          sta RESP0
          nop
          sta RESP1

          .mva pp2h, #>GrizzardImages
          sta pp3h
          ldx CurrentGrizzard
          lda GrizzardPictureSelect, x
          clc
          asl a
          asl a
          asl a
          adc #<GrizzardImages - 1
          bcc +
          inc pp2h
          inc pp3h
+
          sta pp2l
          clc
          adc #GrizzardImages.Height
          bcc +
          inc pp3h
+
          sta pp3l

          lda GrizzardColor, x
          .if SECAM != TV
          ;; Carry doesn't matter, low bit is ignored
            adc #$02
          .fi
          sta COLUP0
          sta COLUP1

          ldy # 8
DrawLoop:
          lda (pp2l), y
          sta GRP0
          lda (pp3l), y
          sta GRP1
          stx WSYNC
          stx WSYNC

          .if SECAM != TV
            cpy # 8
            bge NoColorChange
            lda GrizzardColor, x          
            cpy # 4
            bge +
            ;; Carry doesn't matter, low bit is ignored
            sbc #$02
+
            sta COLUP0
            sta COLUP1
NoColorChange:
          .fi

          dey
          bne DrawLoop

          sty GRP0              ; Y = 0
          sty GRP1

          rts

          .bend

;;; Audited 2022-02-16 BRPocock
