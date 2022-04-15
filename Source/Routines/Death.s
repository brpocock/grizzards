;;; Grizzards Source/Routines/Death.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

Death:    .block

          ;; Blow away the stack, we're starting over
          ldx #$ff
          txs

          .SetUtterance Phrase_GameOver

          .mva GameMode, #ModeDeath
          .mva NextSound, #SoundGameOver
          .mva AlarmCountdown, # 120

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
          and #ButtonI
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

;;; Audited 2022-02-16 BRPocock
