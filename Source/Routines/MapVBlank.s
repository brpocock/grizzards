;;; Grizzards Source/Routines/MapVBlank.s
;;; Copyright © 2021 Bruce-Robert Pocock

MapVBlank:        .block
          lda GameMode
          cmp #ModeMap
          beq MovementLogic
          rts
          
MovementLogic:
          lda ClockFrame
          .BitBit $04
          beq DoSpriteMotion
          bne CheckSpriteCollision ; always taken
;;; 
DoSpriteMotion:
          lda Pause
          beq +
          jmp CheckSpriteCollision
+
          ldx SpriteCount
          beq UserInputStart
          cpx # 5
-         bge -                 ; hang

          dex

MoveSprites:
          lda SpriteMotion, x
          beq SpriteMoveDone
          cmp #SpriteRandomEncounter
          bne SpriteXMove
          jsr Random            ; Is there a random encounter?
          bne NoRandom
          jsr Random
          and #1
          bne NoRandom
          jmp FightWithSpriteX

NoRandom:
          dex
          bne MoveSprites
          beq CheckSpriteCollision ; always taken

SpriteXMove:        
          cmp #SpriteMoveIdle
          beq SpriteMoveNext
          lda SpriteMotion, x
          .BitBit SpriteMoveLeft
          bne +
          dec SpriteX, x
+
          .BitBit SpriteMoveRight
          bne +
          inc SpriteX, x
+
          .BitBit SpriteMoveUp
          bne +
          dec SpriteY, x
+
          .BitBit SpriteMoveDown
          bne +
          inc SpriteY, x
+
          
SpriteMoveNext:
          ;; Possibly change movement randomly
          jsr Random
          tay
          and #$07
          bne SpriteMoveDone

          tya
          .BitBit $10
          beq ChasePlayer

          .BitBit $20
          beq RandomlyMove

          lda SpriteMoveIdle
          sta SpriteMotion, x
          bne SpriteMoveDone    ; always taken

ChasePlayer:
          lda SpriteX, x
          cmp PlayerX
          beq ChaseUpDown
          bge ChaseRight
          lda #SpriteMoveLeft
          sta SpriteMotion, x
          bne SpriteMoveDone    ; always taken

ChaseRight:
          lda #SpriteMoveRight
          sta SpriteMotion, x
          bne SpriteMoveDone    ; always taken

ChaseUpDown:
          lda SpriteY, x
          cmp PlayerY
          bge ChaseDown
          lda #SpriteMoveUp
          sta SpriteMotion, x
          bne SpriteMoveDone    ; always taken

ChaseDown:
          lda #SpriteMoveDown
          sta SpriteMotion, x
          bne SpriteMoveDone    ; always taken

RandomlyMove:
          jsr Random
          and #$f0              ; random movement may be up+down or something stupid like that
          bne +
          lda #SpriteMoveIdle
+
          sta SpriteMotion, x
          ;; fall through
SpriteMoveDone:
          lda SpriteX, x
          cmp #ScreenLeftEdge
          bge LeftOK
          lda SpriteMotion, x
          and #~SpriteMoveLeft
          ora #SpriteMoveIdle
          sta SpriteMotion, x
          lda #ScreenLeftEdge + 1
          sta SpriteX, x
LeftOK:
          cmp #ScreenRightEdge
          blt RightOK
          lda SpriteMotion, x
          and #~SpriteMoveRight
          ora #SpriteMoveIdle
          sta SpriteMotion, x
          lda #ScreenRightEdge - 1
          sta SpriteX, x
RightOK:
          lda SpriteY, x
          cmp #ScreenTopEdge
          bge TopOK
          lda SpriteMotion, x
          and #~SpriteMoveUp
          ora #SpriteMoveIdle
          sta SpriteMotion, x
          lda #ScreenTopEdge + 1
          sta SpriteY, x
TopOK:
          cmp #ScreenBottomEdge
          blt BottomOK
          lda SpriteMotion, x
          and #~SpriteMoveDown
          ora #SpriteMoveIdle
          sta SpriteMotion, x
          lda #ScreenBottomEdge - 1
          sta SpriteY, x
BottomOK:

          dex
          bpl MoveSprites
          ;; fall through
;;; 
CheckSpriteCollision:
          lda CXP1FB
          and #$c0              ; hit playfield or ball
          beq MovementLogicDone

          ;; Who did we just draw?
          ldx SpriteFlicker
          lda SpriteMotion, x
          .BitBit SpriteMoveLeft
          bne SpriteCxRight
SpriteCxLeft:
          lda SpriteMotion, x
          and # SpriteMoveUp | SpriteMoveDown
          ora #SpriteMoveRight
          sta SpriteMotion, x
          inc SpriteX, x
          inc SpriteX, x
          bne SpriteCxUpDown    ; always taken

