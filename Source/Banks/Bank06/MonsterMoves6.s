;;; Grizzards Source/Banks/Bank06/MonsterMoves6.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
MonsterMoves:       .block
          ;; Each monster type can know 4 moves

          ;; 0
          .byte 2, 2, 27, 29    ; Wicked Slime (1)
          .byte 2, 27, 26, 29   ; Horrid Slime (1)
          .byte 12, 46, 11, 30  ; Vorpal Bunny (4)
          .byte 6, 11, 30, 1    ; ROUS (3)
          .byte 52, 61, 49, 31  ; Lectro Sheep (11)
          .byte 44, 22, 59, 31  ; Viking Turtle (7)
          .byte 22, 44, 19, 35  ; Crazy Fox (7)
          .byte 47, 23, 44, 31  ; WaterKitty (9)
          ;; 8
          .byte 4, 6, 11, 30    ; Flame Doggo (3)
          .byte 23, 48, 35, 31  ; Creepy Spider (8)
          .byte 23, 44, 22, 30  ; Metal Mouse (8)
          .byte 4, 11, 13, 30   ; Fire Panda (3)
          .byte 25, 52, 40, 30  ; Leggy Mutant (11)
          .byte 4, 3, 2, 1      ; Sky Mutant (2)
          .byte 18, 37, 4, 30   ; Will-O-Wisp (4)
          .byte 20, 47, 60, 31  ; Butterfly (10)
          ;; 16
          .byte 24, 61, 51, 47  ; Scary Rat (12)
          .byte 21, 35, 12, 46  ; Cave Grue (5)
          .byte 45, 35, 12, 18  ; Cave Bat (5)
          .byte 39, 19, 29, 31  ; Venom Sheep (6)
          .byte 59, 39, 19, 37  ; 1-Eyed Cyclops (6)
          .byte 51, 47, 23, 30  ; Fierce Raptor (10)
          .byte 24, 53, 61, 31  ; Devil Skull (12)
          .byte 29, 3, 2, 1     ; Round Robin (2)
          ;; 24
          .byte 47, 50, 49, 23  ; Giant Crab (9)
          .byte 41, 53, 54, 31  ; Bigger Crab (13)
          .byte 49, 59, 31, 37  ; Mean Robber (8)
          .byte 62, 62, 62, 31  ; Giant Slime (13)
          .byte 40, 41, 42, 43  ; Dragon Fred (16)
          .byte 40, 41, 42, 43  ; Dragon Andrew (16)
          .byte 40, 41, 42, 43  ; Dragon Timmy (16)
          .byte 62, 62, 56, 56  ; Uber Slime (15)
          ;; 32
          .byte 54, 54, 53, 24  ; Flying Skull (13)
          .byte 42, 58, 54, 58  ; Crazy Skull (15)
          .byte 43, 55, 43, 32  ; Great Wyrm (14)
          .byte 24, 24, 24, 32  ; Poison Asp (12)
          .byte 47, 50, 44, 59  ; Grabby Crabby (9)
          .byte 43, 57, 57, 32  ; Giant Bat (14)
          .byte 43, 55, 41, 32  ; Maze Jaguar (14)
          .byte 58, 55, 58, 32  ; Giant Spider (15)
          ;; 40
          .byte 52, 20, 51, 31  ; Fire Drake (11)
          .byte 53, 25, 40, 53  ; Man Bull (12)
          .byte 22, 59, 35, 30  ; Radish Goblin (7)
          .byte 24, 61, 40, 32  ; Turnip Goblin (12)
          .byte 42, 56, 58, 32  ; Anubis Jackal (15)
          .byte 42, 43, 55, 58  ; Boss Bear (16)
          ;; ↑ 45

          .bend
