;;; Grizzards Source/Routines/PlayMusic.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

DoMusic:
          lda CurrentMusic + 1
          bne PlayMusic

          ;; a phantom read of $ffe1 was happening on branch
          .if $fee1 == *
            nop
            nop
            nop
          .fi
LoopMusic:
          ;; Don't loop if there's currently a sound effect playing
          ;; e.g. Atari Today jingle, victory music from combat, &c.
          ;; Both can play at the same time, but don't *start*
          ;; playing until the last sound effect has ended
          lda CurrentSound + 1
          bne TheEnd

          .switch BANK
          .case 7

            lda GameMode
            .if PUBLISHER
              cmp #ModePublisherPresents
            .else
              cmp #ModeBRPPreamble
            .fi
            beq TheEnd

            and #$f0
            cmp #ModeAttract
            bne TheEnd

            .mva CurrentMusic + 1, #>SongTheme
            .mva CurrentMusic, #<SongTheme

          .case 3,4,5

            .mva CurrentMusic + 1, #>SongProvince
            .mva CurrentMusic, #<SongProvince

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

          ldy # 0

          .if BANK != 7
            bit SystemFlags
            bpl MusicIsAllowed ; Pause flag = $80
            sty AUDV1
            iny                 ; Y = 1
            sty NoteTimer
            gne TheEnd
          .fi

MusicIsAllowed:
          dec NoteTimer
          bne TheEnd

          ;; make the notes slightly more staccatto
          sty AUDF1
          sty AUDC1
          sty AUDV1

ReallyPlayMusic:
          ldy #0
          lax (CurrentMusic), y
          and #$0f
          sta AUDC1

          txa
          and #$f0
          .rept 4
          lsr a
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

          ;; jmp TheEnd

TheEnd:
