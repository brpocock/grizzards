;;; Grizzards Source/Routines/PeekGrizzardXP.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

PeekGrizzardXP:       .block
          ;; Call with Grizzard index in Temp
          ;; Return with Temp = $80 if found
          ;; Return with Temp = $00 it not

          lda Temp
          jsr SetGrizzardAddress ; takes input in A as well

          jsr i2cStopWrite
          .if ATARIAGESAVE
            lda SaveGameSlot
          .fi
          jsr i2cStartRead

          ;; Max HP, Attack, Defend, XP, Moves Known
          ldx # 5
Read5Bytes:
          jsr i2cRxByte

          beq NotYet

          cmp #$ff
          beq NotYet

          jmp FoundGrizzard

NotYet:
          dex
          bne Read5Bytes

NoGrizzard:
          jsr i2cStopRead

          .mva Temp, # 0
          rts

FoundGrizzard:
          jsr i2cStopRead

          .mva Temp, #$80
          rts

          .bend
