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
          sta $80 - 1, x
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

          lda #$80
          sta PlayerYFraction

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

          ldy # 0
          sty GRP0
          sty GRP1

          lda GameMode
          cmp #ModeAttractStory
          beq StoryMode

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

          .SetSkyColor
          stx WSYNC
          sta COLUBK

          .SetUpFortyEight Title1
          jsr ShowPicture

          .if DEMO
          lda # 1               ; Aquax
          sta CurrentGrizzard
          jsr DrawStarter
          .else

          .FarJSR StretchBank, ServiceDrawStarter

          .fi

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
