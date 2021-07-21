;;; Grizzards Source/Routines/DrawMonsterGroup.s
;;; Copyright © 2021 Bruce-Robert Pocock
DrawMonsterGroup:   .block

GetMonsterPointer:
          lda #>MonsterArt
          sta CombatSpritePointer + 1

GetMonsterArtPointer:
          lda CurrentMonsterArt
          clc
          asl a
          asl a
          asl a
          bcc +
          inc CombatSpritePointer + 1
+
          adc #<MonsterArt
          bcc +
          inc CombatSpritePointer + 1
+
          sta CombatSpritePointer

PrepareToDrawMonsters:
          lda # 0
          sta VDELP0
          sta VDELP1
          sta NUSIZ0
          sta NUSIZ1
          sta pp3l
;;; 
PrepareTopCursor:
          sta HMCLR

          ldx MoveTarget
          bne +
          stx WSYNC
          stx WSYNC
          beq PrepareTopMonsters ; always taken
+
          lda MonsterHP - 1, x
          beq +
          .ldacolu COLGRAY, $f
          bne SetTopCursorColor ; always taken
+
          .ldacolu COLGRAY, 0
SetTopCursorColor:
          sta COLUP1

PrepareCursor2:
          ldx MoveTarget
          cpx # 4
          blt +
          lda # 0
          sta pp3l
          beq PrepareTopMonsters ; always taken
+
          dex

PositionTopCursor:
          sta WSYNC
          .Sleep 13
          lda CursorPosition, x
          and #$0f
          tay

TopCursorPos:
          dey
          bne TopCursorPos
          sta RESP1

          lda CursorPosition, x
          sta HMP1

          lda #$ff
          sta pp3l

PrepareTopMonsters:
          lda # 0
          ldx MonsterHP + 0
          beq +
          ora #$01
+
          ldx MonsterHP + 1
          beq +
          ora #$02
+
          ldx MonsterHP + 2
          beq +
          ora #$04
+
          tax
          beq NoTopMonsters

PrepareToPositionTopMonsters:
          sta WSYNC
          lda SpritePresence, x
          sta NUSIZ0
          nop
          nop
          nop
          lda SpritePosition, x
          and #$0f
          tay

PositionTopMonsters:
          dey
          bne PositionTopMonsters
          sta RESP0

          lda SpritePosition, x
          sta HMP0

          sta WSYNC
          .SleepX 71
          sta HMOVE

          lda pp3l
          sta GRP1

DrawTopMonsters:
          ldy # 7
-
          lda (CombatSpritePointer), y
          sta GRP0
          sta WSYNC
          sta WSYNC
          .if TV != NTSC
          sta WSYNC
          .fi
          dey
          bpl -
          ldy # 0
          sty GRP0
          sty GRP1

          beq PrepareBottomCursor ; always taken

NoTopMonsters:
          lda # 0
          sta GRP0
          sta WSYNC
          .SleepX 71
          sta HMOVE
          lda pp3l
          sta GRP1
          .if TV == NTSC
            .SkipLines 18
          .else
            .SkipLines 24
          .fi
;;; 
PrepareBottomCursor:
          lda # 0
          sta GRP1
          sta GRP0

          sta HMCLR

          ldx MoveTarget
          bne +
          stx WSYNC
          stx WSYNC
          beq PrepareBottomMonsters ; always taken
+
          lda MonsterHP - 1, x
          beq +
          .ldacolu COLGRAY, $f
          bne SetBottomCursorColor ; always taken
+
          .ldacolu COLGRAY, 0
SetBottomCursorColor:
          sta COLUP1

PrepareCursor2B:
          ldx MoveTarget
          cpx # 4
          bge +
          lda # 0
          sta pp3l
          beq PrepareBottomMonsters ; always taken
+
          .rept 4
          dex
          .next

PostionBottomCursor:
          sta WSYNC
          .Sleep 13
          lda CursorPosition, x
          and #$0f
          tay

BottomCursorPos:
          dey
          bne BottomCursorPos
          sta RESP1

          lda CursorPosition, x
          sta HMP1

          lda #$ff
          sta pp3l

PrepareBottomMonsters:
          lda # 0
          ldx MonsterHP + 3
          beq +
          ora #$01
+
          ldx MonsterHP + 4
          beq +
          ora #$02
+
          ldx MonsterHP + 5
          beq +
          ora #$04
+
          tax
          beq NoBottomMonsters

PrepareToPositionBottomMonsters:
          sta WSYNC
          lda SpritePresence, x
          sta NUSIZ0
          nop
          nop
          nop
          lda SpritePosition, x
          and #$0f
          tay

PositionBottomMonsters:
          dey
          bne PositionBottomMonsters
          sta RESP0

          lda SpritePosition, x
          sta HMP0

          sta WSYNC
          .SleepX 71
          sta HMOVE

          lda pp3l
          sta GRP1

DrawBottomMonsters:
          ldy # 7
-
          lda (CombatSpritePointer), y
          sta GRP0
          sta WSYNC
          sta WSYNC
          .if TV != NTSC
          sta WSYNC
          .fi
          dey
          bpl -
FinishUp:
          ldy # 0
          sty GRP0
          sty GRP1

          sta WSYNC
          sta WSYNC
          rts

NoBottomMonsters:
          lda # 0
          sta GRP0
          sta WSYNC
          .SleepX 71
          sta HMOVE
          lda pp3l
          sta GRP1
          .if TV == NTSC
            .SkipLines 18
          .else
            .SkipLines 24
          .fi
          jmp FinishUp

          .bend
