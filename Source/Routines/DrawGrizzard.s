DrawGrizzard:
          lda #0
          sta VDELP0
          sta VDELP1
          sta NUSIZ0
          sta NUSIZ1

          .ldacolu COLGREEN | $f
          sta COLUP0
          sta COLUP1
          
          ldy # 8
-
          lda GrizzardImages - 1, y
          sta GRP0
          lda GrizzardImages + 7, y
          sta GRP1
          sta WSYNC
          sta WSYNC
          dey
          bne -

          sty GRP0
          sty GRP1

          rts
