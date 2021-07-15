;;; Grizzards Source/Routines/Attract.s
;;; Copyright © 2021 Bruce-Robert Pocock
Attract:
          
          ;;
          ;; Title screen and attract sequence
          ;;

          ldx #$20

          ldy GameMode          ; preserve if set

          lda #0
ZeroRAM:
          sta $80, x
          sta $a0, x
          sta $c0, x
          sta $e0, x
          dex
          bne ZeroRAM

          sty GameMode

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

Loop:
          jsr VSync
          jsr VBlank

          ldx #4
-
          sta WSYNC
          dex
          bne -

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
            beq PublisherPresentsMode
          .else
            cmp #ModeBRPPreamble
            beq BRPPreambleMode
          .fi
          
StoryMode:
          .FarJSR AnimationsBank, ServiceAttractStory
          lda GameMode
          cmp #ModeAttractStory
          beq Loop
          cmp #ModeAttractTitle
          beq Loop
          jmp LeaveAttract

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

          .ldacolu COLINDIGO, $f
          sta COLUP0
          sta COLUP1

          .SetUpFortyEight Title1
          ldy #Title1.Height
          sty LineCounter
          jsr ShowPicture

          ldx # 40
FillAttractMid1:
          sta WSYNC
          dex
          bne FillAttractMid1

          .ldacolu COLSPRINGGREEN, $f
          sta COLUP0
          sta COLUP1

          lda ClockFrame
          and # $20
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

          ldx # KernelLines - Title1.Height - Title2.Height - 58
FillAttractBottom:
          sta WSYNC
          dex
          bne FillAttractBottom

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
          ;; jmp DoneAttractKernel ; fall through

DoneAttractKernel:
          lda NewSWCHB
          beq SkipSwitches
          and #SWCHBSelect
          beq LeaveAttract
SkipSwitches:
          lda NewINPT4
          beq +
          and #PRESSED
          beq LeaveAttract

          jsr Overscan
          jmp Loop

LeaveAttract:
          lda #SoundChirp
          sta NextSound

          jsr Overscan

          lda #ModeSelectSlot
          sta GameMode
          jmp SelectSlot

ShowText:
          .FarJMP TextBank, ServiceDecodeAndShowText


