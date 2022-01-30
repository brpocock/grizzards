;;; Grizzards Source/Routines/DrawMonsterGroup.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
DrawMonsterGroup:   .block

GetMonsterPointer:
          lda #>MonsterArt
          sta CombatSpritePointer + 1

GetMonsterArtPointer:
          lda CurrentMonsterArt
          clc

          tax

          .if !DEMO
GetAnimationFrame:
          lda #$20
          bit ClockFrame
          beq GotFrame
          ;; skip over the MonsterArt to get to the MonsterArt2 frames
          txa
          ;; clc ; not needed, BIT does not affect Carry, still clear here
          adc # MonsterArt.Height / 8
          bcc +
          inc CombatSpritePointer + 1
+
          clc
          tax
GotFrame:
          .fi

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

          .if !DEMO

          lda #>MonsterColorTable
          sta MonsterColorPointer + 1
          
          lda CurrentMonsterNumber
          .rept 4
          asl a
          bcc +
          inc MonsterColorPointer + 1
+
          .next

          adc #<MonsterColorTable
          bcc +
          inc MonsterColorPointer + 1
+
          sta MonsterColorPointer

          .fi

PrepareToDrawMonsters:
          lda # 0
          sta VDELP0
          sta VDELP1
          sta NUSIZ0
          sta pp3l
          lda #NUSIZDouble
          sta NUSIZ1
;;; 
PrepareTopCursor:
          jsr SetCursorColor

PrepareCursor2:
          ldx MoveTarget
          beq NoTarget
          cpx # 4
          blt TopTarget
NoTarget:
          .if SECAM == TV
          stx WSYNC
          .fi
NoTopTarget:
          lda # 0
          sta pp3l
          geq PrepareTopMonsters

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
          geq PrepareBottomCursor

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
          geq PrepareBottomMonsters

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
          ;; fall through
;;; 
FinishUp:
          sty GRP0
          sty GRP1
          sty REFP0
          lda MoveTarget

          .if SECAM == TV
          bne +
          stx WSYNC
+
          .SkipLines 3

          .else

          ;; NTSC and PAL for some reason (Weird!)
          beq +
          stx WSYNC
+
          .fi
          rts
;;; 
NoBottomMonsters:
          jsr DrawNothing
          jmp FinishUp
;;; 
          .fill $00             ; alignment XXX
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
          .NoPageCrossSince PositionCursor

          lda CursorPosition, x
          sta HMP1

          lda #%11111100
          sta pp3l

          stx WSYNC
          rts
;;; 
          .fill $08             ; alignment XXX
PositionMonsters:
          stx WSYNC
          lda SpritePresence, x
          sta NUSIZ0
          .Sleep 6
          lda SpritePosition, x
          and #$0f
          tay

GrossPositionMonsters:
          dey
          bne GrossPositionMonsters
          sta RESP0
          .NoPageCrossSince PositionMonsters

          lda SpritePosition, x
          sta HMP0

          stx WSYNC
          .SleepX 71
          sta HMOVE

          lda pp3l
          sta GRP1
          rts
;;; 
DrawMonsters:
          ldy # 7
DrawMonsterLoop:
          lda (CombatSpritePointer), y
          sta GRP0
          stx WSYNC
          stx WSYNC
          .if TV != NTSC
            stx WSYNC
          .fi
          dey
          bpl DrawMonsterLoop

          ldy # 0
          sty GRP0
          sty GRP1
          ;; must return with Y=0 and Z flag set
          rts
;;; 
SetCursorColor:
          sta HMCLR

          .if TV == SECAM

          lda #COLWHITE
          sta COLUP1

          .else

          ldx MoveTarget
          bne TargetIsMonster
          stx WSYNC
          stx WSYNC
          geq CursorColored

TargetIsMonster:
          lda MonsterHP - 1, x
          beq MonsterGone
          .ldacolu COLGRAY, $0
          geq SetColor

MonsterGone:
          .ldacolu COLGRAY, $e
SetColor:
          sta COLUP1
CursorColored:

          .fi

          rts
;;; 
          .fill $00             ; alignment XXX
DrawNothing:
          lda # 0
          sta GRP0

          stx WSYNC
          .SleepX 71
          sta HMOVE

          .NoPageCrossSince DrawNothing

          lda pp3l
          sta GRP1

          .if TV == NTSC
            .SkipLines 17
          .else
            .SkipLines 24
          .fi
          rts
;;; 
          .bend
