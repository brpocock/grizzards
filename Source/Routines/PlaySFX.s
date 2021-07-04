;;; Grizzards Source/Routines/PlaySFX.s
;;; Copyright © 2021 Bruce-Robert Pocock
PlaySFX: .block

          lda CurrentSound + 1
          bne PlaySound

          lda NextSound
          bne PlayNewSound

          lda CurrentMusic + 1
          bne PlayMusic
          
LoopMusic:
          lda GameMode
          cmp #ModeMap
          beq MusicInBank

          cmp #ModeAttractTitle
          bne NoMusic

          lda #>SongTheme
          sta CurrentMusic + 1
          lda #<SongTheme
          sta CurrentMusic

          jmp TheEnd

MusicInBank:
          lda # 0
          sta CurrentMusic + 1

NoMusic:

          lda # 0
          sta AUDF1
          sta AUDC1
          sta AUDV1
          sta NoteTimer
          
          jmp TheEnd

PlayNewSound:
          cmp #SoundCount + 1
          bmi PlayNewSoundReally

          lda #SoundDeleted     ; replace incorrect sounds with the toilet flush

PlayNewSoundReally:
          tax                   ; NextSound (index)
          lda SoundIndexL - 1, x
          sta CurrentSound
          lda SoundIndexH - 1, x
          sta CurrentSound + 1
          lda #0
          sta NextSound

          jmp PlayNextSFXNote
PlayMusic:
          dec NoteTimer
          bne TheEnd

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

PlaySound:
          dec SFXNoteTimer
          bne TheEnd

PlayNextSFXNote:
          ldy #0
          lda (CurrentSound), y
          tax
          and #$0f
          sta AUDC0
          txa
          and #$f0
          clc
          ror a
          ror a
          ror a
          ror a
          sta AUDV0
          iny
          lda (CurrentSound), y
          sta AUDF0

          iny

          lda (CurrentSound), y
          sta SFXNoteTimer

          dey
          lda (CurrentSound), y
          bmi EndOfSound

          lda #3
          clc
          adc CurrentSound
          bcc +
          inc CurrentSound + 1
+
          sta CurrentSound

          jmp TheEnd

EndOfSound:

          lda #0
          sta CurrentSound + 1
          sta AUDC0
          sta AUDF0
          sta AUDV0
          sta NoteTimer

TheEnd:
          rts
          .bend
