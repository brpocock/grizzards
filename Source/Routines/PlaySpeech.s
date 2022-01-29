;;; Grizzards Source/Routines/PlaySpeech.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; The following  subroutine based upon  AtariVox Speech Synth  Driver, by
;;; Alex Herbert, 2004; altered by Bruce-Robert Pocock, 2017, 2020

PlaySpeech: .block

          .if !(NOSAVE)

          SerialOutput = $01
          SerialReady = $02

          lda CurrentUtterance + 1
          and #$f0
          bne ContinueSpeaking

          ldy CurrentUtterance
          beq TheEnd

          ;; New utterance ID is in the "mailbox"
          ;; Find it in the index.

          lda SpeechIndexH, y
          sta CurrentUtterance + 1

          lda SpeechIndexL, y
          sta CurrentUtterance

ContinueSpeaking:

          ;; check for expected buffer overflow
          inc SpeakJetCooldown
          inc SpeakJetCooldown
          lda SpeakJetCooldown
          cmp #$20              ; SpeakJet buffer is 32 bytes
          blt NotOverheated
          cmp #$20              ; cooldown value derived experimentally
          blt TheEnd
          lda #0
          sta SpeakJetCooldown

NotOverheated:
          ;; check buffer-full status
          lda SWCHA
          and #SerialReady
          beq TheEnd      ; not ready

          ;; get next speech byte
          ldy # 0
          lda (CurrentUtterance), y

          ;; invert data and check for end of string
          eor #$ff
          beq DoneSpeaking
          sta Temp                    ; byte being transmitted

          ;; increment speech pointer
          inc CurrentUtterance
          bne UtteranceNoPageCrossed
          inc CurrentUtterance + 1
UtteranceNoPageCrossed:

          ;; output byte as serial data

          sec            ; start bit
SerialSendBit:
          ;; put carry flag into bit 0 of SWACNT, perserving other bits
          lda SWACNT          ; 4
          and #$fe            ; 2 6
          adc # 0             ; 2 8
          sta SWACNT          ; 4 12

          ;; 10 bits sent? (1 start bit, 8 data bits, 1 stop bit)
          cpy # 9             ; 2 14
          beq TheEnd       ; 2 16
          iny                 ; 2 18

          ;; waste some cycles
          ldx     # 7
SerialDelayLoop:
          dex
          bne SerialDelayLoop ; 36 54

          ;; shift next data bit into carry
          lsr Temp             ; 5 59

          ;; and loop (branch always taken)
          gpl SerialSendBit    ; 3 62 cycles for loop

DoneSpeaking:
          ldy # 0
          sty CurrentUtterance
          sty CurrentUtterance + 1

TheEnd:
          lda SpeakJetCooldown
          beq +
          dec SpeakJetCooldown
+

          .fi                   ; end of not-NoSave

          rts
          .bend
