;;; Grizzards Source/Routines/LevelUp.s
;;; Copyright © 2021 Bruce-Robert Pocock

LevelUp:        .block
          .WaitScreenTop
          ;; Call with the level raised in Temp
          lda #ModeLevelUp
          sta GameMode

          lda Temp
          sta DeltaX

          lda # 4
          jsr SetNextAlarm

          .SetUtterance Phrase_LevelUp

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

          .SkipLines KernelLines / 3

          .SetPointer LevelText
          jsr ShowPointerText

          .SetPointer UpText
          jsr ShowPointerText

          lda DeltaX
          .BitBit LevelUpAttack
          beq +

          .SetPointer AttackText
          jsr ShowPointerText
+
          lda DeltaX
          .BitBit LevelUpDefend
          beq +

          .SetPointer DefendText
          jsr ShowPointerText
+
          lda DeltaX
          .BitBit LevelUpMaxHP
          
          .SetPointer MaxHPText
          jsr ShowPointerText

CheckForSpeech:
          lda DeltaY
          bne CheckForAlarm

          lda CurrentUtterance + 1
          bne CheckForAlarm

          lda DeltaX
          .BitBit LevelUpAttack
          beq +
          .SetUtterance Phrase_StatusFXAttack
+
          lda DeltaX
          .BitBit LevelUpDefend
          beq +
          .SetUtterance Phrase_StatusFXDefend
+
          lda DeltaX
          .BitBit LevelUpMaxHP
          beq +
          .SetUtterance Phrase_MaxHP
+
          lda # 1
          sta DeltaY

CheckForAlarm:
          lda ClockSeconds
          cmp AlarmSeconds
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
          cmp #ModeLevelUp
          beq +
          cmp #ModeColdStart
          beq GoColdStart

          rts

+
          .WaitScreenBottom
          jmp Loop

ShowPointerText:
          jsr CopyPointerText
          jmp DecodeAndShowText ; tail call
          
LevelText:
          .MiniText "LEVEL "
UpText:
          .MiniText "  UP  "
AttackText:
          .MiniText "ATTACK"
DefendText:
          .MiniText "DEFEND"
MaxHPText:
          .MiniText "MAX HP"

          .bend
