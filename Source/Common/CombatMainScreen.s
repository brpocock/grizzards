CombatMainScreen:   .block
Loop:
          jsr VSync
          jsr VBlank

          lda Pause
          beq NotPaused

          .ldacolu COLGRAY, 0
          sta COLUBK
          .ldacolu COLGRAY, $f
          sta COLUP0
          sta COLUP1
          jmp PausedOrNot

NotPaused:
          .ldacolu COLRED, 0
          sta COLUBK
          .ldacolu COLYELLOW, $f
          sta COLUP0
          sta COLUP1

PausedOrNot:
          ;; jsr Prepare48pxMobBlob

PrepareMonsterArt:  
          
          lda #>MonsterArt
          sta CombatSpritePointer + 1

          ldx # 12              ; offset of art index
          lda Monsters, x
          clc
          asl a
          asl a
          asl a
          bcc +
          inc CombatSpritePointer + 1
+
          sta CombatSpritePointer

ShowMonsterName:    

          lda CurrentMonsterPointer
          sta Pointer
          lda CurrentMonsterPointer + 1
          sta Pointer + 1

          jsr ShowPointerText

          lda Pointer
          clc
          adc # 6
          bcc +
          inc Pointer + 1
+
          sta Pointer

          jsr ShowPointerText
          
PrepareToDrawMonsters:        
          
          lda #0
          sta VDELP0
          sta VDELP1
          sta NUSIZ0
          sta NUSIZ1
          
          ldy # 14              ; offset of monster color
          lda (CurrentMonsterPointer), y
          sta COLUP0

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
          lda SpritePresence, x
          sta NUSIZ0
          lda SpritePosition, x

PositionTopMonsters:
          sta HMCLR

          sec
          sta WSYNC
Monster1Pos:
          sbc #15
          bcs Monster1Pos
          sta RESP0

          eor #$07
          asl a
          asl a
          asl a
          asl a
          sta HMP0

          sta WSYNC
          .SleepX 71
          sta HMOVE

DrawTopMonsters:
          ldy #7
-
          lda (CombatSpritePointer), y
          sta GRP0
          sta WSYNC
          sta WSYNC
          dey
          bpl -
          sty GRP0

          jmp PrepareBottomMonsters

NoTopMonsters:
          lda # 0
          sta GRP0
          ldy # 14
-
          sta WSYNC
          dey
          bne -

PrepareBottomMonsters:
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
          beq NoBottomMonsters
          lda SpritePresence, x
          sta NUSIZ0
          lda SpritePosition, x
          
PositionBottomMonsters:
          sta WSYNC
          sta HMCLR

          sec
          sta WSYNC
Monster2Pos:
          sbc # 15
          bcs Monster2Pos
          sta RESP0

          eor #$07
          asl a
          asl a
          asl a
          asl a
          sta HMP0

          sta WSYNC
          .SleepX 71
          sta HMOVE

DrawBottomMonsters:
          ldy #7
-
          lda (CombatSpritePointer), y
          sta GRP0
          sta WSYNC
          sta WSYNC
          dey
          bpl -
          sty GRP0
          jmp DelayAfterMonsters

NoBottomMonsters:
          lda # 0
          sta GRP0
          ldy # 14
-
          sta WSYNC
          dey
          bne -

DelayAfterMonsters: 
          ldx # 10
-          
          stx WSYNC
          dex
          bne -

DrawGrizzardName:

          .ldacolu COLBLUE, $f
          sta COLUP0
          sta COLUP1
          .ldacolu COLINDIGO, $0
          sta COLUBK

          ldx #TextBank
          ldy #ServiceShowGrizzardName
          jsr FarCall

DrawGrizzard:
          ldx #TextBank
          ldy #ServiceDrawGrizzard
          jsr FarCall
          
          ldy # 10
-
          sta WSYNC
          dey
          bne -
          
          ldx # KernelLines - 188
FillScreen:
          stx WSYNC
          dex
          bne FillScreen

CheckStick:
          ldx MoveSelection

          lda SWCHA
          cmp DebounceSWCHA
          beq StickDone
          sta DebounceSWCHA
          and #P0StickUp
          bne DoneStickUp
          dex
          bpl DoneStickUp
          ldx #8

DoneStickUp:
          lda SWCHA
          and #P0StickDown
          bne DoneStickDown
          inx
          cpx #9              ; max moves = 8
          bmi DoneStickDown
          ldx #0

DoneStickDown:
          lda SWCHA
          and #P0StickLeft
          bne DoneStickLeft
          ldx # 0
          jmp StickDone

DoneStickLeft:
          ;; lda SWCHA
          ;; and #P0StickRight
          ;; bne DoneStickRight

DoneStickRight:
StickDone:
          stx MoveSelection
          
          cpx # 0
          beq SelectedRunAway
          ldy # COLGRAY | 0
          dex
          lda BitMask, x
          and MovesKnown
          beq +
          ldy # COLRED | $4
+
          sty COLUP0
          sty COLUP1

          ldx #TextBank
          ldy #ServiceShowMove
          jsr FarCall


          lda INPT4
          and #$80
          bne NoFire
          ;; TODO: check button, maybe perform the selected move


SelectedRunAway:

          lda # COLTURQUOISE | $f
          sta COLUP0
          sta COLUP1
          
          ldx #TextBank
          ldy #ServiceShowMove
          jsr FarCall

          lda INPT4
          and #$80
          bne NoFire

          ;; TODO ... odds of escaping, attacks of opportunity
          lda #SoundHappy
          sta NextSound

          lda #ModeMap
          sta GameMode
          jmp GoMap

SelectedMoves:
          ;; TODO

NoFire:   

CheckSwitches:

          lda SWCHB
          cmp DebounceSWCHB
          beq SkipSwitches
          sta DebounceSWCHB
          and #SWCHBReset
          bne NoReset
          jmp GoSaveAndQuit

NoReset:
          lda DebounceSWCHB
          and #SWCHBSelect
          bne NoSelect
          lda #ModeGrizzardStats
          sta GameMode
          
NoSelect: 
          lda DebounceSWCHB
          and #SWCHBColor
          eor #SWCHBColor
          sta Pause

SkipSwitches:
          jsr Overscan

          lda GameMode
          cmp #ModeCombat
          bne Leave
          jmp Loop

Leave:
          cmp #ModeGrizzardStats
          jmp GrizzardStatsScreen

          .bend
