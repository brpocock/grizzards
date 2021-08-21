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
          jsr SetCursorColor

PrepareCursor2:
          ldx MoveTarget
          beq ZeroTarget
          cpx # 4
          blt TopTarget
ZeroTarget:
          lda # 0
          sta pp3l
          stx WSYNC
          beq PrepareTopMonsters ; always taken
TopTarget:
          dex

PositionTopCursor:
          jsr PositionCursor

PrepareTopMonsters:
          stx WSYNC
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

PositionTopMonsters:
          jsr PositionMonsters

DrawTopMonsters:
          jsr DrawMonsters

          beq PrepareBottomCursor ; always taken

NoTopMonsters:
          jsr DrawNothing
          ;; fall through
;;; 
PrepareBottomCursor:
          lda # 0
          sta GRP1
          sta GRP0

          jsr SetCursorColor

PrepareCursor2Bottom:
          ldx MoveTarget
          cpx # 4
          bge HasBottomCursor
          lda # 0
          sta pp3l
          beq PrepareBottomMonsters ; always taken

HasBottomCursor:
          .rept 4
          dex
          .next

PostionBottomCursor:
          jsr PositionCursor

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

PositionBottomMonsters:
          jsr PositionMonsters

DrawBottomMonsters:
          jsr DrawMonsters
          stx WSYNC

FinishUp:
          sty GRP0
          sty GRP1

          sta WSYNC
          rts

NoBottomMonsters:
          jsr DrawNothing
          jmp FinishUp

;;; 
PositionCursor:
          stx WSYNC
          .Sleep 13
          lda CursorPosition, x
          and #$0f
          tay

CursorPosGross:
          dey
          bne CursorPosGross
          sta RESP1

          lda CursorPosition, x
          sta HMP1

          lda #$ff
          sta pp3l

          stx WSYNC
          rts
;;; 
PositionMonsters:
          sta WSYNC
          lda SpritePresence, x
          sta NUSIZ0
          nop
          nop
          nop
          lda SpritePosition, x
          and #$0f
          tay

GrossPositionMonsters:
          dey
          bne GrossPositionMonsters
          sta RESP0

          lda SpritePosition, x
          sta HMP0

          sta WSYNC
          .SleepX 71
          sta HMOVE

          lda pp3l
          sta GRP1
          rts
;;; 
DrawMonsters:
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
          rts

          .align $10, $20       ; avoid page crossing before HMOVE
DrawNothing:
          lda # 0
          sta GRP0
          sta WSYNC
          .SleepX 71
          sta HMOVE
          lda pp3l
          sta GRP1
          .if TV == NTSC
            .SkipLines 17
          .else
            .SkipLines 24
          .fi
          rts
;;; 
SetCursorColor:
          sta HMCLR

          .if TV == SECAM

          lda #COLWHITE
          sta COLUP1

          .else

          ldx MoveTarget
          bne +
          stx WSYNC
          stx WSYNC
          beq CursorColored ; always taken
+
          lda MonsterHP - 1, x
          beq +
          .ldacolu COLGRAY, $f
          bne SetColor ; always taken
+
          .ldacolu COLGRAY, 0
SetColor:
          sta COLUP1
CursorColored:

          .fi

          rts

          .bend
