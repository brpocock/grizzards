;;; Grizzards Source/Routines/LearntMove.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          ;; Announce having learnt the move whose ID is in Temp
LearntMove:        .block
          .WaitScreenBottom

          lda GameMode
          cmp #ModeCombat
          bne +
          stx WSYNC
+

          .WaitScreenTop
          ;; Call with the move ID stashed in Temp
          .mva GameMode, #ModeLearntMove
          .mva DeltaX, Temp            ; Move learnt
          .mva AlarmCountdown, # 8

          .SetUtterance Phrase_Learnt

          ldy # 0
          sty DeltaY            ; ??
          .WaitScreenBottom
Loop:
          .WaitScreenTop

          .ldacolu COLGRAY, 0
          sta COLUP0
          sta COLUP1
          stx WSYNC
          .ldacolu COLTURQUOISE, $f
          sta COLUBK

          .SkipLines (KernelLines - 45) / 2

          .SetPointer LearntText
          jsr ShowPointerText

          ldy DeltaX            ; move learnt
          sty Temp
          .FarJSR TextBank, ServiceShowMoveDecoded

CheckForSpeech:
          lda DeltaY            ; ???
          bne CheckForAlarm

          lda CurrentUtterance + 1
          bne CheckForAlarm

          .mva CurrentUtterance + 1, #>Phrase_Move01 - 1
          lda #<Phrase_Move01 - 1
          clc
          adc DeltaX            ; move learnt
          sta CurrentUtterance
          .mva DeltaY, # 1            ; ???
CheckForAlarm:
          lda AlarmCountdown
          bne AlarmDone

          rts

AlarmDone:
          lda NewSWCHB
          beq SwitchesDone

          .BitBit SWCHBReset
          bne SwitchesDone

          .mva GameMode, #ModeColdStart
SwitchesDone:
          lda GameMode
          cmp #ModeLearntMove
          bne Leave

          .WaitScreenBottom
          jmp Loop

Leave:
          cmp #ModeColdStart
          beq GoColdStart

          rts

LearntText:
          .MiniText "LEARNT"

          .bend

;;; Audited 2022-02-16 BRPocock
