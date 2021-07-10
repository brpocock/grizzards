;;; Grizzards Source/Routines/DrawMonsterGroup.s
;;; Copyright © 2021 Bruce-Robert Pocock
DrawMonsterGroup:

GetMonsterPointer:

          lda #>MonsterArt
          sta CombatSpritePointer + 1

          lda CurrentMonsterArt
          clc
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

          ldx MoveTarget
          beq PrepareTopMonsters
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
          dex
          cpx # 4
          bge PrepareTopMonsters

PositionTopCursor:
          sta WSYNC
          .Sleep 13
          lda CursorPosition, x
          and #$0f
          tay
          sta HMCLR

TopCursorPos:
          dey
          bne TopCursorPos
          sta RESP1

          lda CursorPosition, x
          sta HMP1

          lda #$ff
          sta GRP1

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
          sta HMCLR
Monster1Pos:
          dey
          bne Monster1Pos
          sta RESP0

          lda SpritePosition, x
          sta HMP0

          sta WSYNC
          .SleepX 71
          sta HMOVE

DrawTopMonsters:
          ldy #7
-
          lda (CombatSpritePointer), y
          sta GRP0
          sta WSYNC
          sta WSYNC
          dey
          bpl -
          sty GRP0
          sty WSYNC

          jmp PrepareBottomCursor

NoTopMonsters:
          lda # 0
          sta GRP0
          ldy # 18
-
          sta WSYNC
          dey
          bne -

PrepareBottomCursor:
          lda # 0
          sta GRP1

          ldx MoveTarget
          dex
          cpx # 4
          blt PrepareBottomMonsters

          txa
          sec
          sbc # 4
          tax

PostionBottomCursor:
          sta WSYNC
          .Sleep 13
          lda CursorPosition, x
          and #$0f
          tay
          sta HMCLR

BottomCursorPos:
          dey
          bne BottomCursorPos
          sta RESP1

          lda CursorPosition, x
          sta HMP1

          lda #$ff
          sta GRP1

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
          sta HMCLR
Monster2Pos:
          dey
          bne Monster2Pos
          sta RESP0

          lda SpritePosition, x
          sta HMP0

          sta WSYNC
          .SleepX 71
          sta HMOVE

DrawBottomMonsters:
          ldy #7
-
          lda (CombatSpritePointer), y
          sta GRP0
          sta WSYNC
          sta WSYNC
          dey
          bpl -
          sty GRP0
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
          rts
