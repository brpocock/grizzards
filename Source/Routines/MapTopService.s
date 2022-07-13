;;; Grizzards Source/Routines/MapTopService.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
TopOfScreenService: .block

          ;; MAGIC — these addresses must be  known and must be the same
          ;; in every map bank.
          PlayerSprites = $f000
          MapSprites = (PlayerSprites + $0f)

          jsr VSync
          .TimeLines 32
          .if NTSC != TV
            stx WSYNC
          .fi
          jsr Prepare48pxMobBlob

          .ldacolu COLGRAY, $f
          sta COLUP0
          sta COLUP1
          .ldacolu COLGRAY, 0
          sta COLUBK
;;; 
          bit SystemFlags
          bpl DrawScore

          .enc "minifont"
          .mva StringBuffer + 0, #"P"
          .mva StringBuffer + 1, #"A"
          .mva StringBuffer + 2, #"U"
          .mva StringBuffer + 3, #"S"
          .mva StringBuffer + 4, #"E"
          .mva StringBuffer + 5, #"D"
          gne ScoreDone

DrawScore:
          jsr DecodeScore

ScoreDone:
          .FarJSR TextBank, ServiceDecodeAndShowText
;;; 
AfterScore:
          .mva CTRLPF, #CTRLPFREF | CTRLPFBALLSZ8 ;;; | CTRLPFPFP FIXME

          ldy # 0
          sty VDELP0
          sty VDELP1
          sty NUSIZ0
          sty NUSIZ1
          sty LineCounter

          ldx CurrentMap

          .ldacolu COLGOLD, $8
          ora BumpCooldown

          sta COLUP0

          stx HMCLR

          lda PlayerX
          clc
          adc # 8
          sec
          stx WSYNC
P0HPos:
          sbc # 15
          bcs P0HPos
          sta RESP0

          eor #$07
          .rept 4
            asl a
          .next
          sta HMP0

          lda MapFlags
          and #MapFlagFacing    ; must = REFLECTED
          sta REFP0

          ldy SpriteCount
          beq NoSprites

          stx CXCLR
          lda BitMask, y        ; SpriteCount
          tax
          dex
          cpx DrawnSprites
          bne +
          ;; everybody got drawn, do it again maybe?
          ldx FlickerRoundRobin
          jmp SwitchToP1
+

          iny                   ; SpriteCount + 1
          ldx FlickerRoundRobin
NextFlickerCandidate:
          dey
          beq NoSprites

          inx
          cpx SpriteCount
          blt +
          ldx # 0
+
          stx FlickerRoundRobin

SwitchToP1:
          lda SpriteMotion, x
          cmp # SpriteRandomEncounter
          beq NextFlickerCandidate

          stx SpriteFlicker

          .include "NextSprite.s"

          lda SpriteY, x
          sta P1LineCounter
          jmp P1Ready

NoSprites:
          .mva P1LineCounter, #$7f

P1Ready:
          ;; if they're invisible, it counts as having been drawn
          .mvy DrawnSprites, # 0
-
          lda SpriteMotion, y
          cmp # SpriteRandomEncounter
          bne +
          lda DrawnSprites
          ora BitMask, y
          sta DrawnSprites
+
          iny
          cpy SpriteCount
          blt -

ReadyPlayer0:
          lda PlayerY
          ldy NextMap
          cpy CurrentMap
          beq +
          ;; new screen being loaded: player is off the screen
          lda #$7f
+
          sta P0LineCounter
          lda # 0
          sta PF1
          sta PF2

          .mva pp0h, #>PlayerSprites

          lda DeltaX
          ora DeltaY
          beq +        ; always show frame 0 unless moving
          lda ClockFrame
          and #$08
          bne +
          ldx #SoundFootstep
          stx NextSound
+
          clc
          adc #<PlayerSprites
          bcc +
          inc pp0h
+
          sta pp0l

TheEnd:
          .WaitForTimer
          rts

          .bend

