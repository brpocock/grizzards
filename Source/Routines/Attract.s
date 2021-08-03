;;; Grizzards Source/Routines/Attract.s
;;; Copyright © 2021 Bruce-Robert Pocock
Attract:  .block
          ;;
          ;; Title screen and attract sequence
          ;;

          ldx #$80
          lda #0
ZeroRAM:
          sta $80, x
          dex
          bne ZeroRAM

          jsr SeedRandom

          lda # SoundAtariToday
          sta NextSound

          .if PUBLISHER
            lda #ModePublisherPresents
          .else
            lda #ModeBRPPreamble
          .fi
          sta GameMode

          lda # 4
          jsr SetNextAlarm
;;; 
Loop:
          .WaitScreenTop

          lda GameMode
          cmp #ModeAttractStory
          beq StoryMode

          .if TV == NTSC
          .SkipLines 4
          .fi
          jsr Prepare48pxMobBlob

          lda GameMode
          cmp #ModeAttractTitle
          beq TitleMode
          cmp #ModeAttractCopyright
          beq CopyrightMode
          cmp #ModeCreditSecret
          beq Credits
          .if PUBLISHER
            cmp #ModePublisherPresents
            beq Preamble.PublisherPresentsMode
          .else
            cmp #ModeBRPPreamble
            beq Preamble.BRPPreambleMode
          .fi
;;; 
StoryMode:
          .FarJSR AnimationsBank, ServiceAttractStory
          lda GameMode
          cmp #ModeAttractStory
          beq Loop
          cmp #ModeAttractTitle
          beq Loop
          jmp Leave
;;; 
TitleMode:
          lda AttractHasSpoken
          cmp #<Phrase_TitleIntro
          beq DoneTitleSpeech

          lda #>Phrase_TitleIntro
          sta CurrentUtterance + 1
          lda #<Phrase_TitleIntro
          sta CurrentUtterance
          sta AttractHasSpoken
DoneTitleSpeech:
          .ldacolu COLINDIGO, $a
          sta COLUP0
          sta COLUP1

          .SetUpFortyEight Title1
          ldy #Title1.Height
          sty LineCounter
          jsr ShowPicture

          .SkipLines 42

          .switch STARTER
          .case 0
          .ldacolu COLGREEN, $e
          .case 1
          .ldacolu COLBROWN, $6
          .case 2
          .ldacolu COLTEAL, $e
          .default
          .error "STARTER ∈ (0 1 2), ¬ ", STARTER
          .endswitch

          sta COLUP0
          sta COLUP1

          sta WSYNC             ; just for line count

          lda ClockFrame
          .BitBit $20
          beq DrawTitle3

          .SetUpFortyEight Title2
          ldy #Title2.Height
          sty LineCounter
          jsr ShowPicture

          jmp PrepareFillAttractBottom

DrawTitle3:
          .SetUpFortyEight Title3
          ldy #Title3.Height
          sty LineCounter
          jsr ShowPicture

          ldy # 0
          sty PF2

PrepareFillAttractBottom:

          lda ClockSeconds
          cmp AlarmSeconds
          bne DoneKernel

          lda # 4
          jsr SetNextAlarm
          lda #ModeAttractCopyright
          sta GameMode
          ;; fall through
;;; 
DoneKernel:
          lda NewSWCHB
          beq +
          and #SWCHBSelect
          beq Leave
+
          lda NewButtons
          beq +
          and #PRESSED
          beq Leave
+
          .WaitScreenBottom
          jmp Loop

Leave:
          lda #ModeSelectSlot
          sta GameMode
          .WaitScreenBottom
          jmp SelectSlot
;;; 
          .bend
