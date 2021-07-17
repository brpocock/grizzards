;;; Grizzards Source/Routines/LearnedMove.s
;;; Copyright © 2021 Bruce-Robert Pocock

LearnedMove:        .block

          ;; Call with the move ID stashed in Temp
          lda #ModeLearnedMove
          sta GameMode

          lda Temp
          sta DeltaX

          lda # 4
          jsr SetNextAlarm
Loop:
          jsr VSync
          jsr VBlank

          .ldacolu COLGRAY, 0
          sta COLUP0
          sta COLUP1
          .ldacolu COLTURQUOISE, $f
          sta COLUBK

          .SkipLines (KernelLines - 45) / 2

          .SetPointer LearntText
          jsr CopyPointerText
          jsr DecodeAndShowText

          ldy DeltaX
          jsr ShowMove.WithDecodedMoveID

          .SkipLines (KernelLines - 45) / 2
          jsr Overscan

CheckForAlarm:
          lda ClockSeconds
          cmp AlarmSeconds
          bne AlarmDone

          lda ClockMinutes
          cmp AlarmMinutes
          bne AlarmDone
          rts

AlarmDone:

          lda NewSWCHB
          beq SwitchesDone
          .BitBit SWCHBReset
          bne SwitchesDone
          lda #ModeColdStart
          sta GameMode
SwitchesDone:

          lda GameMode
          cmp #ModeLearnedMove
          beq +
          cmp #ModeColdStart
          beq GoColdStart
          rts

+
          jmp Loop

LearntText:
          .MiniText "LEARNT"
          
          .bend
