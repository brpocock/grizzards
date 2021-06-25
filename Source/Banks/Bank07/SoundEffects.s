;;; SoundEffects.s
;;; Copyright © 2021 Bruce-Robert Pocock

          ;; Don't forget to update the Enums.s table as well
          SoundIndex = (Drone, Chirp, Deleted, Happy, Bump, ErrorSound)

          SoundCount = len(SoundIndex)

SoundIndexH:        .byte >SoundIndex
SoundIndexL:        .byte <SoundIndex

          ;; Format:
          ;; First byte: AUDV0 << 4 | AUDC0
          ;; Second byte: AUDF0 | $80 for end of sequence
          ;; Third byte: duration in frames
          
Drone:
          .byte $81, $8f, 60

Chirp:
          .byte $f4, $8f, 40
          
Deleted:
          .byte $f8, $1f, 20
          .byte $f1, $88, 10
          
Happy:
          .byte $f4, $10, 20
          .byte $f5, $8f, 20

Bump:
          .byte $81, $8f, 5

ErrorSound:
          .byte $81, $0f, 10
          .byte $81, $20, 10
          .byte $81, $0f, 10
          .byte $81, $20, 10
          .byte $81, $0f, 10
          .byte $81, $a0, 10

