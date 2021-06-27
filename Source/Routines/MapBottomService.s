;;; Grizzards Source/Routines/MapBottomService.s
;;; Copyright © 2021 Bruce-Robert Pocock
BottomOfScreenService: .block
          lda #0
          sta COLUBK
          sta PF0
          sta PF1
          sta PF2
          sta GRP0
          sta GRP1
          sta ENABL
          sta WSYNC

          ldx #KernelLines - 187
FillScreen:
          stx WSYNC
          dex
          bne FillScreen

MovementLogic:

          ldx SpriteCount
MoveSprites:
          lda SpriteMotion, x
          beq SpriteMoveDone

SpriteXMove:        
          cmp #SpriteMoveIdle
          beq SpriteMoveNext
          lda SpriteMotion, x
          and #SpriteMoveLeft
          bne +
          dec SpriteX, x
+
          lda SpriteMotion, x
          and #SpriteMoveRight
          bne +
          inc SpriteX, x
+
          lda SpriteMotion, x
          and #SpriteMoveUp
          bne +
          dec SpriteY, x
+
          lda SpriteMotion, x
          and #SpriteMoveDown
          bne +
          inc SpriteY, x
+
          
SpriteMoveNext:
          ;; FIXME handle bumps and screen margins

          ;; Possibly change movement randomly
          jsr Random
          and #$07
          bne SpriteMoveDone

          jsr Random
          and #$01
          beq RandomlyMove

          lda SpriteMoveIdle
          sta SpriteMotion, x
          jmp SpriteMoveDone

RandomlyMove:       
          
          jsr Random
          and #$0e
          tay
          lda BitMask, y
          sta SpriteMotion, x
          ;; fall through
          
SpriteMoveDone:
          dex
          cpx #$ff              ; wait for it to wrap around below 0
          bne MoveSprites

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
          and #P0StickUp
          bne DoneStickUp

          lda #-1
          sta DeltaY

DoneStickUp:
          lda SWCHA
          and #P0StickDown
          bne DoneStickDown

          lda #1
          sta DeltaY

DoneStickDown:
          lda SWCHA
          and #P0StickLeft
          bne DoneStickLeft

          lda #0
          sta Facing
          lda #-1
          sta DeltaX

DoneStickLeft:
          lda SWCHA
          and #P0StickRight
          bne DoneStickRight

          lda #$ff
          sta Facing
          lda #1
          sta DeltaX

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
          ;; jmp CheckPlayerMove

          ;; Collision Handling
CheckPlayerMove:
          lda CXP0FB
          and #$c0              ; hit playfield or ball
          beq NoBumpWall
          jsr BumpWall
          jmp DonePlayerMove

NoBumpWall:
          lda CXPPMM
          and #$80              ; hit other sprite
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
          and #$80
          beq PlayerMoveOK      ; No action
          jmp ProvinceChange

FightWithSprite:
          ldx SpriteFlicker     ; ? Seems unnecessary 
          lda SpriteParam, x
          sta CurrentCombatEncounter
          lda #ModeCombat
          sta GameMode
          rts

DoorWithSprite:
          lda SpriteParam, x
          sta CurrentMap
          jmp DonePlayerMove

GetNewGrizzard:
          lda #ModeNewGrizzard
          sta GameMode
          rts
          
PlayerMoveOK:
          lda #0
          sta DeltaX
          sta DeltaY
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
          lda SpriteAction, x
          and #$0f
          lda #0                ; FIXME
          sta CurrentMap
          jsr Overscan
          ldy #$ff
          rts

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
          
          .bend

BitMask:
          .byte $01, $02, $04, $08, $10, $20, $40, $80
