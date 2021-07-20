;;; Grizzards Source/Routines/PlaySFX.s
;;; Copyright © 2021 Bruce-Robert Pocock
PlaySFX: .block

          lda CurrentSound + 1
          bne PlaySound

          lda NextSound
          beq EndOfSound

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

PlaySound:
          dec SFXNoteTimer
          bne EndOfSound

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

          jmp DoMusic

EndOfSound:

          lda #0
          sta CurrentSound + 1
          sta AUDC0
          sta AUDF0
          sta AUDV0
          sta SFXNoteTimer

          ;; fall through to DoMusic

          .bend
