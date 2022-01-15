;;; Grizzards Source/Routines/CheckPlayerCollision.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CheckPlayerCollision:         .block
          lda CXP0FB
          and #$c0              ; hit playfield or ball
          beq NoBumpWall
          jsr BumpWall
          rts

NoBumpWall:
          lda CXPPMM
          .BitBit $80              ; hit other sprite
          beq PlayerMoveOK         ; did not hit

BumpSprite:
          jsr BumpWall

          ldx SpriteFlicker
          lda SpriteAction, x

          cmp #SpriteDoor       ; Doors ignore cooldown timer
          beq DoorWithSprite

          ldy BumpCooldown
          bne DonePlayerMove

ActionWithSpriteX:
          cmp #SpriteCombat
          beq FightWithSpriteMinor
          cmp #SpriteMajorCombat
          beq FightWithSpriteMajor
          cmp #SpriteGrizzardDepot
          beq EnterDepot
          cmp #SpriteGrizzard
          beq GetNewGrizzard
          cmp #SpriteSign
          beq ReadSign
          cmp #SpritePerson
          beq ReadSign
          and #SpriteProvinceDoor
          cmp #SpriteProvinceDoor
          bne PlayerMoveOK      ; No action
          geq ProvinceChange    

ReadSign:
          lda SpriteParam, x
          sta SignpostIndex
          lda #ModeSignpost
          sta GameMode
          rts

FightWithSpriteMinor:
          lda # 0
          sta CombatMajorP
          geq FightWithSprite

FightWithSpriteMajor:
          lda #$80
          sta CombatMajorP
          ;; fall through
          
FightWithSprite:
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
          ldy #ModeMapNewRoomDoor
          sty GameMode
          rts

GetNewGrizzard:
          lda #ModeNewGrizzard
          sta GameMode
          ldx SpriteFlicker
          lda SpriteParam, x
          sta NextMap
          rts

PlayerMoveOK:
          lda BumpCooldown
          beq +
          dec BumpCooldown
          rts
+
          lda ClockFrame
          and #$03
          bne DonePlayerMove
          lda PlayerX
          sta BlessedX
          lda PlayerY
          sta BlessedY
DonePlayerMove:
          rts

EnterDepot:
          lda #ModeGrizzardDepot
          sta GameMode
          rts

ProvinceChange:
;;; Duplicated in Signpost.s and CheckPlayerCollision.s nearly exactly
          stx P0LineCounter
          ldx #$ff              ; smash the stack
          txs
          .WaitForTimer         ; finish up VBlank cycle
          ldx # 0
          stx VBLANK
          ;; WaitScreenTop without VSync/VBlank
          .if TV == NTSC
          .TimeLines KernelLines - 2
          .else
          lda #$fe
          sta TIM64T
          .fi
          .WaitScreenBottom
          .FarJSR SaveKeyBank, ServiceSaveProvinceData
          .WaitScreenTop
          ldx P0LineCounter
          lda SpriteAction, x
          and #$f0
          clc
          lsr a
          lsr a
          lsr a
          lsr a
          sta CurrentProvince
          lda SpriteParam, x
          sta NextMap
          ldy #ModeMapNewRoomDoor
          sty GameMode
          .FarJSR SaveKeyBank, ServiceLoadProvinceData
          .WaitScreenBottom
          jmp GoMap

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

          lda # 0
          sta PlayerXFraction
          sta PlayerYFraction
DoneBump:
          lda #SoundBump
          sta NextSound

          rts
          .bend
