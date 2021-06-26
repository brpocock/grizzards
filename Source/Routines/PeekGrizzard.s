;;; Grizzards Source/Routines/PeekGrizzard.s
;;; Copyright © 2021 Bruce-Robert Pocock

PeekGrizzard:       .block

          ;; Call with Grizzard index in .A
          ;; Return with Carry Set if found
          ;; Return with Carry Clear it not

          jsr SetGrizzardAddress ; takes input in .A as well
          jsr i2cStopWrite
          jsr i2cStartRead

          jsr i2cRxByte
          beq NoGrizzard        ; MaxHP = 0 = no Grizzard
          cmp #$ff
          beq NoGrizzard        ; Garbage read = no Grizzard
          ;; Grizzard found!
          sec
          rts

NoGrizzard:
          clc
          rts

          .bend
