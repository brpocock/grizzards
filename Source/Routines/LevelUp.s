;;; Grizzards Source/Routines/LevelUp.s
;;; Copyright © 2021 Bruce-Robert Pocock

LevelUp:        .block
          .WaitScreenBottom
          .WaitScreenTop
          ;; Call with the level raised in Temp
          lda #ModeLevelUp
          sta GameMode

          lda Temp
          sta DeltaX

          lda # 8
          sta AlarmCountdown

          .SetUtterance Phrase_LevelUp

          lda # 0
          sta DeltaY
          .WaitScreenBottom
Loop:
          .WaitScreenTop

          .ldacolu COLTURQUOISE, $f
          sta COLUBK

          .ldacolu COLGRAY, 0
          sta COLUP0
          sta COLUP1

          .SkipLines KernelLines / 4

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
          beq +

          .SetPointer MaxHPText
          jsr ShowPointerText
+
CheckForSpeech:
          lda DeltaY
          cmp # 4
          bge CheckForAlarm

          lda CurrentUtterance + 1
          bne CheckForAlarm

          lda DeltaY
          cmp # 1
          bge PassAttack

          lda DeltaX
          .BitBit LevelUpAttack
          beq +
          .SetUtterance Phrase_StatusFXAttack
          inc DeltaY
          gne CheckForAlarm
+
          inc DeltaY
PassAttack:
          lda DeltaY
          cmp # 2
          bge PassDefend

          lda DeltaX
          .BitBit LevelUpDefend
          beq +
          .SetUtterance Phrase_StatusFXDefend
          inc DeltaY
          gne CheckForAlarm
+
          inc DeltaY
PassDefend:
          lda DeltaY
          cmp # 3
          bge CheckForAlarm

          lda DeltaX
          .BitBit LevelUpMaxHP
          beq +
          .SetUtterance Phrase_MaxHP
+
          inc DeltaY

CheckForAlarm:
          lda AlarmCountdown
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
