;;; Grizzards Source/Routines/PeekGrizzardXP.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

PeekGrizzardXP:       .block

          ;; Call with Grizzard index in Temp
          ;; Return with Carry Set if found
          ;; Return with Carry Clear it not

          lda Temp
          jsr SetGrizzardAddress ; takes input in .A as well

          jsr i2cK2

          ;; Max HP, Attack, Defend, XP
          ldx # 4
-
          jsr i2cRxByte

          dex
          bne -

          beq NoGrizzard        ; XP = 0 = no Grizzard

          cmp #$ff
          beq NoGrizzard        ; Garbage read = no Grizzard

          jsr i2cStopRead

          ;; Grizzard found!
          sec
          rts

NoGrizzard:
          jsr i2cStopRead

          clc
          rts

          .bend

;;; Audited 2022-02-16 BRPocock
