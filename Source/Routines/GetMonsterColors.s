;;; Grizzards Source/Routines/GetMonsterColors.s
;;; Copyright © 2022 Bruce-Robert Pocock

GetMonsterColors:   .block

          lda #>MonsterColors
          sta Pointer + 1

          lda CurrentMonsterNumber
          asl a
          asl a          
          asl a
          bcc +
          inc Pointer + 1
+
          adc #<MonsterColors
          bcc +
          inc Pointer + 1
+
          sta Pointer

          ldy # 0
          ldx # 8
-
          lda (Pointer), y
          sta PixelPointers, y
          iny
          dex
          bne -

          rts

          .bend
