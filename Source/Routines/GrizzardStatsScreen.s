;;; Grizzards Source/Common/GrizzardStatsScreen.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
GrizzardStatsScreen: .block
          .WaitScreenTop
          lda #ModeGrizzardStats
          sta GameMode

          .KillMusic
          sta NewSWCHB
          geq FirstLoop
;;; 
Loop:
          .WaitScreenTop
FirstLoop:
          .FarJSR TextBank, ServiceShowGrizzardStats

;;; 

          lda NewButtons
          beq NoButton
          and #PRESSED
          beq Select
NoButton:
          lda NewSWCHB
          beq Bouncey1
          .BitBit SWCHBReset
          bne +
          .FarJMP SaveKeyBank, ServiceAttract
+
          .BitBit SWCHBSelect
          bne Bouncey1

Select:
          lda DeltaY
          sta GameMode
          ldy # 0
          sty DeltaY

Bouncey1:
          lda GameMode
          cmp #ModeGrizzardStats
          bne +
          .WaitScreenBottom
          jmp Loop
+
          ldy # 0
          sty NewSWCHB

          .if ((BANK == CombatBank0To127) || (BANK == CombatBank128To255))

          cmp #ModeCombat
          bne +
          lda # 2
          sta AlarmCountdown

          jmp CombatMainScreen
+

          .else

          cmp #ModeGrizzardDepot
          bne +
          .WaitScreenBottom
          jmp GrizzardDepot.Loop
+
          .WaitScreenBottom
          rts

          .fi

          brk
          .bend
