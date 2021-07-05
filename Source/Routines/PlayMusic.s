;;; Grizzards Source/Routines/PlayMusic.s
;;; Copyright © 2021 Bruce-Robert Pocock

DoMusic:          
          lda CurrentMusic + 1
          bne PlayMusic
          
LoopMusic:
          lda GameMode
          cmp #ModeMap
          beq MusicInBank

          cmp #ModeAttractTitle
          bne NoMusic

          .switch BANK
          .case 7

          lda #>SongTheme
          sta CurrentMusic + 1
          lda #<SongTheme
          sta CurrentMusic

          .case 3

          lda CurrentProvince
          cmp #3
          beq SingProvince3Song

          lda #>SongProvince2
          sta CurrentMusic + 1
          lda #<SongProvince2
          sta CurrentMusic
          
          jmp ReallyPlayMusic

SingProvince3Song:  
          lda #>SongProvince3
          sta CurrentMusic + 1
          lda #<SongProvince3
          sta CurrentMusic

          .case 4

          lda CurrentProvince
          beq SingProvince0Song

          lda #>SongProvince1
          sta CurrentMusic + 1
          lda #<SongProvince1
          sta CurrentMusic
          
          jmp ReallyPlayMusic

SingProvince0Song:
          lda #>SongProvince0
          sta CurrentMusic + 1
          lda #<SongProvince0
          sta CurrentMusic

          .default
          .error "Not expecting to be in bank ", BANK
          .endswitch 

          jmp ReallyPlayMusic

PlayMusic:
          dec NoteTimer
          bne TheEnd

          ;; make the notes slightly more staccatto
          lda # 0
          sta AUDF1
          sta AUDC1
          sta AUDV1

ReallyPlayMusic:
          ldy #0
          lda (CurrentMusic), y
          tax
          and #$0f
          sta AUDC1
          txa
          and #$f0
          clc
          ror a
          ror a
          ror a
          ror a
          sta AUDV1

          iny

          lda (CurrentMusic), y
          sta AUDF1

          iny

          lda (CurrentMusic), y
          sta NoteTimer

          dey
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

MusicInBank:
          lda # 0
          sta CurrentMusic + 1
          sta CurrentMusic

NoMusic:

          lda # 0
          sta AUDF1
          sta AUDC1
          sta AUDV1
          sta NoteTimer          

TheEnd:
