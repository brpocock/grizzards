;;; Grizzards Source/Banks/Bank01/GrizzardStartingStats.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
GrizzardStartingStats:        .block
          ;; For each Grizzard there are 5 bytes
          ;; the order of which is the same as ZeroPage:
          ;; Max HP, ATK, DEF, (unused), and MovesKnown

          ;; 0
Dirtex:
          .byte  8,  1,  1,  0,  $0f
Aquax:
          .byte  8,  1,  1,  0,  $0f
Airex:
          .byte  8,  1,  1,  0,  $0f
Flamex:
          .byte 10,  4,  4,  0,  $0f
Soiley:
          .byte 10,  4,  4,  0,  $0f
Wetnas:
          .byte 10,  4,  4,  0,  $0f
Windoo:
          .byte 10,  4,  4,  0,  $0f
Firend:
          .byte 12,  6,  6,  0,  $0f
          ;; 8
Lander:
          .byte 12,  6,  6,  0,  $0f
Sailor:
          .byte 12,  6,  6,  0,  $0f
          ;; 10
Flyer:
          .byte 12,  6,  6,  0,  $0f
Burner:
          .byte 16,  8,  8,  0,  $0f
Splodo:
          .byte  5, 75, 15,  0,  $0f
Tyrant:
          .byte 20, 20, 20,  0,  $0f
Dufont:
          .byte 30, 15, 15,  0,  $0f
Theref:
          .byte 30, 15, 15,  0,  $0f
          ;; 16
Cornet:
          .byte 30, 15, 15,  0,  $0f
Ambren:
          .byte 40, 20, 20,  0,  $0f
Noctis:
          .byte 40, 20, 20,  0,  $0f
Corlyn:
          .byte 40, 20, 20,  0,  $0f
          ;; 20
Wapow:
          .byte 45, 24, 24,  0,  $0f
Zendex:
          .byte 45, 24, 24,  0,  $0f
Oceax:
          .byte 45, 24, 24,  0,  $0f
Flitex:
          .byte 50, 25, 25,  0,  $0f
          ;; 24
Flarex:
          .byte 50, 25, 25,  0,  $0f
Uptrix:
          .byte 75, 37, 37,  0,  $0f
Altrix:
          .byte 75, 37, 37,  0,  $0f
Ectrix:
          .byte 75, 37, 37,  0,  $0f
Ortrix:
          .byte 75, 37, 37,  0,  $0f
Megax:
          .byte 90, 90, 90,  0,  $ff
          ;; ↑ 29
          
          .bend
