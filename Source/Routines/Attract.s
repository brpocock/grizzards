;;; Grizzards Source/Routines/Attract.s
;;; Copyright © 2021 Bruce-Robert Pocock
Attract:  .block
          ;;
          ;; Title screen and attract sequence
          ;;

          .WaitScreenTop

          ldx #$80
          lda #0
ZeroRAM:
          sta $80, x
          dex
          bne ZeroRAM

WarmStart:
          ldx #$ff
          txs
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
          sta DeltaY
          lda # 8
          sta AlarmCountdown
          .WaitScreenBottom
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

          .ldacolu COLTURQUOISE, $e
          sta WSYNC
          sta COLUBK

          .SetUpFortyEight Title1
          ldy #Title1.Height
          sty LineCounter
          jsr ShowPicture

          .switch STARTER

          .case 0

          .SkipLines 20
          .ldacolu COLORANGE, $a
          sta COLUBK
          .SkipLines 10

          .case 1

          .SkipLines 30
          .ldacolu COLSPRINGGREEN, $4
          sta COLUBK

          .case 2

          .SkipLines 20
          .ldacolu COLGREEN, $4
          sta COLUBK
          .SkipLines 10

          .endswitch

          .SkipLines 12

          .switch STARTER
          .case 0
          .ldacolu COLGREEN, $e
          .case 1
          .ldacolu COLBROWN, $6
          .case 2
          .if TV == SECAM
          lda #COLBLUE
          .else
          .ldacolu COLTEAL, $e
          .fi
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

          .switch STARTER

          .case 1

          jsr Random
          tax
          and #$70
          bne +
          txa
          and #$0f
          adc # 3
          sta DeltaY
+
          ldx DeltaY
-
          stx WSYNC
          dex
          bne -

          .ldacolu COLBLUE, $e
          sta COLUBK

          .case 2

          .ldacolu COLBROWN, $4
          sta COLUBK
          .SkipLines 10
          .ldacolu COLTURQUOISE, $e
          sta COLUBK

          .endswitch

          lda AlarmCountdown
          bne DoneKernel

          lda # 16
          sta AlarmCountdown
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
          .if NOSAVE
          jmp BeginOrResume
          .else
          jmp SelectSlot
          .fi
;;; 
          .bend
