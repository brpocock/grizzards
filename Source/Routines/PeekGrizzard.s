;;; Grizzards Source/Routines/PeekGrizzard.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

PeekGrizzard:       .block
          ;; Peek to see if a Grizzard is _currently_ in the party
          
          ;; Use  PeekGrizzardXP to  find those  who have  metamorphosed
          ;; as well.

          ;; Call with Grizzard index in Temp
          ;; Return with Carry Set if found
          ;; Return with Carry Clear it not

          lda Temp
          jsr SetGrizzardAddress ; takes input in .A as well

          jsr i2cStopWrite

          .if ATARIAGESAVE
            lda SaveGameSlot
          .fi
          jsr i2cStartRead

          jsr i2cRxByte

          beq NoGrizzard        ; MaxHP = 0 = no Grizzard

          jsr i2cStopRead

          ;; Grizzard found!
          .mva Temp, #$80
          sec
          rts

NoGrizzard:
          jsr i2cStopRead

          .mvy Temp, # 0
          clc
          rts

          .bend

