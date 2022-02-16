;;; Grizzards Source/Routines/ShowGrizzardStats.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

ShowGrizzardStats:  .block
          stx WSYNC
          .ldacolu COLTURQUOISE, 8
          sta COLUBK

          .FarJSR AnimationsBank, ServiceDrawGrizzard
          jsr Prepare48pxMobBlob

          ;; Name & number are in color of Grizzard
          jsr ShowGrizzardName

          .SetPointer NumText
          jsr CopyPointerText
          lda CurrentGrizzard
          clc
          adc # 1
          jsr AppendDecimalAndPrint

          .ldacolu COLINDIGO, 0
          sta COLUP0
          sta COLUP1

          .SkipLines 16 

          .SetPointer StatsText
          lda GrizzardAttack
          jsr AppendDecimalAndPrint

          .mva Pointer, #< StatsText + 6  ; high byte unchanged
          lda GrizzardDefense
          jsr AppendDecimalAndPrint

          .mva Pointer, #< StatsText + 12 ; high byte unchanged
          lda CurrentHP
          jsr AppendDecimalAndPrint

          .mva Pointer, #< StatsText + 18 ; high byte unchanged
          lda MaxHP
          jmp AppendDecimalAndPrint ; tail call

NumText:
          .MiniText "NUM.00"

          .align $20            ; XXX alignment

          .page
StatsText:
          .MiniText "ATK.00"
          .MiniText "DEF.00"
          .MiniText "HP  00"
          .MiniText "MAX 00"
          .endp

          .bend

;;; Audited 2022-02-16 BRPocock
