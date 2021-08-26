;;; Grizzards Source/Banks/Bank01/GrizzardStartingStats.s
;;; Copyright © 2021 Bruce-Robert Pocock
GrizzardStartingStats:        .block
          ;; For each Grizzard there are 5 bytes
          ;; the order of which is the same as ZeroPage:
          ;; Max HP, ATK, DEF, (unused), and MovesKnown

          ;; 0
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 12, 4, 4, 4, $0f
          .byte 12, 4, 4, 4, $0f
          .byte 12, 4, 4, 4, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          ;; 10
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          ;; 20
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          .byte 10, 1, 1, 1, $0f
          ;; ↑ 29
          
          .bend
