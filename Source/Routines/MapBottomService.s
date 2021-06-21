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

          lda ClockFrame
          and # 1
          beq CheckPlayerMove

          lda BumpCooldown
          beq HandleStick
          dec BumpCooldown

HandleStick:
          lda #0
          sta DeltaX
          sta DeltaY

          lda Pause
          bne DonePlayerMove

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

          jmp DonePlayerMove

          ;; Collision Handling
CheckPlayerMove:
          lda CXP0FB
          and #$c0              ; hit playfield or ball
          beq NoBumpWall
          jsr BumpWall
          jmp DonePlayerMove

NoBumpWall:
          lda CXPPMM
          and #$80
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
          cmp #SpriteGrizzardStation
          beq EnterStation
          and #$80
          beq PlayerMoveOK      ; No action
          jmp ProvinceChange

FightWithSprite:
          lda SpriteParam, x
          sta CurrentCombatEncounter
          lda #ModeCombat
          sta GameMode
          rts

DoorWithSprite:
          lda SpriteParam, x
          sta CurrentMap
          jmp DonePlayerMove

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

EnterStation:
          lda #ModeGrizzardStation
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
          ldx CurrentProvince
          beq InProvince0
          lda #Province1MapBank
          jmp +
InProvince0:
          lda #Province0MapBank
+           
          sta CurrentMapBank
          jsr Overscan
          ldy #$ff
          rts

BumpWall:
          sta CXCLR

          lda BlessedX
          sta PlayerX
          lda BlessedY
          sta PlayerY
          lda #SoundBump
          sta NextSound

          rts
          
          .bend
