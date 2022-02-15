;;; Grizzards Source/Routines/LevelUp.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          ;; Which level/s were raised? Store in Temp as bit flags
LevelUp:        .block
          .WaitScreenBottom
          .WaitScreenTop
          ;; Call with the level raised in Temp
          lda #ModeLevelUp
          sta GameMode

          lda Temp
          sta DeltaX            ; level/s raised

          lda # 8
          sta AlarmCountdown

          .SetUtterance Phrase_LevelUp

          ldy # 0
          sty DeltaY            ; screen φ
          .WaitScreenBottom
Loop:
          .WaitScreenTop

          stx WSYNC
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

          lda DeltaX            ; level/s raised
          and #LevelUpAttack
          beq +

          .SetPointer AttackText
          jsr ShowPointerText
+
          lda DeltaX            ; level/s raised
          and #LevelUpDefend
          beq +

          .SetPointer DefendText
          jsr ShowPointerText
+
          lda DeltaX            ; level/s raised
          and #LevelUpMaxHP
          beq +

          .SetPointer MaxHPText
          jsr ShowPointerText
+
CheckForSpeech:
          lda DeltaY            ; screen φ
          cmp # 4
          bge CheckForAlarm

          lda CurrentUtterance + 1
          bne CheckForAlarm

          lda DeltaY            ; screen φ
          cmp # 1
          bge PassAttack

          lda DeltaX            ; level/s raised
          and #LevelUpAttack
          beq +
          .SetUtterance Phrase_StatusFXAttack
          inc DeltaY            ; screen φ
          gne CheckForAlarm
+
          inc DeltaY            ; screen φ
PassAttack:
          lda DeltaY            ; screen φ
          cmp # 2
          bge PassDefend

          lda DeltaX            ; level/s raised
          .BitBit LevelUpDefend
          beq +
          .SetUtterance Phrase_StatusFXDefend
          inc DeltaY            ; screen φ
          gne CheckForAlarm
+
          inc DeltaY            ; screen φ
PassDefend:
          lda DeltaY            ; screen φ
          cmp # 3
          bge CheckForAlarm

          lda DeltaX            ; level/s raised
          .BitBit LevelUpMaxHP
          beq +
          .SetUtterance Phrase_MaxHP
+
          inc DeltaY            ; screen φ

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
          bne Leave
          .WaitScreenBottom
          jmp Loop

Leave:
          cmp #ModeColdStart
          beq GoColdStart

          rts
;;; 
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

;;; Audited 2022-02-15 BRPocock
