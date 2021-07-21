;;; Grizzards Source/Routines/Death.s
;;; Copyright © 2021 Bruce-Robert Pocock

Death:    .block

          ;; Blow away the stack, we're starting over
          ldx #$ff
          txs

          ldx #ModeDeath
          stx GameMode

          ldx #SoundGameOver
          stx NextSound
;;; 
Loop:
          jsr VSync

          .ldacolu COLGRAY, 0
          sta COLUBK
          .ldacolu COLGRAY, 9
          sta COLUP0
          sta COLUP1

          jsr Prepare48pxMobBlob
          .LoadString " GAME "
          .FarJSR TextBank, ServiceDecodeAndShowText
          .LoadString " OVER "
          .FarJSR TextBank, ServiceDecodeAndShowText

          .SkipLines KernelLines - 42

          jsr Overscan
;;; 
          lda NewSWCHB
          beq +
          .BitBit SWCHBReset
          beq Leave
+
	lda NewINPT4
          beq +
          .BitBit PRESSED
          beq Leave
+
          jmp Loop

Leave:
          jmp GoColdStart

          .bend
