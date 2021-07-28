;;; Grizzards Source/Routines/CheckPlayerCollision.s
;;; Copyright © 2021 Bruce-Robert Pocock

CheckPlayerCollision:         .block
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

          rts
          .bend
