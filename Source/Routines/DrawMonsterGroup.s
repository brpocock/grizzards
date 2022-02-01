;;; Grizzards Source/Routines/DrawMonsterGroup.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
DrawMonsterGroup:   .block

          .if !DEMO
          jsr GetMonsterColors
          .fi

GetMonsterPointer:
          lda #>MonsterArt
          sta pp4h

GetMonsterArtPointer:
          lda CurrentMonsterArt
          clc

          tax
;;; 
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
          inc pp4h
+
          clc
          tax
GotFrame:
          .fi
;;; 
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
          inc pp4h
+
          clc
          adc #<MonsterArt
          bcc +
          inc pp4h
+
          sta pp4l

PrepareToDrawMonsters:
          ldy # 0
          sty VDELP0
          sty VDELP1
          sty NUSIZ0
          sty pp5h
          lda #NUSIZDouble
          sta NUSIZ1
;;; 
PrepareTopCursor:
          jsr SetCursorColor

          ldx MoveTarget
          beq NoTopTarget

          cpx # 4
          blt TopTarget

          .rept 3
          dex
          .next
          
NoTopTarget:
          ldy # 0
          sty pp5h
          lda MoveTarget
          beq CursorReady

          gne SetUpCursor

TopTarget:
          lda #%11111100
          sta pp5h
SetUpCursor:
          dex
;;; 
PositionCursor:
          .option allow_branch_across_page=0

          stx HMCLR
          stx WSYNC
          .Sleep 13
          lda CursorPosition, x ; 4 / 17
          and #$0f              ; 2 / 19
          tay                   ; 2 / 21

CursorPosGross:
          dey
          bne CursorPosGross
          stx RESP1

          lda CursorPosition, x
          sta HMP1

          .option allow_branch_across_page=1
          .NoPageCrossSince PositionCursor

CursorReady:

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

PositionTopMonsters:
          jsr PositionMonsters

DrawTopMonsters:
          jsr DrawMonsters        ; returns with Y = 0 and +Z
          geq PrepareBottomCursor

NoTopMonsters:
          jsr DrawNothing       ; returns with Y = 0
          ;; fall through
;;; 
PrepareBottomCursor:
          sty GRP1
          sty GRP0

          jsr SetCursorColor

          ldx MoveTarget
          beq NoBottomTarget

          stx WSYNC
          stx WSYNC
          cpx # 4
          bge BottomTarget

NoBottomTarget:
          sty pp5h
          jmp PrepareBottomMonsters

BottomTarget:
          lda #%11111100
          sta pp5h

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
          bne PositionBottomMonsters

          jsr DrawNothing
          jmp FinishUp

PositionBottomMonsters:
          lda #$80
          sta HMP1              ; do not move cursor on HMOVE
          jsr PositionMonsters

DrawBottomMonsters:
          jsr DrawMonsters      ; returns with Y =0 and +Z
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
          .fi

          rts
;;; 
PositionMonsters:
          .option allow_branch_across_page=0

          stx WSYNC
          lda SpritePresence, x ; 4 / 4
          sta NUSIZ0            ; 3 / 7
          .Sleep 6              ; 6 / 13
          lda SpritePosition, x ; 4 / 17
          and #$0f              ; 2 / 19
          tay                   ; 2 / 21

GrossPositionMonsters:
          dey
          bne GrossPositionMonsters
          stx RESP0

          .option allow_branch_across_page=1
          .NoPageCrossSince PositionMonsters

          lda SpritePosition, x
          sta HMP0

          stx WSYNC
          .SleepX 71
          stx HMOVE
          stx HMCLR

          lda pp5h
          sta GRP1
          rts
;;; 
DrawMonsters:
          ldy # 7
          ldx # 0
DrawMonsterLoop:
          lda (pp4l), y
          sta GRP0

          .if !DEMO
          lda PixelPointers, x
          sta COLUP0
          .fi

          stx WSYNC
          stx WSYNC
          inx
          dey
          bpl DrawMonsterLoop

          ldy # 0
          sty GRP0
          sty GRP1
          ;; must return with Y=0 and Z flag set
          rts
;;; 
SetCursorColor:

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
          .option allow_branch_across_page=0

          ldy # 0
          sty GRP0

          stx WSYNC
          .SleepX 71
          stx HMOVE
          stx HMCLR

          .option allow_branch_across_page=1
          .NoPageCrossSince DrawNothing

          lda pp5h
          sta GRP1

          .if TV == NTSC
            .SkipLines 16
          .else
            .SkipLines 24
          .fi
          rts                   ; return with Y = 0
;;; 
          .bend
