;;; Grizzards Source/Routines/PeekGrizzardXP.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

PeekGrizzardXP:       .block
          ;; Call with Grizzard index in Temp
          ;; Return with Temp = $80 if found
          ;; Return with Temp = $00 it not

          lda Temp               ; parameter = Grizzard ID
          jsr SetGrizzardAddress ; takes input in A as well

          jsr i2cStopWrite
          .if ATARIAGESAVE
            lda SaveGameSlot
          .fi
          jsr i2cStartRead

          jsr i2cRxByte         ; Max HP
          bne FoundGrizzard

          jsr i2cRxByte         ; Attack
          jsr i2cRxByte         ; Defend
          jsr i2cRxByte         ; XP
          beq NoGrizzard

FoundGrizzard:
          jsr i2cStopRead

          .mva Temp, #$80
          rts

NoGrizzard:
          jsr i2cStopRead

          .mva Temp, # 0
          rts

          .bend
