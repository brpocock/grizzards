;;; Grizzards Source/Routines/DrawBoss.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          
DrawBoss: .block

GetMonsterPointer:
          lda #>BossArt
          sta CombatSpritePointer + 1

GetMonsterArtPointer:
          lda CurrentMonsterArt
          clc

          tax

GetAnimationFrame:
          lda #$20
          bit ClockFrame
          beq GotFrame
          ;; skip over the MonsterArt to get to the MonsterArt2 frames
          txa
          ;; clc ; not needed, BIT does not affect Carry, still clear here
          adc # BossArt.Height / 16 * 2
          bcc +
          inc CombatSpritePointer + 1
+
          clc
          tax
GotFrame:

GetImagePointer:
          asl a
          asl a
          asl a
          asl a
          bcc +
          inc CombatSpritePointer + 1
+
          clc
          adc #<BossArt
          bcc +
          inc CombatSpritePointer + 1
+
          sta CombatSpritePointer

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
