;;; Common combat routines called from multiple banks
DoCombat:          .block

          lda GrizzardAttack
          sta CurrentAttack
          lda GrizzardDefense
          sta CurrentDefense
          lda GrizzardAccuracy
          sta CurrentAccuracy

          ldx CurrentCombatEncounter
          lda EncounterMonster, x

          ;;  Set up the monster pointer
          ldx #>Monsters
          stx CurrentMonsterPointer + 1
          
          ;; × 16
          ldx #4
-
          clc
          asl a
          bcc +
          inc CurrentMonsterPointer + 1
+
          dex
          bne -

          sta CurrentMonsterPointer

          ldy # 15              ; offset of ACC & count
          lda (CurrentMonsterPointer), y
          and #$0f

          ;;  TODO choose a random number between 1 and this max count
          lda # 1
          
          tay

          ;; Zero HP for 5 monsters (we have at least 1), then …
          lda # 0
          ldx # 5
-
          sta EnemyHP + 1, x
          dex
          bne -

          ;; … actually set the HP for monsters present (per .y)
          lda EncounterHP, x
-
          sta EnemyHP, y
          dey
          bne -

          lda #$ff              ; no selection
          sta MoveSelection

          ;; ignore current switch position until it changes,
          ;; so we aren't reacting to map movement
          lda SWCHA
          sta DebounceSWCHA

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
          
;;          jsr Prepare48pxMobBlob

          ldy # 10
-
          sta WSYNC
          dey
          bne -

          ldx #TextBank
          ldy #ServiceShowMove
          jsr FarCall
          
          .ldacolu COLGRAY | $0
          sta COLUBK

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
          ldx #0

DoneStickUp:
          lda SWCHA
          and #P0StickDown
          bne DoneStickDown
          inx
          cpx #8              ; max moves = 8
          bne DoneStickDown
          ldx #0

DoneStickDown:
          lda SWCHA
          and #P0StickLeft
          bne DoneStickLeft
          ldx #$ff
          jmp StickDone

DoneStickLeft:
          ;; lda SWCHA
          ;; and #P0StickRight
          ;; bne DoneStickRight

DoneStickRight:
StickDone:
          stx MoveSelection
          cpx #$ff
          beq SelectedFlee
          ldy # COLGRAY
          lda BitMask, x
          and MovesKnown
          beq +
          ldy # COLRED
+
          sty COLUP0
          sty COLUP1

          ;; draw move name

SelectedFlee:       
          
          lda INPT4
          and #$80
          bne NoFire

          lda MoveSelection
          cmp #$ff
          beq SelectedRunAway
          ;; TODO: Perform the selected move


SelectedRunAway:
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
          and #SWCHBColor
          eor #SWCHBColor
          sta Pause

SkipSwitches:
          jsr Overscan
          jmp Loop

Leave:
          jsr Overscan
          jmp DoCombat

MovesLoop:
          jsr VSync
          jsr VBlank

          ldx # KernelLines
FillScreen2:
          stx WSYNC
          dex
          bne FillScreen2

          ;; TODO check for Reset


NoMovesFire:
          ;; TODO check for stick move

MovesAreScrolling:

          jsr Overscan

          jmp MovesLoop

          .bend


AddToScore: .block            ; Add .a (BCD) to score
          sed
          clc
          adc Score
          bcc NCarScore0
          sta Score
          lda Score + 1
          clc
          adc # 1
          bcc NCarScore1
          sta Score + 1
          inc Score + 2
          jmp ScoreDone

NCarScore1:
          sta Score + 1
          jmp ScoreDone
NCarScore0:
          sta Score
ScoreDone:
          cld
          rts
          .bend

SpritePresence:
          .byte 0                ; 0 0 0
          .byte NUSIZNorm        ; 0 0 1
          .byte NUSIZNorm        ; 0 1 0
          .byte NUSIZ2CopiesMed  ; 0 1 1
          .byte NUSIZNorm        ; 1 0 0
          .byte NUSIZ2CopiesWide ; 1 0 1
          .byte NUSIZ2CopiesMed  ; 1 1 0
          .byte NUSIZ3CopiesMed  ; 1 1 1

SpritePosition:
          .byte 0               ; 0 0 0
          .byte $a0             ; 0 0 1
          .byte $80             ; 0 1 0
          .byte $a0             ; 0 1 1
          .byte $60             ; 1 0 0
          .byte $60             ; 1 0 1
          .byte $60             ; 1 1 0
          .byte $60             ; 1 1 1

ShowPointerText:
          ldy # 0
-
          lda (Pointer), y
          sta StringBuffer, y
          iny
          cpy # 6
          bne -

          ldx #TextBank
          ldy #ServiceDecodeAndShowText
          jmp FarCall

          
