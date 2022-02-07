;;; Grizzards Source/Routines/GetMonsterColors.s
;;; Copyright © 2022 Bruce-Robert Pocock

GetMonsterColors:   .block

          lda #>MonsterColors
          sta Pointer + 1

          lda CurrentMonsterNumber ; 0 … $2c
          asl a                 ; 0 … $58
          asl a                 ; 0 … $b0
          asl a                 ; 0 … $160
          bcc +
          inc Pointer + 1       ; 0 … $60
+
          adc #<MonsterColors
          bcc +
          inc Pointer + 1
+
          sta Pointer

          ;; unclear what I did wrong here.
          lda #$20
          and CurrentMonsterNumber
          beq +
          dec Pointer
+

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
