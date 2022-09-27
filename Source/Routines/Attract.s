;;; Grizzards Source/Routines/Attract.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

Attract:  .block
          ;;
          ;; Title screen and attract sequence
          ;;

          .WaitScreenTop

          ;; DO NOT clear location $80 itself
          ;; It is SystemFlags.
          ldx #$7f
          lda #0
ZeroRAM:
          sta $80, x
          dex
          bne ZeroRAM

          .SetUtterance Phrase_Reset

WarmStart:
          ldx #$ff
          txs
          jsr SeedRandom

          ldy # 0
          sty CurrentMusic + 1
          sty AUDF1
          sty AUDC1
          sty AUDV1
          .mva NextSound, #SoundAtariToday

          .if PUBLISHER
            lda #ModePublisherPresents
          .else
            lda #ModeBRPPreamble
          .fi
          sta GameMode

          .mva PlayerYFraction, #$80   ; what is this being used for??

          .mva CTRLPF, #CTRLPFREF

          .mva DeltaY, # 4            ; what is this being used for??
          .mva AlarmCountdown, # 8
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

          cmp #ModeAttractHighScore
          beq GoHighScore

          .if PUBLISHER
            cmp #ModePublisherPresents
            beq Preamble.PublisherPresentsMode
          .else
            cmp #ModeBRPPreamble
            beq Preamble.BRPPreambleMode
          .fi
;;; 
GoHighScore:
          .FarJSR AnimationsBank, ServiceHighScore

          lda GameMode
          cmp #ModeSelectSlot
          beq Leave

          jmp Attract
          
StoryMode:
          .FarJSR AnimationsBank, ServiceAttractStory

          lda GameMode
          cmp #ModeAttractHighScore
          beq GoHighScore

          jmp Leave
;;; 
TitleMode:
          lda AttractHasSpoken
          cmp #<Phrase_TitleIntro
          beq DoneTitleSpeech

          .SetUtterance Phrase_TitleIntro
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
            .mva CurrentGrizzard, # 1 ; Aquax
            jsr DrawStarter
          .else
            .FarJSR StretchBank, ServiceDrawStarter
          .fi

          lda AlarmCountdown
          bne DoneKernel

          .mva AlarmCountdown, # 16
          .mva GameMode, #ModeAttractCopyright
;;; 
DoneKernel:
          lda NewSWCHB
          beq DoneSelect

          and #SWCHBSelect
          beq Leave

DoneSelect:
          lda NewButtons
          beq DoneButtons

          and #ButtonI
          beq Leave

DoneButtons:
          jmp Loop

Leave:
          .mva GameMode, #ModeSelectSlot
          .if NOSAVE
            jmp BeginOrResume
          .else
            jmp SelectSlot
          .fi
;;; 
          .bend
