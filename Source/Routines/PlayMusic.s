;;; Grizzards Source/Routines/PlayMusic.s
;;; Copyright © 2021 Bruce-Robert Pocock

DoMusic:
          lda CurrentMusic + 1
          bne PlayMusic

LoopMusic:
          .switch BANK
          .case 7

          lda GameMode
          and #$f0
          cmp #ModeAttract
          bne TheEnd

          lda #>SongTheme
          sta CurrentMusic + 1
          lda #<SongTheme
          sta CurrentMusic

          .case 3

          lda #>SongProvince1
          sta CurrentMusic + 1
          lda #<SongProvince1
          sta CurrentMusic

          .case 4

          lda #>SongProvince0
          sta CurrentMusic + 1
          lda #<SongProvince0
          sta CurrentMusic

          .default
          .error "Not expecting to be in bank ", BANK
          .endswitch

          jmp ReallyPlayMusic

PlayMusic:
          .if BANK == 7
          lda GameMode
          and #$f0
          cmp #ModeAttract
          bne TheEnd
          .fi

          dec NoteTimer
          bne TheEnd

          ;; make the notes slightly more staccatto
          lda # 0
          sta AUDF1
          sta AUDC1
          sta AUDV1

ReallyPlayMusic:
          ldy #0
          lax (CurrentMusic), y
          and #$0f
          sta AUDC1

          txa
          and #$f0
          clc
          .rept 4
          ror a
          .next
          sta AUDV1

          iny                   ; 1
          lda (CurrentMusic), y
          and #$7f
          sta AUDF1

          iny                   ; 2
          lda (CurrentMusic), y
          sta NoteTimer

          dey                   ; 1
          lda (CurrentMusic), y
          bmi LoopMusic

          lda # 3
          clc
          adc CurrentMusic
          bcc +
          inc CurrentMusic + 1
+
          sta CurrentMusic

          jmp TheEnd

TheEnd:
