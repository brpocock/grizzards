;;; Grizzards Source/Routines/Death.s
;;; Copyright © 2021 Bruce-Robert Pocock

Death:    .block

          ;; Blow away the stack, we're starting over
          ldx #$ff
          txs

          ldx #ModeDeath
          stx GameMode

Loop:
          jsr VSync
          jsr VBlank

          .ldacolu COLGRAY, 0
          sta COLUBK
          .ldacolu COLGRAY, 9
          sta COLUP0
          sta COLUP1

          jsr Prepare48pxMobBlob
          .LoadString " GAME "
          ldx #TextBank
          ldy #ServiceDecodeAndShowText
          jsr FarCall
          .LoadString " OVER "
          ldx #TextBank
          ldy #ServiceDecodeAndShowText
          jsr FarCall

          ldx # KernelLines - 43
-
          stx WSYNC
          dex
          bne -

          jsr Overscan

          lda GameMode
          cmp #ModeDeath
          bne Leave
          jmp Loop

Leave:
          jmp GoColdStart

          .bend
