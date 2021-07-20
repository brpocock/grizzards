;;; Grizzards Source/Routines/Attract.s
;;; Copyright © 2021 Bruce-Robert Pocock
Attract:  .block
          ;;
          ;; Title screen and attract sequence
          ;;

          ldx #$20
          lda #0
ZeroRAM:
          sta $80, x
          sta $a0, x
          sta $c0, x
          sta $e0, x
          dex
          bne ZeroRAM

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
          jsr VSync

          .SkipLines 4

          jsr Prepare48pxMobBlob

          lda GameMode
          cmp #ModeAttractTitle
          beq TitleMode
          cmp #ModeAttractCopyright
          beq CopyrightMode
          cmp #ModeAttractStory
          beq StoryMode
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
          .SkipLines KernelLines - Title1.Height - Title2.Height - 59

          lda ClockSeconds
          cmp AlarmSeconds
          bmi DoneAttractKernel

          lda ClockMinutes
          cmp AlarmMinutes
          bmi DoneAttractKernel

          lda # 4
          jsr SetNextAlarm
          lda #ModeAttractCopyright
          sta GameMode
          ;; fall through
;;; 
DoneAttractKernel:
          sta WSYNC
          lda NewSWCHB
          beq +
          and #SWCHBSelect
          beq Leave
+
          lda NewINPT4
          beq +
          and #PRESSED
          beq Leave
+
          jsr Overscan
          jmp Loop

Leave:
          jsr Overscan

          lda #ModeSelectSlot
          sta GameMode
          jmp SelectSlot
;;; 
          .bend
