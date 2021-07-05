;;; Grizzards Source/Routines/PlaySpeech.s
;;; Copyright © 2021 Bruce-Robert Pocock
;;; The following  subroutine based upon  AtariVox Speech Synth  Driver, by
;;; Alex Herbert, 2004; altered by Bruce-Robert Pocock, 2017, 2020


PlaySpeech: .block
          SerialOutput = $01
          SerialReady = $02

          lda CurrentUtterance + 1
          and #$f0
          bne ContinueSpeaking

          lda CurrentUtterance
          beq TheEnd

          ;; New utterance ID is in the "mailbox"
          ;; Find it in the index.

          lda CurrentUtterance + 1
          adc #>SpeechIndexH
          sta Pointer + 1
          lda CurrentUtterance
          adc #<SpeechIndexH
          sta Pointer
          lda (Pointer), y
          sta Temp

          lda CurrentUtterance + 1
          adc #>SpeechIndexL
          sta Pointer + 1
          lda CurrentUtterance
          adc #<SpeechIndexL
          sta Pointer
          lda (Pointer), y
          sta CurrentUtterance

          lda Temp
          sta CurrentUtterance + 1

          ;; New utterance will start on the next frame
          jmp TheEnd

ContinueSpeaking:

          ;; check for expected buffer overflow
          inc SpeakJetCooldown
          lda SpeakJetCooldown
          cmp #$20              ; seems to hang after 36 bytes or so
          bmi NotOverheated
          cmp #$70              ; cooldown value derived experimentally
          bmi TheEnd
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
          bpl SerialSendBit    ; 3 62 cycles for loop

DoneSpeaking:
          lda #0
          sta CurrentUtterance
          sta CurrentUtterance + 1

TheEnd:
          rts
          .bend
