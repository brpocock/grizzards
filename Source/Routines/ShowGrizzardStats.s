;;; Grizzards Source/Routines/ShowGrizzardStats.s
;;; Copyright © 2021 Bruce-Robert Pocock
ShowGrizzardStats:  .block
          .ldacolu COLTURQUOISE, 8
          sta COLUBK
          .ldacolu COLINDIGO, 0
          sta COLUP0
          sta COLUP1

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
          jmp AppendDecimalAndPrint

StatsText:
          .MiniText "ATK 00"
          .MiniText "DEF 00"
          .MiniText "HP  00"
          .MiniText "MAX 00"
          .NoPageCrossSince StatsText

          .bend
