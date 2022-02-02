;;; Grizzards Source/Routines/DrawBoss.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          
DrawBoss: .block

          jsr GetMonsterColors

GetMonsterPointer:
          lda #>BossArt - 1
          sta pp4h

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

          mvx pp5h, pp4h

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
          .Add16 pp4l, #<BossArt.Height * 2
          lda pp4h
          clc
          adc #>BossArt.Height * 2
          sta pp4h

          stx WSYNC

          .Add16 pp5l, #<BossArt.Height * 2
          lda pp5h
          clc
          adc #>BossArt.Height * 2
          sta pp5h

CommonFrame:
          ldy #0
          sty VDELP0
          sty VDELP1
          lda #NUSIZDouble
          sta NUSIZ0
          sta NUSIZ1

DecideFlipFrame:
          lda # 1
          and ClockSeconds
          bne PrepareToDrawMonsterFlipped
          
PrepareToDrawMonster:
          sty REFP0
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
          lda #REFLECTED
          sta REFP0
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

          sty GRP0
          sty GRP1

          .SkipLines 5
 
          rts

          .bend
