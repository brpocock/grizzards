;;; Grizzards Source/Routines/DrawMonsterGroup.s
;;; Copyright © 2021 Bruce-Robert Pocock
DrawMonsterGroup:

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

          dex
          lda MonsterHP, x
          beq +
          .ldacolu COLGRAY, $f
          jmp SetCursorColor
+
          .ldacolu COLGRAY, 0
SetCursorColor:
          sta COLUP1

PrepareCursor2:
          ldx MoveTarget
          cpx # 4
          blt +
          lda # 0
          sta pp3l
          jmp PrepareTopMonsters
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

Monster1Pos:
          dey
          bne Monster1Pos
          sta RESP0

          lda SpritePosition, x
          sta HMP0

          sta WSYNC
          .SleepX 71
          sta HMOVE

          lda pp3l
          sta GRP1
          
DrawTopMonsters:
          ldy #7
-
          lda (CombatSpritePointer), y
          sta GRP0
          sta WSYNC
          sta WSYNC
          dey
          bpl -
          ldy # 0
          sty GRP0
          sty GRP1

          jmp PrepareBottomCursor

NoTopMonsters:
          lda # 0
          sta GRP0
          ldy # 18
-
          sta WSYNC
          dey
          bne -

;;; 

PrepareBottomCursor:
          sta HMCLR

          lda # 0
          sta GRP1
          sta GRP0

          ldx MoveTarget
          bne +
          stx WSYNC
          stx WSYNC
          beq PrepareBottomMonsters ; always taken

+
          dex
          lda MonsterHP, x
          beq +
          .ldacolu COLGRAY, $f
          jmp SetBottomCursorColor
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
          jmp PrepareBottomMonsters
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

Monster2Pos:
          dey
          bne Monster2Pos
          sta RESP0

          lda SpritePosition, x
          sta HMP0

          sta WSYNC
          .SleepX 71
          sta HMOVE

          lda pp3l
          sta GRP1

DrawBottomMonsters:
          ldy #7
-
          lda (CombatSpritePointer), y
          sta GRP0
          sta WSYNC
          sta WSYNC
          dey
          bpl -
          ldy # 0
          sty GRP0
          sty GRP1
          sta WSYNC
          sta WSYNC
          rts

NoBottomMonsters:
          lda # 0
          sta GRP0
          ldy # 20
-
          sta WSYNC
          dey
          bne -

;;; 

          rts
