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

          lda #$20
          and ClockFrame
          beq CommonFrame

          .Add16 pp2l, #<BossArt.Height * 2
          lda pp2h
          adc #>BossArt.Height * 2
          sta pp2h

          .Add16 pp3l, #<BossArt.Height * 2
          lda pp3h
          adc #>BossArt.Height * 2
          sta pp3h

CommonFrame:
          ldy #0
          sty VDELP0
          sty VDELP1
          lda #NUSIZDouble
          sta NUSIZ0
          sta NUSIZ1

DecideFlipFrame:
          lda # 1
          and ClockSeconds
          bne PrepareToDrawMonsterFlipped
          
PrepareToDrawMonster:
          sty REFP0
          sty REFP1

SetUpLeftHanded:
          stx WSYNC
          sta HMCLR
          .SleepX 36
          sta RESP0
          nop
          sta RESP1
          .NoPageCrossSince SetUpLeftHanded
          jmp DrawMonster

PrepareToDrawMonsterFlipped:
          lda #REFLECTED
          sta REFP0
          sta REFP1

SetUpRightHanded:
          stx WSYNC
          sta HMCLR
          .SleepX 36
          sta RESP1
          nop
          sta RESP0
          .NoPageCrossSince SetUpRightHanded

DrawMonster:
          ldy # 16
DrawMonsterLoop:
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
          bne DrawMonsterLoop

          sty GRP0
          sty GRP1

          .SkipLines 5

          rts

          .bend
