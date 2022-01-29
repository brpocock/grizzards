;;; Grizzards Source/Routines/DemoDrawBoss.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          ;; In Demo mode we don't have the 16×16px boss art
          ;; we only have the one frame and its flipped version at 8×8px
          ;; so this alternate (older) boss drawing routine is needed
DemoDrawBoss:       .block

GetMonsterPointer:
          lda #>MonsterArt
          sta CombatSpritePointer + 1

GetMonsterArtPointer:
          lda CurrentMonsterArt
          clc

          tax

          ldy # 0
          lda # 1
          bit ClockSeconds
          beq GotFlip
          ldy #REFLECTED
GotFlip:
          sty REFP0
          txa

GetImagePointer:
          asl a
          asl a
          asl a
          bcc +
          inc CombatSpritePointer + 1
+
          clc
          adc #<MonsterArt
          bcc +
          inc CombatSpritePointer + 1
+
          sta CombatSpritePointer

PrepareToDrawMonsters:
          lda # 0
          sta VDELP0
          sta NUSIZ0

DrawMajorMonster:

PositionMajorMonster:
          stx WSYNC
          lda # NUSIZQuad
          sta NUSIZ0
          nop
          nop
          nop
          ldy #$70
GrossPositionMajorMonster:
          dey
          bne GrossPositionMajorMonster
          sta RESP0

DrawMajorMonsterLines:
          ldy # 7
DrawMajorMonsterLoop:
          lda (CombatSpritePointer), y
          sta GRP0
          .if TV == NTSC
            .SkipLines 4
          .else
            .SkipLines 6
          .fi
          dey
          bpl DrawMajorMonsterLoop

          ldy # 0
          sty GRP0
          sty GRP1
          sty REFP0

          .SkipLines 2

          rts

          .bend