;;; Grizzards Source/Routines/Death.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

Death:    .block

          ;; Blow away the stack, we're starting over
          ldx #$ff
          txs

          .SetUtterance Phrase_GameOver

          lda #ModeDeath
          sta GameMode

          lda #SoundGameOver
          sta NextSound

          lda # 120
          sta AlarmCountdown

          jmp LoopFirst
;;; 
Loop:
          .WaitScreenBottom
LoopFirst:
          .WaitScreenTop

          .ldacolu COLGRAY, 0
          sta COLUBK
          .ldacolu COLGRAY, 9
          sta COLUP0
          sta COLUP1

          .SkipLines KernelLines / 3
          jsr Prepare48pxMobBlob
          .SetPointer GameOverText
          jsr ShowPointerText

          .SetPointer GameOverText + 6
          jsr ShowPointerText
;;; 
          lda NewSWCHB
          beq +
          and #SWCHBReset
          beq Leave
+
	lda NewButtons
          beq +
          and #PRESSED
          beq Leave
+
          lda AlarmCountdown
          beq Leave
          jmp Loop

Leave:
          .FarJMP SaveKeyBank, ServiceAttract
;;; 
GameOverText:
          .MiniText " GAME "
          .MiniText " OVER "

          .bend

;;; Audited 2022-02-15 BRPocock
