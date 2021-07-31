;;; Grizzards Source/Routines/LearntMove.s
;;; Copyright © 2021 Bruce-Robert Pocock

LearntMove:        .block
          .WaitScreenTop
          ;; Call with the move ID stashed in Temp
          lda #ModeLearntMove
          sta GameMode

          lda Temp
          sta DeltaX

          lda # 4
          jsr SetNextAlarm

          lda #>Phrase_Learnt
          sta CurrentUtterance + 1
          lda #<Phrase_Learnt
          sta CurrentUtterance

          lda # 0
          sta DeltaY
          .WaitScreenBottom
Loop:
          .WaitScreenTop

          .ldacolu COLGRAY, 0
          sta COLUP0
          sta COLUP1
          .ldacolu COLTURQUOISE, $f
          sta COLUBK

          .SkipLines (KernelLines - 45) / 2

          .SetPointer LearntText
          jsr CopyPointerText
          .FarJSR TextBank, ServiceDecodeAndShowText

          ldy DeltaX
          sty Temp
          .FarJSR TextBank, ServiceShowMoveDecoded

CheckForSpeech:
          lda DeltaY
          bne CheckForAlarm

          lda CurrentUtterance + 1
          bne CheckForAlarm

          lda #>Phrase_Move01 - 1
          sta CurrentUtterance + 1
          lda #<Phrase_Move01 - 1
          clc
          adc DeltaX
          sta CurrentUtterance
          lda # 1
          sta DeltaY

CheckForAlarm:
          lda ClockSeconds
          cmp AlarmSeconds
          bne AlarmDone

          .WaitScreenBottom
          
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
          cmp #ModeLearntMove
          beq +
          cmp #ModeColdStart
          beq GoColdStart

          .WaitScreenBottom
          rts

+
          .WaitScreenBottom
          jmp Loop

LearntText:
          .MiniText "LEARNT"
          
          .bend
