GrizzardStatsScreen: .block
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
          jmp GoSaveAndQuit
+
          and #SWCHBSelect
          beq StatsDone
          
Bouncey1:
          jmp GrizzardStatsScreen

StatsDone:
          lda #ModeCombat
          sta GameMode
          jmp CombatMainScreen
          
          .bend


AddToScore: .block            ; Add .a (BCD) to score
          sed
          clc
          adc Score
          bcc NCarScore0
          sta Score
          lda Score + 1
          clc
          adc # 1
          bcc NCarScore1
          sta Score + 1
          inc Score + 2
          jmp ScoreDone

NCarScore1:
          sta Score + 1
          jmp ScoreDone
NCarScore0:
          sta Score
ScoreDone:
          cld
          rts

          .bend
