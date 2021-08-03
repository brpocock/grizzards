;;; Grizzards Source/Common/GrizzardStatsScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock
GrizzardStatsScreen: .block
          lda #ModeGrizzardStats
          sta GameMode

          lda # 0
          sta NewSWCHB
;;; 
Loop:
          .WaitScreenTop

          .if TV == NTSC
          ;; XXX would be nice in PAL, but we can't spare the bytes of ROM
          .SkipLines 10
          .fi

          .FarJSR TextBank, ServiceShowGrizzardStats

;;; 
          .WaitScreenBottom

          lda NewButtons
          beq NoButton
          and #PRESSED
          beq Select
NoButton:
          lda NewSWCHB
          beq Bouncey1
          .BitBit SWCHBReset
          bne +
          jmp GoQuit
+
          .BitBit SWCHBSelect
          bne Bouncey1

Select:
          lda DeltaY
          sta GameMode
          lda # 0
          sta DeltaY

Bouncey1:
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
          rts

          .fi

          brk
          .bend
