;;; Common combat routines called from multiple banks
DoCombat:          .block

          ldx CurrentCombatEncounter
          lda EncounterMonster, x

          ldx #>Monsters
          stx CurrentMonsterPointer + 1
          
          ;; × 16
          ldx #4
-
          clc
          asl
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
          
          tay

          lda EncounterHP, x

-
          sta EnemyHP, y
          dey
          bne -

          lda #$ff              ; no selection
          sta MoveSelection

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
          jsr Prepare48pxMobBlob

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
          
          ldy # 0
CopyName1:
          lda (CurrentMonsterPointer), y
          sta StringBuffer, y
          iny
          cpy # 6
          bne CopyName1

          jsr DecodeText
          jsr ShowText

          ldy # 6
CopyName2:
          lda (CurrentMonsterPointer), y
          sta StringBuffer - 6, y
          iny
          cpy # 12
          bne CopyName2

          jsr DecodeText
          jsr ShowText

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
          lda SpritePresence, x
          sta NUSIZ0
          lda SpritePosition, x

          ldy #20
-
          sty WSYNC
          dey
          bne -

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
          .Sleep 71
          sta HMOVE

DrawTopMonsters:
          ldx #7
-
          lda CombatSpritePointer, x
          sta GRP0
          sta WSYNC
          sta WSYNC
          dex
          bpl -

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
          lda SpritePresence, x
          sta NUSIZ0
          lda SpritePosition, x

          ldy #25
-
          dey
          bne -

PositionBottomMonsters:
          sta HMCLR

          sec
          sta WSYNC
Monster2Pos:
          sbc #15
          bcs Monster2Pos
          sta RESP0

          eor #$07
          asl a
          asl a
          asl a
          asl a
          sta HMP0

          sta WSYNC
          .Sleep 71
          sta HMOVE

DrawBottomMonsters:
          ldx #7
-
          lda CombatSpritePointer, x
          sta GRP0
          sta WSYNC
          sta WSYNC
          dex
          bpl -

          ldy #25
-          
          sty WSYNC
          dey
          bne -




          
          

          ldx # KernelLines - 188 + 60
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
          jmp Dispatch

SelectedBowAndArrow:
          ;; TODO

SelectedSword:
          ;; TODO

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
          jmp Dispatch

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
          .byte NUSIZNorm        ; 0 0 1
          .byte NUSIZNorm        ; 0 1 0
          .byte NUSIZ2CopiesMed  ; 0 1 1
          .byte NUSIZNorm        ; 1 0 0
          .byte NUSIZ2CopiesWide ; 1 0 1
          .byte NUSIZ2CopiesMed  ; 1 1 0
          .byte NUSIZ3CopiesMed  ; 1 1 1

SpritePosition:
          .byte $a0             ; 0 0 1
          .byte $80             ; 0 1 0
          .byte $a0             ; 0 1 1
          .byte $60             ; 1 0 0
          .byte $60             ; 1 0 1
          .byte $60             ; 1 1 0
          .byte $60             ; 1 1 1
