GrizzardStatsScreen: .block

          lda SWCHB
          sta DebounceSWCHB

Loop:     
          jsr VSync
          jsr VBlank

          ldx #4
-
          sta WSYNC
          dex
          bne -

          ldy #ServiceShowGrizzardStats
          ldx #TextBank
          jsr FarCall
          .ldacolu COLINDIGO, 0
          sta COLUP0
          sta COLUP1


          ldx # 20
-
          stx WSYNC
          dex
          bne -

          ldx # KernelLines - 180
-
          stx WSYNC
          dex
          bne -

          jsr Overscan

          lda SWCHB
          cmp DebounceSWCHB
          beq Bouncey1
          sta DebounceSWCHB
          and #SWCHBReset
          bne +
          jmp GoQuit
+
          and #SWCHBSelect
          beq StatsDone
          
Bouncey1:
          jmp Loop

StatsDone:
          lda #ModeCombat
          sta GameMode
          jmp CombatMainScreen
          
          .bend
