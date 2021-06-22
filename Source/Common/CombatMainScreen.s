CombatMainScreen:   .block

Loop:
          jsr VSync
          jsr VBlank

          jsr Prepare48pxMobBlob
          
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

PrepareMonsterArt:  
          
          lda #>MonsterArt
          sta CombatSpritePointer + 1

          ldx # 12              ; offset of art index
          lda Monsters, x
          clc
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

          ldx MoveTarget
          beq PrepareTopMonsters
          dex
          lda EnemyHP, x
          beq +
          .ldacolu COLYELLOW, $f
          jmp SetCursorColor
+
          .ldacolu COLGRAY, 0
SetCursorColor:       
          sta COLUP1

PrepareCursor2:
          ldx MoveTarget
          dex
          cpx #2
          bpl PrepareTopMonsters

PositionTopCursor:
          lda SpritePosition, x
          sta HMCLR

          sec
          sta WSYNC
TopCursorPos:
          sbc #15
          bcs TopCursorPos
          sta RESP1

          eor #$07
          asl a
          asl a
          asl a
          asl a
          sta HMP1

          lda #$ff
          sta GRP1

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

          jmp PrepareBottomCursor

NoTopMonsters:
          lda # 0
          sta GRP0
          ldy # 14
-
          sta WSYNC
          dey
          bne -

PrepareBottomCursor:
          lda # 0
          sta GRP1
          
          ldx MoveTarget
          dex
          cpx #3
          bpl PrepareBottomMonsters

          txa
          sec
          sbc #4
          tax

          lda SpritePosition,x
PostionBottomCursor:
          sta HMCLR

          sec
          sta WSYNC
BottomCursorPos:
          sbc #15
          bcs BottomCursorPos
          sta RESP1

          eor #$07
          asl a
          asl a
          asl a
          asl a
          sta HMP1

          sta WSYNC
          .SleepX 71
          sta HMOVE

          lda #$ff
          sta GRP1

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
          lda # 0
          sta GRP1
          
          ldx # 10
-          
          stx WSYNC
          dex
          bne -

DrawGrizzardName:

          .ldacolu COLBLUE, $f
          sta COLUP0
          sta COLUP1
          .ldacolu COLINDIGO, $8
          sta COLUBK

          ldx #TextBank
          ldy #ServiceShowGrizzardName
          jsr FarCall

DrawGrizzard:
          ldx #TextBank
          ldy #ServiceDrawGrizzard
          jsr FarCall

DrawHealthBar:      
          ldx CurrentHP
          cpx MaxHP
          beq AtMaxHP
          cpx #4
          bmi AtMinHP
          .ldacolu COLYELLOW, $f
          sta COLUPF
          jmp DrawHealthPF

AtMaxHP:
          .ldacolu COLSPRINGGREEN, $f
          sta COLUPF
          jmp DrawHealthPF

AtMinHP:
          .ldacolu COLRED, $f
          sta COLUPF

DrawHealthPF:
          cpx #8
          bpl FullCenter
          lda HealthyPF2, x
          sta PF2
          jmp DoneHealth

FullCenter:
          lda #$ff
          sta PF2
          cpx #16
          bpl FullMid
          lda HealthyPF1, x
          sta PF1
          jmp DoneHealth

FullMid:
          lda #$ff
          sta PF1
          ;; TODO …
          nop
          nop
          nop
          nop
          sta PF0

DoneHealth:
          ldx #4
-
          sta WSYNC
          dex
          bne -
          
          ldx # KernelLines - 190
FillScreen:
          stx WSYNC
          dex
          bne FillScreen

          lda WhoseTurn
          beq CheckStick

          lda ClockSeconds
          cmp AlarmSeconds
          bne +

          lda ClockMinutes
          cmp AlarmMinutes
          beq DoMonsterMove

+
          ldx # KernelLines - 180
-
          stx WSYNC
          dex
          bne -
          jmp CheckSwitches
          
DoMonsterMove:      

          ;;  TODO choose a move for the monsters
          lda #1
          sta MoveSelection
          jmp CombatAnnouncementScreen

          .align $100, $ea        ; leave room for monster "AI"

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
          stx MoveSelection

StickLeftRight:
          ldx MoveSelection
          lda MoveTargets, x
          cmp #1
          beq ChooseTarget
          cmp #0
          beq SelfTarget
          ldx #$ff
          stx MoveTarget
          jmp StickDone

SelfTarget:
          ldx # 0
          stx MoveTarget
          jmp StickDone

ChooseTarget:       
          ldx MoveTarget
          lda SWCHA
          and #P0StickLeft
          bne DoneStickLeft
          dex
          bpl DoneStickLeft
          ldx #6
DoneStickLeft:
          lda SWCHA
          and #P0StickRight
          bne DoneStickRight
          inx
          cpx #6
          bne DoneStickRight
          ldx #1
DoneStickRight:
          stx MoveTarget

StickDone:

          jsr Prepare48pxMobBlob

          ldx MoveSelection
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

          ;; Is the move known?
          ldx MoveSelection
          dex
          lda BitMask, x
          and MovesKnown
          bne DoUseMove

          lda #SoundBump
          sta NextSound

DoUseMove:
          jmp CombatAnnouncementScreen

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
