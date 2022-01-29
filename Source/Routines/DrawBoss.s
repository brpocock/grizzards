;;; Grizzards Source/Routines/DrawBoss.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          
DrawBoss: .block

GetMonsterPointer:
          lda #>BossArt - 1
          sta CombatSpritePointer + 1

GetMonsterArtPointer:
          lda CurrentMonsterArt

GetImagePointer:
          ldx # 4
-
          clc
          asl a
          bcc +
          inc CombatSpritePointer + 1
+
          dex
          bne -
          clc
          adc #<BossArt - 1
          bcc +
          inc CombatSpritePointer + 1
+
          sta CombatSpritePointer
          sta pp2l
          ldx CombatSpritePointer + 1
          stx pp2h
          stx pp3h
          clc
          adc #<BossArt.Height
          bcc +
          inc pp3h
+
          sta pp3l
          lda pp3h
          clc
          adc #>BossArt.Height
          sta pp3h

          lda # 1
          bit ClockSeconds
          beq PrepareToDrawMonster

          lda pp2l
          clc
          adc #<BossArt.Height * 2
          bcc +
          inc pp2h
+
          sta pp2l
          lda pp2h
          adc #>BossArt.Height * 2
          sta pp2h

          lda pp3l
          clc
          adc #<BossArt.Height * 2
          bcc +
          inc pp3h
+
          sta pp3l
          lda pp3h
          adc #>BossArt.Height * 2
          sta pp3h

          
PrepareToDrawMonster:
          lda #0
          sta VDELP0
          sta VDELP1
          sta REFP0
          lda #NUSIZDouble
          sta NUSIZ0
          sta NUSIZ1

          stx WSYNC
          sta HMCLR
          .SleepX 36
          sta RESP0
          nop
          sta RESP1

          ldy # 16
-
          lda (pp2l), y
          sta GRP0
          lda (pp3l), y
          sta GRP1
          stx WSYNC
          stx WSYNC
          .if TV != NTSC
          stx WSYNC
          .fi
          dey
          bne -

          sty GRP0
          sty GRP1

          
          rts

          .bend
