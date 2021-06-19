ShowGrizzardStats:
          .ldacolu COLBLUE, $f
          sta COLUBK
          .ldacolu COLINDIGO, 0
          sta COLUP0
          sta COLUP1
          
          jsr ShowGrizzardName

          jsr DrawGrizzard
          
          .ldacolu COLINDIGO, 0
          sta COLUP0
          sta COLUP1

          lda #> StatsText
          sta Pointer +1
          lda #< StatsText
          sta Pointer
          lda CurrentAttack
          jsr AppendDecimalAndPrint

          lda #> StatsText + 6
          sta Pointer +1
          lda #< StatsText + 6
          sta Pointer
          lda CurrentDefense
          jsr AppendDecimalAndPrint

          lda #> StatsText + 12
          sta Pointer +1
          lda #< StatsText + 12
          sta Pointer
          lda CurrentAccuracy
          jsr AppendDecimalAndPrint

          lda #> StatsText + 18
          sta Pointer +1
          lda #< StatsText + 18
          sta Pointer
          lda CurrentHP
          jsr AppendDecimalAndPrint

          lda #> StatsText + 24
          sta Pointer +1
          lda #< StatsText + 24
          sta Pointer
          lda MaxHP
          jmp AppendDecimalAndPrint
