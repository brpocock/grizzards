;;; Grizzards Source/Routines/CheckPlayerCollision.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          useShove = false

CheckPlayerCollision:         .block
          lda CXP0FB
          and #$c0              ; hit playfield or ball
          beq NoBumpWall

          jmp BumpWall          ; tail call
;;; 
NoBumpWall:
          bit CXPPMM
          bpl PlayerMoveOK         ; did not hit
          bmi PlayerMoveOK         ;FIXME

BumpSprite:
          jsr BumpWall

          ldx SpriteFlicker
          lda SpriteAction, x

          cmp #SpriteDoor       ; Doors ignore cooldown timer
          beq DoorWithSprite

          ldy BumpCooldown
          bne DonePlayerMove

          ;; This is also the entry point for random encounters
          ;; They call with X and A already set.
ActionWithSpriteX:
          ;; X = sprite index
          ;; A = SpriteAction, x
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
;;; 
ReadSign:
          lda SpriteParam, x
          sta SignpostIndex
          .mva GameMode, #ModeSignpost
          rts
;;; 
FightWithSpriteMinor:
          lda # 0
          geq FightWithSprite

FightWithSpriteMajor:
          lda #$80
          ;; fall through
FightWithSprite:
          sta CombatMajorP
          lda SpriteParam, x
          sta CurrentCombatEncounter
          lda SpriteIndex, x
          sta CurrentCombatIndex
          .mva GameMode, #ModeCombat
          rts
;;; 
DoorWithSprite:
          lda SpriteParam, x
          sta NextMap
          ldy #ModeMapNewRoomDoor ; XXX why Y?
          sty GameMode
          rts
;;; 
GetNewGrizzard:
          .mva GameMode, #ModeNewGrizzard
          lda SpriteParam, x
          sta NextMap
          rts
;;; 
PlayerMoveOK:
          lda BumpCooldown
          beq Cool

          dec BumpCooldown
Cool:
          lda ClockFrame
          and #$03
          bne DonePlayerMove

          .mva BlessedX, PlayerX
          .mva BlessedY, PlayerY
DonePlayerMove:
          rts
;;; 
EnterDepot:
          lda #ModeGrizzardDepot
          sta GameMode
          rts
;;; 
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
          lsr a
          lsr a
          lsr a
          lsr a
          sta CurrentProvince
          lda SpriteParam, x
          sta NextMap
          .mvy GameMode, #ModeMapNewRoomDoor ; XXX why Y?
          .FarJSR SaveKeyBank, ServiceLoadProvinceData

          .WaitScreenBottom
          jmp GoMap
;;; 
BumpWall:
          sta CXCLR

          .if useShove
          
          lda BlessedX
          cmp PlayerX
          beq NeedsXShove

          sta PlayerX
          gne BumpY

NeedsXShove:
          lda DeltaX
          bne ShoveX

          jsr Random

          and # 1
          beq ShoveX

          lda #-1
ShoveX:
          sta DeltaX
          clc
          adc PlayerX
          sta PlayerX
BumpY:
          lda BlessedY
          cmp PlayerY
          beq NeedsYShove

          sta PlayerY
          jmp DoneBump

NeedsYShove:
          lda DeltaY
          bne ShoveY

          jsr Random

          and # 1
          beq ShoveY

          lda #-1
ShoveY:
          sta DeltaY
          clc
          adc PlayerY
          sta PlayerY

          .else                 ; shove mode disabled

          .mva PlayerX, BlessedX
          .mva PlayerY, BlessedY

          .fi

          ldy # 0               ; XXX necessary?
          sty PlayerXFraction
          sty PlayerYFraction
          
DoneBump:
          .mva NextSound, #SoundBump

          rts
          .bend
