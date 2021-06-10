Attract:	.block

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

SwitchMode:

          ldy GameMode
          bne NotColdStart

          lda #1
          sta NextSound

          .if PUBLISHER
          lda #ModePublisherPresents
          .else
          lda #ModeBRPPreamble
          .fi
          sta GameMode

          jmp Loop

NotColdStart:
          ;; TODO?

Loop:
          jsr VSync
          jsr VBlank

          .rept 4
          sta WSYNC
          .next

          jsr Prepare48pxMobBlob

          lda GameMode
          cmp #ModeAttractTitle
          beq TitleMode
          cmp #ModeAttractCopyright
          beq CopyrightMode
          cmp #ModeAttractStory
          beq StoryMode
          .if PUBLISHER
          cmp #ModePublisherPresents
          beq PublisherPresentsMode
          .else
          cmp #ModeBRPPreamble
          beq BRPPreambleMode
          .fi
          jmp Dispatch          ; how did we get here?

StoryMode:
          ;; TODO lots more needs to happen here
          brk

          .if PUBLISHER
PublisherPresentsMode:
          .SetUpFortyEight PublisherCredit
          ldy #PublisherCredit.Height
          .ldacolu COLBLUE | $f
          .else
BRPPreambleMode:
          .SetUpFortyEight BRPCredit
          ldy BRPCredit.Height
          .ldacolu COLSPRINGGREEN | $f
          .fi

          sta COLUP0
          sta COLUP1

          lda ClockSeconds
          cmp #3
          bmi StillPresenting

          lda #0
          sta ClockSeconds
          lda #ModeAttractTitle
          sta GameMode

StillPresenting:

          jmp SingleGraphicAttract

CopyrightMode:

          ldx #50
SkipAboveCopyright:
          stx WSYNC
          dex
          bne SkipAboveCopyright

          .SetUpTextConstant " COPY "
          jsr ShowText
          .SetUpTextConstant "RIGHT "
          jsr ShowText
          .SetUpTextConstant " 2020 "
          jsr ShowText
          .SetUpTextConstant "BRUCE-"
          jsr ShowText
          .SetUpTextConstant "ROBERT"
          jsr ShowText
          .SetUpTextConstant "POCOCK"
          jsr ShowText

          ldx #50
SkipBelowCopyright:
          stx WSYNC
          dex
          bne SkipBelowCopyright

          jmp DoneAttractKernel

TitleMode:
          lda AttractHasSpoken
          bne DoneTitleSpeech

          lda ClockSeconds
          cmp #5
          bmi DoneTitleSpeech

          lda #<Speech_TitleIntro
          sta CurrentUtterance
          lda #>Speech_TitleIntro
          sta CurrentUtterance + 1
          sta AttractHasSpoken

DoneTitleSpeech:

          lda #COLINDIGO
          sta COLUP0
          sta COLUP1

          .SetUpFortyEight Title1
          ldy #Title1.Height
          sty LineCounter
          jsr ShowPicture

          ldx #15
FillAttractMid1:
          sta WSYNC
          dex
          bne FillAttractMid1

          lda #COLPURPLE
          sta COLUP0
          sta COLUP1

          .SetUpFortyEight Title2
          ldy #Title2.Height
          sty LineCounter
          jsr ShowPicture

          ldx #15
FillAttractMid2:
          sta WSYNC
          dex
          bne FillAttractMid2

          lda #COLBLUE
          sta COLUP0
          sta COLUP1

          .SetUpFortyEight Title3
          ldy #Title3.Height
          sty LineCounter
          jsr ShowPicture

          ldx #15
FillAttractBottom:
          sta WSYNC
          dex
          bne FillAttractBottom
          jmp DoneAttractKernel

SingleGraphicAttract:

          ldx #70
SkipAboveGraphic:
          stx WSYNC
          dex
          bne SkipAboveGraphic

          sty LineCounter
          jsr ShowPicture

          lda # ( (KernelLines - 112) * 76 ) / 64
          sta TIM64T

          jsr PlaySpeech
          
SkipBelowGraphic:
          sta WSYNC
          lda INTIM
          bne SkipBelowGraphic

          ;; fall through

DoneAttractKernel:

          .if KernelLines > 192
          lda #0
          ldx #KernelLines - 192
FillAttractScreen:
          sta WSYNC
          dex
          bne FillAttractScreen
          .fi

          jsr Overscan

          lda SWCHB
          cmp DebounceSWCHB
          beq SkipSwitches
          sta DebounceSWCHB
          and #SWCHBSelect
          beq LeaveAttract
SkipSwitches:
          jmp Loop

LeaveAttract:

          lda #SoundChirp
          sta NextSound

          lda #ModeSelectSlot
          sta GameMode
          jmp Dispatch

          .bend
