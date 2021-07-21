;;; Grizzards Source/Routines/ShowGrizzardStats.s
;;; Copyright © 2021 Bruce-Robert Pocock
ShowGrizzardStats:  .block
          .ldacolu COLTURQUOISE, 8
          sta COLUBK
          .ldacolu COLINDIGO, 0
          sta COLUP0
          sta COLUP1
          
          jsr ShowGrizzardName
          jsr DrawGrizzard

          jsr Prepare48pxMobBlob
          
          .ldacolu COLINDIGO, 0
          sta COLUP0
          sta COLUP1

          lda #> StatsText
          sta Pointer +1
          lda #< StatsText
          sta Pointer
          lda GrizzardAttack
          jsr AppendDecimalAndPrint

          lda #> StatsText + 6
          sta Pointer +1
          lda #< StatsText + 6
          sta Pointer
          lda GrizzardDefense
          jsr AppendDecimalAndPrint

          lda #> StatsText + 12
          sta Pointer +1
          lda #< StatsText + 12
          sta Pointer
          lda CurrentHP
          jsr AppendDecimalAndPrint

          lda #> StatsText + 18
          sta Pointer +1
          lda #< StatsText + 18
          sta Pointer
          lda MaxHP
          jmp AppendDecimalAndPrint

          ldx # 16
-
          stx WSYNC
          dex
          bne -

          .bend
