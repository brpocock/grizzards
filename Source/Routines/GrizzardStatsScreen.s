;;; Grizzards Source/Common/GrizzardStatsScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock
GrizzardStatsScreen: .block

          lda #ModeGrizzardStats
          sta GameMode

          lda # 0
          sta NewSWCHB
;;; 
Loop:
          jsr VSync

          .SkipLines 4

          .if BANK == TextBank
          jsr ShowGrizzardStats
          .else
          .FarJSR TextBank, ServiceShowGrizzardStats
          .fi

          .ldacolu COLINDIGO, 0
          sta COLUP0
          sta COLUP1

          .if TV == NTSC
          .SkipLines KernelLines - 137
          .else
          .SkipLines KernelLines - 145
          .fi
;;; 
          lda NewSWCHB
          beq Bouncey1
          .BitBit SWCHBReset
          bne +
          jmp GoQuit
+
          .BitBit SWCHBSelect
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

          .if ((BANK == CombatBank0To127) || (BANK == CombatBank128To255))

          cmp #ModeCombat
          bne +
          lda # 1
          jsr SetNextAlarm
          jmp CombatMainScreen
+

          .else

          cmp #ModeGrizzardDepot
          bne +
          jmp GrizzardDepot
+

          .fi

          brk
          .bend
