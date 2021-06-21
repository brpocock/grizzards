ShowGrizzardStats:  .block
          .ldacolu COLBLUE, $f
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
          lda GrizzardAccuracy
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

          .bend
