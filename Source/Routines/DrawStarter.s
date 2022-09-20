;;; Grizzards Source/Routines/DrawStarter.s
;;; Copyright © 2022 Bruce-Robert Pocock

DrawStarter:        .block

          ;; XXX Dummy this out to actually write to EEPROM once

          lda SelectJatibuProgress
          cmp #$b9
          bne +

          rts

+

Write:      .macro value
          lda #\value
          jsr i2cTxByte
          .endm

          jsr i2cStartWrite

          .Write >SaveGameSlotPrefix
          .Write <0

          .enc "Unicode"
          .Write "G"
          .Write "R"
          .Write "I"
          .Write "Z"
          .Write "0"

          ldx # $20 - 5 - GlobalGameDataLength - 6
-
          lda #$fe
          jsr i2cTxByte
          dex
          bne -

          .enc "minifont"
          .Write "t"
          .Write "e"
          .Write "s"
          .Write "t"
          .Write "o"
          .Write "k"

          jsr i2cStopWrite

          .mva SelectJatibuProgress, #$b9
          rts


          .include "AtariAgeSave-EEPROM-Driver.s"

          .bend
