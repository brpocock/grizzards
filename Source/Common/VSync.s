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

          .if VBlank != *
          jmp VBlank
          .fi
          
          .bend


