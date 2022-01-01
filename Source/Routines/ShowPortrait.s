;;; Grizzards Source/Routines/ShowPortrait.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
Faces:    .block
          jsr VSync

          lda # COLGREEN | $0
          sta COLUBK

          lda # COLBLUE | $f
          sta COLUP0
          sta COLUP1
          
          jsr Prepare48pxMobBlob

          .SkipLines 10

          lda # 0 
          clc
          adc #>Portraits
          sta pp0h
          sta pp1h
          sta pp2h
          sta pp3h
          sta pp4h
          sta pp5h
          lda #42 * 0
          sta pp0l
          lda #42 * 1
          sta pp1l
          lda #42 * 2
          sta pp2l
          lda #42 * 3
          sta pp3l
          lda #42 * 4
          sta pp4l
          lda #42 * 5
          sta pp5l

          ldy #42
          sty LineCounter
          jsr ShowPicture

          .SkipLines 10

          jsr DecodeText
          jsr ShowText
          .bend
