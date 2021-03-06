;;; Grizzards Source/Routines/DrawBoss.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

DrawBoss: .block

          jsr GetMonsterColors

GetMonsterPointer:
          .mva pp4h, #>BossArt - 1

          lda CurrentMonsterArt
Mult16:
          ldx # 4
-
          clc
          asl a
          bcc +
          inc pp4h
+
          dex
          bne -

          clc
          adc #<BossArt - 1
          bcc +
          inc pp4h
+
          sta pp4l

          .mvx pp5h, pp4h

          clc
          adc #<BossArt.Height
          bcc +
          inc pp5h
+
          sta pp5l
          lda pp5h
          clc
          adc #>BossArt.Height
          sta pp5h

          lda #$20
          and ClockFrame
          bne AlternateFrame

          stx WSYNC
          stx WSYNC

          geq CommonFrame

AlternateFrame:
          clc
          lda #<BossArt.Height * 2
          adc pp4l
          sta pp4l
          lda #>BossArt.Height * 2
          adc pp4h
          sta pp4h

          clc
          lda #<BossArt.Height * 2
          adc pp5l
          sta pp5l
          lda #>BossArt.Height * 2
          adc pp5h
          sta pp5h

          stx WSYNC

          lda WhoseTurn
          beq CommonFrame

          lda CurrentMonsterArt
          cmp #$0a
          blt CommonFrame

          stx WSYNC

CommonFrame:
          ldy #0
          sty VDELP0
          sty VDELP1
          .mva NUSIZ0, #NUSIZDouble
          sta NUSIZ1

DecideFlipFrame:
          lda # 1
          and ClockSeconds
          bne PrepareToDrawMonsterFlipped

PrepareToDrawMonster:
          sty REFP0             ; Y = 0
          sty REFP1

SetUpLeftHanded:
          .page
            stx WSYNC
            sta HMCLR
            .SleepX 36
            sta RESP0
            nop
            sta RESP1
          .endp

          jmp DrawMonster

PrepareToDrawMonsterFlipped:
          .mva REFP0, #REFLECTED
          sta REFP1

SetUpRightHanded:
          .page
            stx WSYNC
            sta HMCLR
            .SleepX 36
            sta RESP1
            nop
            sta RESP0
          .endp

DrawMonster:
          ldy # 16
          ldx # 0
DrawMonsterLoop:
          lda PixelPointers, x
          sta COLUP0
          sta COLUP1

          lda (pp4l), y
          sta GRP0
          lda (pp5l), y
          sta GRP1
          stx WSYNC
          stx WSYNC
          .if TV != NTSC
            stx WSYNC
          .fi

          dey

          lda (pp4l), y
          sta GRP0
          lda (pp5l), y
          sta GRP1
          stx WSYNC
          stx WSYNC
          .if TV != NTSC
            stx WSYNC
          .fi

          inx
          dey
          bne DrawMonsterLoop

          sty GRP0              ; Y = 0
          sty GRP1

          .SkipLines 5

          rts

          .bend

;;; Audited 2022-02-16 BRPocock
