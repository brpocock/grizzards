;;; Grizzards Source/Routines/DrawMonsterGroup.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          .if 3 == BANK && SECAM == TV
            .align $20            ; XXX alignment
          .fi
DrawMonsterGroup:   .block

          CursorBits = pp5h

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
          .if SECAM == TV
            beq Frame1
          .else
            beq GotFrame
          .fi
          ;; skip over the MonsterArt to get to the MonsterArt2 frames
          txa
          ;; clc ; not needed, BIT does not affect Carry, still clear here
          adc # MonsterArt.Height / 8
          bcc +
          inc pp4h
+
          clc
          tax

          .if SECAM == TV
            gcc GotFrame
Frame1:
            stx WSYNC
          .fi
;;; 
GotFrame:
          .fi                   ; if !DEMO
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
          sty CursorBits
          lda #NUSIZDouble
          sta NUSIZ1
;;; 
SetCursorColor:

          .if TV == SECAM

            lda #COLWHITE
            sta COLUP1
            ldx MoveTarget
            bne +
            stx WSYNC
+

          .else

            ldx MoveTarget
            bne TargetIsMonster
            .SkipLines 3
            jmp CursorColored

TargetIsMonster:
            lda MonsterHP - 1, x
            beq MonsterGone
            lda # 0               ; black
            geq SetColor

MonsterGone:
            .ldacolu COLGRAY, $e
SetColor:
            sta COLUP1
CursorColored:

          .fi
;;; 
PrepareTopCursor:
          ldx MoveTarget
          beq NoTopTarget

          cpx # 4
          blt TopTarget

          dex                   ; get column number
          dex                   ; for monsters 4-6
          dex

NoTopTarget:
          ldy # 0
          sty CursorBits
          lda MoveTarget
          bne SetUpCursor
          .if SECAM == TV
            .SkipLines 2
          .fi
          jmp CursorReady

TopTarget:
          lda #%11111100
          sta CursorBits
SetUpCursor:
          dex
          jmp PositionCursor
;;;
          .align $10, $ea       ; XXX alignment NOPs
PositionCursor:
          stx HMCLR

          .page

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

          .endp

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

          ldx MoveTarget
          beq NoBottomTarget

          .if SECAM == TV
            stx WSYNC
          .fi
          stx WSYNC
          cpx # 4
          bge BottomTarget

NoBottomTarget:
          sty CursorBits
          jmp PrepareBottomMonsters

BottomTarget:
          lda #%11111100
          sta CursorBits

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

          lda #$80              ; don't move cursor again
          sta HMP1

          cpx # 0
          bne PositionBottomMonsters

          jsr DrawNothing
          jmp FinishUp

PositionBottomMonsters:
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

          rts
;;; 
          .page
PositionMonsters:
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

          .endp

          stx WSYNC
          lda SpritePosition, x ; 4
          sta HMP0              ; 3
          .SleepX 71 - 7
          stx HMOVE

          lda CursorBits
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
          .if TV != NTSC
            stx WSYNC
          .fi
          inx
          dey
          bpl DrawMonsterLoop

          ldy # 0
          sty GRP0
          sty GRP1
          ;; must return with Y=0 and Z flag set
          rts
;;; 
DrawNothing:

          ldy # 0
          sty GRP0

          .page
          stx WSYNC
          .SleepX 71
          stx HMOVE
          .endp

          lda CursorBits
          sta GRP1

          .switch TV
          .case NTSC
            .SkipLines 17
          .case PAL
            .SkipLines 24
          .case SECAM
            .SkipLines 25
          .endswitch

          stx HMCLR
          rts                   ; return with Y = 0
;;; 
          .bend
