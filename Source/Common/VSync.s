;;; Grizzards Source/Common/VSync.s
;;; Copyright © 2021 Bruce-Robert Pocock
;;; Vertical sync, blanking, and overscan routines.
;;;
;;; Currently, these are replicated in each bank as needed.
;;; They could instead be bank-switched service routines in future,
;;; but so far it has not been a problem.
;;; (The cost in wired memory is a factor.)
          
VSync: .block
          lda #ENABLED
          sta VBLANK

          sta VSYNC

          ldy #0
          sty COLUBK
          sty COLUPF
          sty COLUP0
          sty COLUP1
          sty PF0
          sty PF1
          sty PF2
          sta WSYNC                    ; VSYNC line 1/3

          inc ClockFrame
          lda ClockFrame
          cmp #FramesPerSecond
          bne NoTime

          lda #0
          sta ClockFrame
          inc ClockSeconds
          lda ClockSeconds
          cmp #60
          bne NoTime

          lda #0
          sta ClockSeconds
          inc ClockMinutes
          lda ClockMinutes
          cmp #240
          bne NoTime
          lda #0
          sta ClockMinutes
          clc
          inc ClockFourHours
          bcc NoTime
          lda #$ff
          sta ClockFourHours

NoTime: 
          
          sta WSYNC                    ; VSYNC line 2/3
          sta WSYNC                    ; VSYNC line 3/3

          sty VSYNC                    ; .y = 0
          rts
          .bend

VBlank: .block
          ldx #VBlankLines
FillVBlank:
          sta WSYNC
          dex
          bne FillVBlank
          
          stx VBLANK                    ; .x = 0
          rts
          .bend

Overscan: .block
          lda # ( 76 * OverscanLines ) / 64 - 1
          sta TIM64T

          ldx #SFXBank
          jsr FarCall

          .switch BANK
          .case 4

          lda CurrentMusic + 1
          bne FillOverscan

          lda CurrentProvince
          beq SingProvince0Song

          lda #>SongProvince1
          sta CurrentMusic + 1
          lda #<SongProvince1
          sta CurrentMusic

          jmp FillOverscan

SingProvince0Song:
          lda #>SongProvince0
          sta CurrentMusic + 1
          lda #<SongProvince0
          sta CurrentMusic

          .case 3

          lda CurrentMusic + 1
          bne FillOverscan

          lda CurrentProvince
          cmp #3
          beq SingProvince3Song

          lda #>SongProvince2
          sta CurrentMusic + 1
          lda #<SongProvince2
          sta CurrentMusic

          jmp FillOverscan

SingProvince3Song:  
          lda #>SongProvince3
          sta CurrentMusic + 1
          lda #<SongProvince3
          sta CurrentMusic

          .default

          lda # 0
          sta AUDF1
          sta AUDC1
          sta AUDV1
          sta NoteTimer

          .endswitch
          
FillOverscan:
          sta WSYNC
          lda TIMINT
          bpl FillOverscan
          sta WSYNC
          rts
          .bend
