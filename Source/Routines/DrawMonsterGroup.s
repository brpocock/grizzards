;;; Grizzards Source/Routines/DrawMonsterGroup.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

DrawMonsterGroup:   .block

          CursorBits = pp5h
          CursorWidth = %11111100

          .if !DEMO
            jsr GetMonsterColors
          .fi

          .if PAL == TV
            stx WSYNC
          .fi

GetMonsterPointer:
          .mva pp4h, #>MonsterArt

GetMonsterArtPointer:
          ldx CurrentMonsterArt

          clc
;;; 
          .if !DEMO             ; demo does not have room for MonsterArt2

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
GotFrame:
          .fi                   ; if !DEMO
;;; 
          ldy # 0
          lda # 1
          bit ClockSeconds
          beq GotFlipMaybe

          ldy #REFLECTED
          gne GotFlip

GotFlipMaybe:
          lda #$20              ; if reflected & frame 0 we need one more scan line
          bit ClockFrame
          beq GotFlip

          .Sleep 5              ; just enough to break even somehow
          
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
          .mva NUSIZ1, #NUSIZDouble
;;; 
SetCursorColor:
          .if TV == SECAM

            .mva COLUP1, #COLWHITE
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
            lda EnemyHP - 1, x
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
          .mva CursorBits, #CursorWidth
SetUpCursor:
          dex
          jmp PositionCursor
;;;
          .if TV != PAL
            .align $10       ; XXX alignment
          .fi
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
          ldx EnemyHP + 0
          beq +
          ora #$01
+
          ldx EnemyHP + 1
          beq +
          ora #$02
+
          ldx EnemyHP + 2
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
          .mva CursorBits, #CursorWidth

PrepareBottomMonsters:
          .mva HMP1, #$80              ; don't move cursor again

          lda # 0
          ldx EnemyHP + 3
          beq +
          ora #$01
+
          ldx EnemyHP + 4
          beq +
          ora #$02
+
          ldx EnemyHP + 5
          beq +
          ora #$04
+
          tax
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
          sty GRP0              ; Y = 0
          sty GRP1
          sty REFP0
          lda MoveTarget

          rts
;;; 
          .if PORTABLE
            .align $10
          .fi

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

          .mva GRP1, CursorBits
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

          .mva GRP1, CursorBits

          .switch TV
          .case NTSC
            .SkipLines 17
          .case PAL
            .SkipLines 25
          .case SECAM
            .SkipLines 25
          .endswitch

          stx HMCLR
          rts                   ; return with Y = 0
;;; 
          .bend

;;; Audited 2022-02-16 BRPocock
