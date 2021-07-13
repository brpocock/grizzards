;;; Grizzards Source/Common/GrizzardStatsScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock
GrizzardStatsScreen: .block

          lda #ModeGrizzardStats
          sta GameMode

          lda # 0
          sta NewSWCHB

Loop:

          jsr VSync
          jsr VBlank

          ldx #4
-
          sta WSYNC
          dex
          bne -

          .FarJSR TextBank, ServiceShowGrizzardStats

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

          lda NewSWCHB
          beq Bouncey1
          and #SWCHBReset
          bne +
          jmp GoQuit
+
          lda NewSWCHB
          and #SWCHBSelect
          bne Bouncey1

          lda DeltaY
          sta GameMode

Bouncey1:
          jsr Overscan

          lda GameMode
          cmp #ModeGrizzardStats
          beq Loop

          ldy # 0
          sty NewSWCHB

          cmp #ModeCombat
          bne +
          jmp CombatMainScreen
+

          brk
          .bend
