;;; Grizzards Source/Routines/Death.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

Death:    .block

          ;; Blow away the stack, we're starting over
          ldx #$ff
          txs

          lda #>Phrase_GameOver
          sta CurrentUtterance + 1
          lda #<Phrase_GameOver
          sta CurrentUtterance

          ldx #ModeDeath
          stx GameMode

          ldx #SoundGameOver
          stx NextSound

          lda # 120
          sta AlarmCountdown

;;; 
Loop:
          .WaitScreenBottom
          .WaitScreenTop

          .ldacolu COLGRAY, 0
          sta COLUBK
          .ldacolu COLGRAY, 9
          sta COLUP0
          sta COLUP1

          .SkipLines KernelLines / 3
          jsr Prepare48pxMobBlob
          .LoadString " GAME "
          .FarJSR TextBank, ServiceDecodeAndShowText
          .LoadString " OVER "
          .FarJSR TextBank, ServiceDecodeAndShowText

;;; 
          lda NewSWCHB
          beq +
          .BitBit SWCHBReset
          beq Leave
+
	lda NewButtons
          beq +
          .BitBit PRESSED
          beq Leave
+
          lda AlarmCountdown
          beq Leave
          jmp Loop

Leave:
          .FarJMP SaveKeyBank, ServiceAttract

          .bend
