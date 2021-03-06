;;; Grizzards Source/Routines/PlaySFX.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

PlaySFX: .block

          lda CurrentSound + 1
          bne PlaySound

          lda NextSound
          beq EndOfSound

PlayNewSound:
          cmp #SoundTable.Count + 1
          blt PlayNewSoundReally

          lda #SoundDeleted     ; replace incorrect sounds with the toilet flush
PlayNewSoundReally:
          tax                   ; NextSound (index)
          lda SoundTable.IndexL - 1, x
          sta CurrentSound
          lda SoundTable.IndexH - 1, x
          sta CurrentSound + 1
          ldy # 0
          sty NextSound
          geq PlayNextSFXNote

PlaySound:
          dec SFXNoteTimer
          bne DoMusic

PlayNextSFXNote:
          ldy # 0
          lda (CurrentSound), y
          tax
          and #$0f
          sta AUDC0
          txa
          and #$f0
          lsr a
          lsr a
          lsr a
          lsr a
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

          lda # 0
          sta CurrentSound + 1
          sta AUDC0
          sta AUDF0
          sta AUDV0
          sta SFXNoteTimer

TheEnd:
          ;; fall through to DoMusic

          .bend

;;; Audited 2022-07-16 BRPocock
