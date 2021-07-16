;;; Grizzards Source/Common/MoveEffects.s
;;; Copyright © 2021 Bruce-Robert Pocock
MoveEffects:
          ;; 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte StatusSleep
          .byte StatusDefendDown
          .byte StatusAttackDown
          ;; 8
          .byte StatusDefendDown
          .byte StatusDefendUp
          .byte StatusAttackUp
          .byte StatusDefendDown
          .byte StatusAttackDown
          .byte 0
          .byte StatusAttackDown
          .byte StatusDefendDown
          ;; 16
          .byte StatusSleep
          .byte StatusAttackUp
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          ;; 24
          .byte 0
          .byte 0
          .byte StatusAttackDown | StatusDefendDown
          .byte StatusAttackDown
          .byte StatusDefendDown
          .byte 0
          .byte 0
          .byte 0
          ;; 32
          .byte 0
          .byte 0
          .byte 0
          .byte 3
          .byte StatusMuddle
          .byte 0
          .byte 0
          .byte 0
          ;; 40
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          ;; 48
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          ;; 56
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          ;; ↑ 63
;;; 
MoveDeltaHP:
          ;; 0
          .byte $ff             ; RUN AWAY has fake value to indicate there's no target
          .byte 2
          .byte 2
          .byte 2
          .byte 2
          .byte 0
          .byte 5
          .byte 0
          ;; 8
          .byte 0
          .byte 0
          .byte $ff
          .byte 5
          .byte 5
          .byte 0
          .byte 0
          .byte 0
          ;; 16
          .byte 0
          .byte 0
          .byte 5
          .byte 10
          .byte 15
          .byte 5
          .byte 10
          .byte 15
          ;; 24
          .byte 25
          .byte 25
          .byte 0
          .byte 0
          .byte 0
          .byte $ff ^ 2
          .byte $ff ^ 5
          .byte $ff ^ 10
          ;; 32
          .byte $ff ^ 25
          .byte $ff ^ 50
          .byte $ff ^ 99
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          ;; 40
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          ;; 48
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          ;; 56
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          ;; ↑ 63
