PlaySFX: .block

          lda CurrentSound + 1
          bne PlaySound

          lda NextSound
          bne PlayNewSound

          lda CurrentMusic + 1
          bne PlayMusic

          sta AUDF0             ; .a = 0
          sta AUDC0
          sta AUDV0
          sta AUDF1
          sta AUDC1
          sta AUDV1
          sta NoteTimer

GoBack:
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

          jmp PlayNextNote
PlayMusic:
          dec NoteTimer
          bne TheEnd

          ldy #0
          lda (CurrentMusic), y
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
          sta NoteTimer

          beq LoopMusic

          lda #5
          clc
          adc CurrentMusic
          bcc +
          inc CurrentMusic + 1
+
          sta CurrentMusic
          jmp TheEnd

LoopMusic:
          lda CurrentSongStart
          sta CurrentMusic
          lda CurrentSongStart + 1
          sta CurrentMusic
          jmp TheEnd

PlaySound:
          dec NoteTimer
          bne TheEnd

PlayNextNote:
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
          sta NoteTimer

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
          sta NoteTimer

TheEnd:

          .bend
