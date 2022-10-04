;;; Grizzards Source/Routines/PeekGrizzardXP.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

PeekGrizzardXP:       .block
          ;; Call with Grizzard index in Temp
          ;; Return with Temp = $80 if found
          ;; Return with Temp = $00 it not

          lda Temp               ; parameter = Grizzard ID
          jsr SetGrizzardAddress ; takes input in A as well

          .if !ATARIAGESAVE
            jsr i2cStopWrite
          .fi
          .if ATARIAGESAVE
            lda SaveGameSlot
          .fi
          jsr i2cStartRead

          jsr i2cRxByte         ; Max HP
          bne PeekGrizzard.FoundGrizzard

          jsr i2cRxByte         ; Attack
          jsr i2cRxByte         ; Defend
          jsr i2cRxByte         ; XP
          beq PeekGrizzard.NoGrizzard
          gne PeekGrizzard.FoundGrizzard

          .bend
