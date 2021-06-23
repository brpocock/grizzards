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
          lda #0
          sta VDELP0
          sta VDELP1
          sta NUSIZ0
          sta NUSIZ1
          
          ldy # 14              ; offset of monster color
          lda (CurrentMonsterPointer), y
          sta COLUP0

          ldx MoveTarget
          beq PrepareTopMonsters
          dex
          lda MonsterHP, x
          beq +
          .ldacolu COLYELLOW, $f
          jmp SetCursorColor
+
          .ldacolu COLGRAY, 0
SetCursorColor:       
          sta COLUP1

PrepareCursor2:
          ldx MoveTarget
          dex
          cpx #2
          bpl PrepareTopMonsters

PositionTopCursor:
          lda SpritePosition, x
          sta HMCLR

          sec
          sta WSYNC
TopCursorPos:
          sbc #15
          bcs TopCursorPos
          sta RESP1

          eor #$07
          asl a
          asl a
          asl a
          asl a
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
          lda SpritePresence, x
          sta NUSIZ0
          lda SpritePosition, x

PositionTopMonsters:
          sec
          sta WSYNC
Monster1Pos:
          sbc #15
          bcs Monster1Pos
          sta RESP0

          eor #$07
          asl a
          asl a
          asl a
          asl a
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

          jmp PrepareBottomCursor

NoTopMonsters:
          lda # 0
          sta GRP0
          ldy # 14
-
          sta WSYNC
          dey
          bne -

PrepareBottomCursor:
          lda # 0
          sta GRP1
          
          ldx MoveTarget
          dex
          cpx #3
          bpl PrepareBottomMonsters

          txa
          sec
          sbc #4
          tax

          lda SpritePosition,x
PostionBottomCursor:
          sta HMCLR

          sec
          sta WSYNC
BottomCursorPos:
          sbc #15
          bcs BottomCursorPos
          sta RESP1

          eor #$07
          asl a
          asl a
          asl a
          asl a
          sta HMP1

          sta WSYNC
          .SleepX 71
          sta HMOVE

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
          lda SpritePresence, x
          sta NUSIZ0
          lda SpritePosition, x
          
PositionBottomMonsters:
          sta WSYNC
          sta HMCLR

          sec
          sta WSYNC
Monster2Pos:
          sbc # 15
          bcs Monster2Pos
          sta RESP0

          eor #$07
          asl a
          asl a
          asl a
          asl a
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
          rts

NoBottomMonsters:
          lda # 0
          sta GRP0
          ldy # 14
-
          sta WSYNC
          dey
          bne -
          rts
