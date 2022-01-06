;;; Grizzards Source/Routines/ShowGrizzardStats.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
ShowGrizzardStats:  .block
          stx WSYNC
          .if TV == SECAM
            lda #COLWHITE
            sta COLUBK
            lda #COLBLUE
          .else
            .ldacolu COLTURQUOISE, 8
            sta COLUBK
            .ldacolu COLINDIGO, 0
          .fi
          sta COLUP0
          sta COLUP1

          .SkipLines 30

          jsr ShowGrizzardName
          .FarJSR AnimationsBank, ServiceDrawGrizzard

          jsr Prepare48pxMobBlob

          .ldacolu COLINDIGO, 0
          sta COLUP0
          sta COLUP1

          .SetPointer StatsText
          lda GrizzardAttack
          jsr AppendDecimalAndPrint

          lda #< StatsText + 6  ; high byte unchanged
          sta Pointer
          lda GrizzardDefense
          jsr AppendDecimalAndPrint

          lda #< StatsText + 12 ; high byte unchanged
          sta Pointer
          lda CurrentHP
          jsr AppendDecimalAndPrint

          lda #< StatsText + 18 ; high byte unchanged
          sta Pointer
          lda MaxHP
          jmp AppendDecimalAndPrint ; tail call

          .align $20
StatsText:
          .MiniText "ATK 00"
          .MiniText "DEF 00"
          .MiniText "HP  00"
          .MiniText "MAX 00"
          .NoPageCrossSince StatsText

          .bend
