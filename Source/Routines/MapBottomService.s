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
          ;; fall through

PlayerMoveOK:
          lda #0
          sta DeltaX
          sta DeltaY

DonePlayerMove:
          ldy #$00
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
          lda ProvinceBanks, x
          sta CurrentMapBank
          jsr Overscan
          ldy #$ff
          rts

BumpWall:
          sta CXCLR

          lda DeltaX
          beq XBounceDone
          bpl BounceLeft
BounceRight:
          lda PlayerX
          clc
          adc # 3
          sta PlayerX
          jmp XBounceDone

BounceLeft:
          lda PlayerX
          sec
          sbc # 3
          sta PlayerX

XBounceDone:
          lda DeltaY
          beq YBounceDone
          bpl BounceUp

BounceDown:
          lda PlayerY
          clc
          adc # 2
          sta PlayerY
          jmp YBounceDone

BounceUp:
          lda PlayerY
          sec
          sbc # 2
          sta PlayerY

YBounceDone:
          lda #SoundBump
          sta NextSound

          rts
          
          .bend
