;;; Grizzards Source/Routines/GetMonsterColors.s
;;; Copyright © 2022 Bruce-Robert Pocock

          ;; Takes CurrentMonsterNumber, and fills out the 8 color band values
          ;; into the PixelPointers + 0 … + 7
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

          ;; unclear what I did wrong here. XXX there is an arithmetic error, this fixes
          lda #$20
          and CurrentMonsterNumber
          beq +
          dec Pointer
+

          ldy # 0
-
          lda (Pointer), y
          sta PixelPointers, y
          iny
          cpy # 8
          bne -

          rts

          .bend

;;; Audited 2022-02-15 BRPocock
