;;; Grizzards Source/Routines/MapVBlank.s
;;; Copyright © 2021 Bruce-Robert Pocock

MapVBlank:        .block
          lda GameMode
          cmp #ModeMap
          beq MovementLogic
          rts

MovementLogic:
          jsr CheckSpriteCollision
          jsr DoSpriteMotion

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
          cmp #SpriteSign
          beq ReadSign
          cmp #SpritePerson
          beq ReadSign
          and #SpriteProvinceDoor
          beq PlayerMoveOK      ; No action
          jmp ProvinceChange

ReadSign:
          lda SpriteParam, x
          sta SignpostIndex
          lda #ModeSignpost
          sta GameMode
          rts

FightWithSprite:
          ldx SpriteFlicker     ; ? Seems unnecessary XXX
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
          sta NextMap
          ldy #ModeMapNewRoom
          sty GameMode
          .WaitForTimer
          rts

GetNewGrizzard:
          lda #ModeNewGrizzard
          sta GameMode
          rts

PlayerMoveOK:
          lda PlayerX
          sta BlessedX
          lda PlayerY
          sta BlessedY
DonePlayerMove:
          ldy #$00
          beq UserInputStart    ; always taken

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
          sta NextMap
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

ApplyStick:

FractionalMovement: .macro deltaVar, fractionVar, positionVar, pxPerSecond
          .block
          lda \fractionVar
          ldx \deltaVar
          cpx #0
          beq DoneMovement
          bpl MovePlus
MoveMinus:
          sec
          sbc #ceil(\pxPerSecond * $80)
          sta \fractionVar
          bcs DoneMovement
          adc #$80
          sta \fractionVar
          dec \positionVar
          jmp DoneMovement

MovePlus:
          clc
          adc #ceil(\pxPerSecond * $80)
          sta \fractionVar
          bcc DoneMovement
          sbc #$80
          sta \fractionVar
          inc \positionVar
DoneMovement:
          .bend
          .endm

          MovementDivisor = 0.85
          ;; Make MovementDivisor  relatively the same in  both directions
	;; so diagonal movement forms a 45° line
          MovementSpeedX = ((40.0 / MovementDivisor) / FramesPerSecond)
          .FractionalMovement DeltaX, PlayerXFraction, PlayerX, MovementSpeedX
          MovementSpeedY = ((30.0 / MovementDivisor) / FramesPerSecond)
          .FractionalMovement DeltaY, PlayerYFraction, PlayerY, MovementSpeedY

          ;; fall through …
;;; 
          rts
          .bend

          
;;; 
CheckSpriteCollision:         .block
          lda CXP1FB
          and #$c0              ; hit playfield or ball
          beq CollisionDone

          ;; Who did we just draw?
          ldx SpriteFlicker
          lda SpriteMotion, x
          .BitBit SpriteMoveLeft
          beq SpriteCxRight
SpriteCxLeft:
          and # SpriteMoveUp | SpriteMoveDown
          ora #SpriteMoveRight
          sta SpriteMotion, x
          inc SpriteX, x
          inc SpriteX, x
          bne SpriteCxUpDown    ; always taken

SpriteCxRight:
          .BitBit SpriteMoveRight
          beq SpriteCxUpDown
          and # SpriteMoveUp | SpriteMoveDown
          ora #SpriteMoveLeft
          sta SpriteMotion, x
          dec SpriteX, x
          dec SpriteX, x
          ;; fall through
SpriteCxUpDown:
          lda SpriteMotion, x
          .BitBit SpriteMoveUp
          beq SpriteCxDown
SpriteCxUp:
          and # SpriteMoveLeft | SpriteMoveRight
          ora #SpriteMoveDown
          sta SpriteMotion, x
          inc SpriteY, x
          inc SpriteY, x
          bne CollisionDone ; always taken

SpriteCxDown:
          .BitBit SpriteMoveDown
          beq CollisionDone
          and # SpriteMoveLeft | SpriteMoveRight
          ora #SpriteMoveUp
          sta SpriteMotion, x
          dec SpriteY, x
          dec SpriteY, x
          ;; fall through
CollisionDone:
          rts
          .bend
;;; 
DoSpriteMotion:     .block
          lda Pause
          beq +
          rts
+
          ldx SpriteCount
          beq MovementLogicDone
          cpx # 5
          blt +
          brk
+
          dex

MoveSprites:
          lda ClockFrame
          ;; Allow moving approximately 10 Hz regardless of TV region
          sec
-
          sbc #ceil(FramesPerSecond / 10)
          bcs -
          cmp #$ff
          beq +
          rts

+

          lda SpriteMotion, x
          beq SpriteMoveDone
          cmp #SpriteRandomEncounter
          bne SpriteXMove
          jsr Random            ; Is there a random encounter?
          bne NoRandom
          jsr Random
          and #1
          bne NoRandom
          pla                   ; discard the call to us
          pla
          jmp MapVBlank.FightWithSpriteX

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

          lda #SpriteMoveIdle
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
          and # SpriteMoveUp | SpriteMoveDown | SpriteMoveLeft | SpriteMoveRight
          bne +
          lda #SpriteMoveIdle
+
          .BitBit SpriteMoveUp
          beq +
          and # ~SpriteMoveDown
+
          .BitBit SpriteMoveDown
          beq +
          and # ~SpriteMoveUp
+
          .BitBit SpriteMoveLeft
          beq +
          and # ~SpriteMoveRight
+
          .BitBit SpriteMoveRight
          beq +
          and # ~SpriteMoveLeft
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
MovementLogicDone:
          rts

          .bend
