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

          lda # 1
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
          .if PUBLISHER
            cmp #ModePublisherPresents
            beq PublisherPresentsMode
          .else
            cmp #ModeBRPPreamble
            beq BRPPreambleMode
          .fi
          
StoryMode:
          ;; TODO lots more needs to happen here
          brk
          
          .if PUBLISHER
PublisherPresentsMode:
          .SetUpFortyEight PublisherCredit
          lda #CTRLPFREF
          sta CTRLPF
          .ldacolu COLGRAY, $f
          sta COLUPF
          lda #$c0
          sta PF2
          ldy #PublisherCredit.Height 
          .ldacolu COLBLUE, $f
          .else
BRPPreambleMode:
          .SetUpFortyEight BRPCredit
          ldy BRPCredit.Height 
          .ldacolu COLINDIGO, $f
          .fi

          sta COLUP0
          sta COLUP1

          lda ClockSeconds
          cmp AlarmSeconds
          bmi StillPresenting

          lda ClockMinutes
          cmp AlarmMinutes
          bmi StillPresenting

          lda # 30
          jsr SetNextAlarm
          lda #ModeAttractTitle
          sta GameMode
          
StillPresenting:
          jmp SingleGraphicAttract

CopyrightMode:

          ldx # 20
SkipAboveCopyright:
          stx WSYNC
          dex
          bne SkipAboveCopyright

          .ldacolu COLTURQUOISE | $e
          sta COLUP0
          sta COLUP1

          .LoadString " COPY "
          jsr ShowText
          .LoadString "RIGHT "
          jsr ShowText
          .LoadString " 2021 "
          jsr ShowText
          .LoadString "BRUCE-"
          jsr ShowText
          .LoadString "ROBERT"
          jsr ShowText
          .LoadString "POCOCK"
          jsr ShowText

          ldx # 20
SkipBelowCopyright:
          stx WSYNC
          dex
          bne SkipBelowCopyright

          lda ClockSeconds
          cmp AlarmSeconds
          bmi StillCopyright

          lda ClockMinutes
          cmp AlarmMinutes
          bmi StillCopyright

          lda # 30
          jsr SetNextAlarm
          lda #ModeAttractTitle
          sta GameMode

StillCopyright:               
          jmp DoneAttractKernel

TitleMode:
          lda AttractHasSpoken
          bne DoneTitleSpeech

          lda ClockSeconds
          cmp AlarmSeconds
          bmi DoneTitleSpeech

          lda ClockMinutes
          cmp AlarmMinutes
          bmi DoneTitleSpeech

          lda #<Speech_TitleIntro
          sta CurrentUtterance
          lda #>Speech_TitleIntro
          sta CurrentUtterance + 1
          sta AttractHasSpoken

DoneTitleSpeech:

          .ldacolu COLINDIGO, $f
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

          .ldacolu COLSPRINGGREEN, $f
          sta COLUP0
          sta COLUP1

          lda ClockFrame
          and # 8
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
          
          ldx # KernelLines - Title1.Height - Title2.Height - 30
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
          jmp SelectSlot

ShowText:
          ldy #ServiceDecodeAndShowText
          ldx #TextBank
          jmp FarCall

SetNextAlarm:
          tax
          lda ClockMinutes
          sta AlarmMinutes
          txa
          clc
          adc ClockSeconds
          cmp # 60
          bmi +
          sec
          sbc # 60
          inc AlarmMinutes
+
          sta AlarmSeconds
          rts
                    
          .bend
