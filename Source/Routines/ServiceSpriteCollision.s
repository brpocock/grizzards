;;; Grizzards Source/Routines/ServiceSpriteCollision.s
;;; Copyright © 2021-2022, Bruce-Robert Pocock

HandleSpriteCollision:
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
          sta NextMap
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
          jmp GoCombat
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
          .FarJMP FinaleBank, ServiceProvinceChange
