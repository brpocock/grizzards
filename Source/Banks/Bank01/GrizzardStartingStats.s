;;; Grizzards Source/Banks/Bank01/GrizzardStartingStats.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
GrizzardStartingStats:        .block
          ;; For each Grizzard there are 5 bytes
          ;; the order of which is the same as ZeroPage:
          ;; Max HP, ATK, DEF, Metamorphosis, and MovesKnown

          ;; 0
Dirtex:                         ; starter (see StartNewGame for duplicates of starter values)
          .byte 10, 1, 1, 8, $03
Aquax:                          ; starter
          .byte 10, 1, 1, 9, $03
Airex:                          ; starter
          .byte 10, 1, 1, 10, $03
Flamex:                         ; Fire Bog
          .byte 20, 6, 4, 11, $03
Petty:                         ; Cliffs near Port Lion
          .byte 30, 1, 1, 13, $ff
Wetnas:                         ; near Treble
          .byte 15, 6, 4, 0, $0f
Windoo:                         ; Spriral Woods
          .byte 20, 6, 4, 0, $0f
Firend:                         ; Beach near Port Lion
          .byte 30, 6, 6, 14, $0f
          ;; 8
Lander:                           ; from Dirtex
          .byte 30, 8, 8, 21, $27
Sailor:                         ; from Aquax
          .byte 30, 8, 8, 22, $27
          ;; 10
Flyer:                            ; from Airex
          .byte 30, 8, 8, 23, $27
Burner:                         ; from Flamex
          .byte 30, 10, 8, 24, $27
Splodo:                         ; Lost Mine
          .byte  5, 75, 15, 0, $ff
Tyrant:                         ; from Petty
          .byte 40, 30, 40, 29, $0f
Dufont:                         ; from Firend
          .byte 30, 15, 15, 20, $0f
Theref:                         ; in Labyrinth level C
          .byte 50, 45, 55, 0, $01
          ;; 16
Cornet:                         ; near Anchor
          .byte 30, 15, 15, 25, $0f
Ambren:                         ; near Anchor
          .byte 40, 20, 20, 26, $0f
Noctis:                         ; near Anchor
          .byte 40, 20, 20, 27, $0f
Corlyn:                         ; TBD!!
          .byte 40, 20, 20, 28, $0f
          ;; 20
Wapow:                       ; from Dufont
          .byte 45, 24, 24, 0, $0f
Zendex:                         ; from Lander
          .byte 45, 25, 25, 0, $0f
Oceax:                          ; from Sailor
          .byte 45, 25, 25, 0, $0f
Flitex:                         ; from Flyer
          .byte 45, 25, 25, 0, $0f
          ;; 24
Flarex:                          ; from Burner
          .byte 50, 25, 25, 0, $0f
Uptrix:                         ; from Cornet
          .byte 75, 37, 37, 0, $0f
Altrix:                         ; from Ambren
          .byte 75, 37, 37, 0, $0f
Ectrix:                         ; from Noctis
          .byte 75, 37, 37, 0, $0f
Ortrix:                         ; from Corlyn
          .byte 75, 37, 37, 0, $0f
Megax:                          ; from Tyrant
          .byte 90, 90, 90, 0, $ff
          ;; ↑ 29
          
          .bend
