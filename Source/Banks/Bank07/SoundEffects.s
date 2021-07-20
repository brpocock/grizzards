;;; SoundEffects.s
;;; Copyright © 2021 Bruce-Robert Pocock

          ;; Don't forget to update the Enums.s table as well
          SoundIndex = (Drone, Chirp, Deleted, Happy, Bump, ErrorSound, SweepUp, SongAtariToday, SongVictory, SongGameOver, Footstep)

          SoundCount = len(SoundIndex)

SoundIndexH:        .byte >SoundIndex
SoundIndexL:        .byte <SoundIndex

          ;; Format:
          ;; First byte: AUDV0 << 4 | AUDC0
          ;; Second byte: AUDF0 | $80 for end of sequence
          ;; Third byte: duration in frames
          ;; The .sound macro takes duration in jiffies and converts to
          ;; frames for PAL/SECAM

Drone:
          .sound $8, $1, $f, 60, 0
          .sound 0, 0, 0, 0, 1

Chirp:
          .sound $f, $4, $2, 2, 0
          .sound 0, 0, 0, 0, 1
          
Deleted:
          .sound $f, $8, $1f, 20, 0
          .sound $f, $1, $8, 10, 1
          
Happy:
          .sound $f, $4, $10, 20, 0
          .sound $f, $5, $f, 20, 0
          .sound 0, 0, 0, 0, 1

Footstep:
          .sound $f, $6, $10, 1, 0
          .sound 0, 0, 0, 0, 1

Bump:
          .sound $8, $1, $f, 5, 0
          .sound 0, 0, 0, 0, 1

ErrorSound:
          .sound $8, $1, $0f, 10, 0
          .sound $8, $1, $20, 10, 0
          .sound $8, $1, $0f, 10, 0
          .sound $8, $1, $20, 10, 0
          .sound $8, $1, $0f, 10, 0
          .sound $8, $1, $20, 10, 0
          .sound 0, 0, 0, 0, 1

SweepUp:
          .sound $8, $1, $0c, 4, 0
          .sound $8, $1, $0a, 4, 0
          .sound $8, $1, $08, 4, 0
          .sound $8, $1, $06, 4, 0
          .sound $8, $1, $04, 4, 0
          .sound $8, $1, $02, 4, 0
          .sound 0, 0, 0, 0, 1

