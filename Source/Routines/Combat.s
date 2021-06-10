;;; Common combat routines called from multiple banks
DoCombat:          .block

          ldx CurrentCombatEncounter
          lda EncounterMaxCount, x
          tay

          lda #0
          sta SpellsKnown1      ; FIXME remove this after testing

          lda EncounterHP, x

-
          sta EnemyHP, y
          dey
          bne -

          lda #$ff              ; no selection
          sta RadialMenuItem

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

          ldx CurrentCombatEncounter
          lda EncounterMonster, x
          rol a
          rol a
          rol a
          sta CombatSpritePointer
          lda #>Monsters
          sta CombatSpritePointer + 1

          lda EncounterMonster, x
          ;; × 6
          rol a
          sta Temp
          rol a
          clc
          adc Temp
          pha
          tax
          ldy # 0
CopyName1:
          lda MonsterName1, x
          sta StringBuffer, y
          inx
          iny
          cpy # 6
          bne CopyName1

          jsr DecodeText
          jsr ShowText

          pla
          tax
          ldy # 0
CopyName2:
          lda MonsterName2, x
          sta StringBuffer, y
          inx
          iny
          cpy # 6
          bne CopyName2

          jsr DecodeText
          jsr ShowText

          lda #0
          sta VDELP0
          sta VDELP1
          sta NUSIZ0
          sta NUSIZ1

          ldx CurrentCombatEncounter
          lda EncounterMonster, x
          tax
          lda MonsterColors, x
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

          ;; Up: Bow & Arrows
DrawBowAndArrowIcon:
          sta WSYNC
          .SleepX 42
          sta RESP0

          lda RadialMenuItem
          beq HighlightBowAndArrows
          .ldacolu COLGRAY, 0
          jmp DrawBowAndArrows

HighlightBowAndArrows:
          .ldacolu COLGOLD, $8

DrawBowAndArrows:
          sta COLUP0

          ldx #8
-
          sta WSYNC
          sta WSYNC
          lda BowAndArrowIcon - 1, x
          sta GRP0
          dex
          bne -

          lda # 0
          sta GRP0
          sta WSYNC
          sta WSYNC

          ;; Left: Sword; Right: Magic
DrawSwordAndMagicIcons:
          sta WSYNC
          .SleepX 32
          sta RESP0
          .SleepX 16
          sta RESP1

          lda RadialMenuItem
          cmp # 1
          beq HighlightSword
          .ldacolu COLGRAY, 0
          jmp TestMagic

HighlightSword:
          .ldacolu COLBLUE, $8

TestMagic:
          sta COLUP0

          lda SpellsKnown1
          ora SpellsKnown2
          tay
          beq DrawSwordAndMagic
          lda RadialMenuItem
          cmp # 2
          beq HighlightMagic
          .ldacolu COLGRAY, 0
          jmp DrawSwordAndMagic

HighlightMagic:
          .ldacolu COLYELLOW, $8

DrawSwordAndMagic:
          sta COLUP1

          ldx #8
-
          lda SwordIcon - 1, x
          sta GRP0
          tya
          beq DoNotDrawMagic
          lda MagicIcon - 1, x
          sta GRP1
          jmp +
DoNotDrawMagic:
          sta GRP1
+
          sta WSYNC
          sta WSYNC
          dex
          bne -

          lda # 0
          sta GRP0
          sta GRP1
          sta WSYNC
          sta WSYNC

          ;; Down: Run away
DrawRunAwayIcon:
          sta WSYNC
          .SleepX 42
          sta RESP0

          lda RadialMenuItem
          cmp # 3
          beq HighlightShoe
          .ldacolu COLGRAY, 0
          jmp DrawShoe

HighlightShoe:
          .ldacolu COLGREEN, $8

DrawShoe:
          sta COLUP0

          ldx #8
-
          sta WSYNC
          sta WSYNC
          lda RunIcon - 1, x
          sta GRP0
          dex
          bne -

          lda # 0
          sta GRP0
          sta WSYNC
          sta WSYNC


          ldx # KernelLines - 188
FillScreen:
          stx WSYNC
          dex
          bne FillScreen

CheckStick:
          lda SWCHA
          cmp DebounceSWCHA
          beq StickDone
          sta DebounceSWCHA
          and #P0StickUp
          bne DoneStickUp
          lda #0
          sta RadialMenuItem
          jmp StickDone

DoneStickUp:
          lda SWCHA
          and #P0StickDown
          bne DoneStickDown
          lda #3
          sta RadialMenuItem
          jmp StickDone

DoneStickDown:
          lda SWCHA
          and #P0StickLeft
          bne DoneStickLeft
          lda #1
          sta RadialMenuItem
          jmp StickDone

DoneStickLeft:
          lda SWCHA
          and #P0StickRight
          bne DoneStickRight
          lda #2
          sta RadialMenuItem

DoneStickRight:

StickDone:
          lda INPT4
          and #$80
          bne NoFire

          lda RadialMenuItem
          beq SelectedBowAndArrow
          cmp #1
          beq SelectedSword
          cmp #2
          beq SelectedMagic

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

SelectedMagic:
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

MagicLoop:
          jsr VSync
          jsr VBlank

          ;; update scrolling position if in motion

          lda MagicScroll
          beq MagicScrollDone
          bmi MagicScrollUp

MagicScrollDown:
          ;; TODO Scroll from mid-screen to end,
          ;; then increment MagicSelected,
          ;; then scroll from beginning to mid-screen,
          ;; then stop.

MagicScrollUp:
          ;; TODO Scroll from mid-screen to beginning,
          ;; then decrement MagicSelected,
          ;; then scroll from end to mid-screen,
          ;; then stop.

MagicScrollDone:
          ;; TODO position sprite for scroll left corner

          ;; TODO draw scroll top with shading

          ;; TODO draw selected spell at correct vertical position

          ;; TODO position sprite for scroll right corner

          ;; TODO draw scroll bottom with shading

          ;; TODO fill screen

          ldx # KernelLines
FillScreen2:
          stx WSYNC
          dex
          bne FillScreen2

          ;; TODO check for Reset

          lda MagicScroll
          bne MagicIsScrolling

          ;; check for Fire
          lda INPT4
          and #$80
          bne NoMagicFire

          jsr Overscan
          jmp Loop

NoMagicFire:
          ;; TODO check for stick move

MagicIsScrolling:

          jsr Overscan

          jmp MagicLoop

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
