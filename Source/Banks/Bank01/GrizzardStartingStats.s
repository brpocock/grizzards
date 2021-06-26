;;; Grizzards Source/Banks/Bank01/GrizzardStartingStats.s
;;; Copyright © 2021 Bruce-Robert Pocock
GrizzardStartingStats:        .block
          ;; For each Grizzard there are 5 bytes
          ;; the order of which is the same as ZeroPage:
          ;; Max HP, ATK, DEF, ACU, and MovesKnown

          ;; 0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          ;; 10
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          ;; 20
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          .byte 10, 1, 1, 1, $f0
          ;; ↑ 29
          
          .bend
