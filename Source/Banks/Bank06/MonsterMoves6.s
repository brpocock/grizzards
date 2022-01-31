;;; Grizzards Source/Banks/Bank06/MonsterMoves6.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
MonsterMoves:       .block
          ;; Each monster type can know 4 moves

          ;; 0
          .byte 2, 2, 27, 29    ; Wicked Slime
          .byte 2, 27, 26, 29   ; Horrid Slime
          .byte 35, 12, 29, 23  ; Vorpal Bunny
          .byte 35, 30, 17, 14  ; ROUS
          .byte 35, 3, 30, 9    ; Lectro Sheep
          .byte 9, 14, 23, 31   ; VIking Turtle
          .byte 17, 18, 19, 20  ; Crazy Fox
          .byte 2, 39, 35, 44   ; WaterKitty
          ;; 8
          .byte 4, 17, 18, 30   ; Flame Doggo
          .byte 1, 2, 3, 4      ; Fuzzie Bear
          .byte 1, 2, 3, 4      ; Metal Mouse
          .byte 18, 19, 20, 31  ; Fire Panda
          .byte 1, 2, 3, 4      ; Leggy Mutant
          .byte 1, 2, 3, 4      ; Sky Mutant
          .byte 19, 20, 30, 31  ; Will-O-Wisp
          .byte 1, 2, 3, 4      ; Butterfly
          ;; 16
          .byte 35, 35, 35, 21  ; Scary Rat
          .byte 36, 31, 22, 35  ; Cave Grue
          .byte 45, 13, 16, 31  ; Cave Bat
          .byte 25, 24, 24, 36  ; Venom Sheep
          .byte 40, 41, 43, 43  ; 1-Eyed Cyclops
          .byte 1, 2, 3, 4      ; Fierce Raptor
          .byte 1, 2, 3, 4      ; Devil Eagle
          .byte 1, 2, 3, 4      ; Round Robin
          ;; 24
          .byte 1, 2, 3, 4      ; Giant Crab
          .byte 1, 2, 3, 4      ; Bigger Crab
          .byte 1, 2, 3, 4      ; Mean Robber
          .byte 1, 2, 3, 4      ; Giant Slime
          .byte 40, 41, 42, 44  ; Dragon Fred
          .byte 40, 41, 42, 44  ; Dragon Andrew
          .byte 40, 41, 42, 43  ; Dragon Timmy
          .byte 1, 2, 3, 4      ; Uber Slime
          ;; 32
          .byte 1, 2, 3, 4      ; Desert Eagle
          .byte 1, 2, 3, 4      ; Crazed Robber
          .byte 1, 2, 3, 4      ; Great Wyrm
          .byte 1, 2, 3, 4      ; Poison Asp
          .byte 1, 2, 3, 4      ; Grabby Crabby
          .byte 45, 48, 23, 30  ; Giant Bat
          .byte 22, 23, 44, 32  ; Maze Jaguar
          .byte 1, 2, 3, 4
          ;; 40
          .byte 1, 2, 3, 4
          .byte 1, 2, 3, 4
          .byte 1, 2, 3, 4
          .byte 1, 2, 3, 4
          .byte 1, 2, 3, 4
          .byte 1, 2, 3, 4      ; Boss Bear
          ;; ↑ 45

          .bend