SpriteCxRight:
          lda SpriteMotion, x
          and # SpriteMoveUp | SpriteMoveDown
          ora #SpriteMoveLeft
          sta SpriteMotion, x
          dec SpriteX, x
          dec SpriteX, x
          ;; fall through
SpriteCxUpDown:
          lda SpriteMotion, x
          .BitBit SpriteMoveUp
          bne SpriteCxDown
SpriteCxUp:
          and # SpriteMoveLeft | SpriteMoveRight
          ora #SpriteMoveDown
          sta SpriteMotion, x
          inc SpriteY, x
          inc SpriteY, x
          bne MovementLogicDone ; always taken

SpriteCxDown:
          lda SpriteMotion, x
          and # SpriteMoveLeft | SpriteMoveRight
          ora #SpriteMoveDown
          sta SpriteMotion, x
          dec SpriteY, x
          dec SpriteY, x
          ;; fall through
MovementLogicDone:
;;; 
UserInputStart: 
          lda BumpCooldown
          beq HandleStick
          dec BumpCooldown

HandleStick:
          lda #0
          sta DeltaX
          sta DeltaY

          lda Pause
          bne CheckPlayerMove

          lda SWCHA
          .BitBit P0StickUp
          bne DoneStickUp

          ldx #-1
          stx DeltaY

DoneStickUp:
          .BitBit P0StickDown
          bne DoneStickDown

          ldx #1
          stx DeltaY

DoneStickDown:
          .BitBit P0StickLeft
          bne DoneStickLeft

          ldx #0
          stx Facing
          ldx #-1
          stx DeltaX

DoneStickLeft:
          .BitBit P0StickRight
          bne DoneStickRight

          ldx #$ff
          stx Facing
          ldx #1
          stx DeltaX

DoneStickRight:
          lda PlayerX
          clc
          adc DeltaX
          sta PlayerX

          lda PlayerY
          clc
          adc DeltaY
          sta PlayerY

          ;; fall through …
;;; 
;;; Collision Handling
CheckPlayerMove:
          lda CXP0FB
          and #$c0              ; hit playfield or ball
          beq NoBumpWall
          jsr BumpWall
          jmp DonePlayerMove

NoBumpWall:
          lda CXPPMM
          .BitBit $80              ; hit other sprite
          beq PlayerMoveOK

BumpSprite:
          jsr BumpWall

          lda BumpCooldown
          bne PlayerMoveOK
          
          ldx SpriteFlicker
          lda SpriteAction, x
          cmp #SpriteDoor
          beq DoorWithSprite
          cmp #SpriteCombat
          beq FightWithSprite
          cmp #SpriteGrizzardDepot
          beq EnterDepot
          cmp #SpriteGrizzard
          beq GetNewGrizzard
          and #SpriteProvinceDoor
          beq PlayerMoveOK      ; No action
          jmp ProvinceChange

FightWithSprite:
          ldx SpriteFlicker     ; ? Seems unnecessary
FightWithSpriteX:
          lda SpriteParam, x
          sta CurrentCombatEncounter
          lda SpriteIndex, x
          sta CurrentCombatIndex
          lda #ModeCombat
          sta GameMode
          rts

DoorWithSprite:
          lda SpriteParam, x
          sta CurrentMap
          ldy #ModeMapNewRoom
          sty GameMode
          jsr Overscan
          rts

GetNewGrizzard:
          lda #ModeNewGrizzard
          sta GameMode
          rts

PlayerMoveOK:
          lda #0
          lda PlayerX
          sta BlessedX
          lda PlayerY
          sta BlessedY

DonePlayerMove:
          ldy #$00
          rts

EnterDepot:
          lda #ModeGrizzardDepot
          sta GameMode
          rts

ProvinceChange:
          lda SpriteAction, x
          and #$70
          clc
          ror a
          ror a
          ror a
          ror a
          sta CurrentProvince
          lda SpriteParam, x
          sta CurrentMap
          jsr Overscan
          ldy #ModeMapNewRoom
          sty GameMode
          rts
;;; 
BumpWall:
          sta CXCLR

          lda BlessedX
          cmp PlayerX
          beq +
          sta PlayerX
          jmp BumpY
+
          lda DeltaX
          bne ShoveX
          jsr Random
          and # 1
          bne ShoveX
          lda #-1
ShoveX:
          sta DeltaX
          clc
          adc PlayerX
          sta PlayerX

BumpY:    
          lda BlessedY
          cmp PlayerY
          beq +
          sta PlayerY
          jmp DoneBump
+
          lda DeltaY
          bne ShoveY
          jsr Random
          and # 1
          bne ShoveY
          lda #-1
ShoveY:
          sta DeltaY
          clc
          adc PlayerY
          sta PlayerY

DoneBump:           
          lda #SoundBump
          sta NextSound

          rts
;;; 
          .bend
