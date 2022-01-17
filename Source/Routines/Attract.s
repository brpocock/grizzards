;;; Grizzards Source/Routines/Attract.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

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

          .if STARTER == 1
          lda #$80
          sta PlayerYFraction
          .fi

          lda # CTRLPFREF
          sta CTRLPF

          lda # 4
          sta DeltaY
          lda # 8
          sta AlarmCountdown
;;; 
Loop:
          .WaitScreenBottom
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
          .if TV == SECAM
            lda #COLWHITE
          .else
            .ldacolu COLINDIGO, $a
          .fi
          sta COLUP0
          sta COLUP1

          .if TV == SECAM
            lda #COLBLUE
          .else
            .ldacolu COLTURQUOISE, $e
          .fi
          stx WSYNC
          sta COLUBK

          .SetUpFortyEight Title1
          ldy #Title1.Height
          sty LineCounter
          jsr ShowPicture

          .switch STARTER

          .case 0               ; Dirtex

          .SkipLines 20
          .ldacolu COLORANGE, $a
          sta COLUBK
          .SkipLines 22

          .case 1               ; Aquax

          .SkipLines 30
          .ldacolu COLSPRINGGREEN, $4
          sta COLUBK

          .SkipLines 12

          .case 2               ; Airex

          .SkipLines 20
          .ldacolu COLGREEN, $4
          sta COLUPF
          .if TV == SECAM
            lda #COLBLUE
          .else
            .ldacolu COLTURQUOISE, $e
          .fi
          sta COLUBK

          .if TV == NTSC

          lda # 43
          sta Rand
          sta Rand + 1

          ldy # 4
Foliage:
          jsr Random
          sta PF0
          jsr Random
          sta PF1
          jsr Random
          sta PF2
          .SkipLines 4
          dey
          bne Foliage

          .fi

          lda # $ff
          sta PF0
          sta PF1
          sta PF2

          .endswitch

          .switch STARTER
          .case 0               ; Aquax
           .ldacolu COLGREEN, $e
          .case 1               ; Dirtex
           .ldacolu COLBROWN, $6
          .case 2               ; Airex
           .ldacolu COLTEAL, $e
          .default
           .error "STARTER ∈ (0 1 2), ¬ ", STARTER
          .endswitch

          sta COLUP0
          sta COLUP1

          stx WSYNC             ; just for line count

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

          .case 1               ; Aquax

          jsr Random
          and # 7
          bne +

          jsr Random
          and # 1
          sta PlayerXFraction
+
          lda PlayerXFraction
          beq +
          inc PlayerYFraction
          jmp SetWaveLevel
+
          dec PlayerYFraction
SetWaveLevel:
          lda PlayerYFraction
          lsr a
          clc
          lsr a
          clc
          lsr a
          lsr a
          tax
          and #$1f
          inx
-
          stx WSYNC
          dex
          bne -

          .ldacolu COLBLUE, $e
          sta COLUBK
          stx WSYNC
          .ldacolu COLGRAY, $e
          sta COLUBK
          stx WSYNC
          .ldacolu COLBLUE, $e
          sta COLUBK
          stx WSYNC
          .ldacolu COLBLUE, $8
          sta COLUBK

          .case 2               ; Airex

          lda #$ff
          sta PF2
          .SkipLines 3
          .ldacolu COLBROWN, $4
          sta COLUPF
          .SkipLines 10
 
          stx WSYNC
          .if TV == SECAM
            lda #COLBLUE
          .else
            .ldacolu COLTURQUOISE, $e
          .fi
          sta COLUBK

          lda #$ff
          sta GRP0
          sta GRP1

          lda # NUSIZQuad
          sta NUSIZ0
          sta NUSIZ1
          .ldacolu COLBROWN, $4
          sta COLUP0
          sta COLUP1

          stx WSYNC
          .SleepX $18
          sta RESP0
          nop
          nop
          nop
          nop
          sta RESP1

          lda # 0
          sta PF0
          sta PF1
          sta PF2

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

          .if STARTER == 2
          lda # 0
          sta GRP0
          sta GRP1
          .fi

          jmp Loop

Leave:
          lda #ModeSelectSlot
          sta GameMode
          .if NOSAVE
          jmp BeginOrResume
          .else
          jmp SelectSlot
          .fi
;;; 
          .bend
