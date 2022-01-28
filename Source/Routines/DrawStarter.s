;;; Grizzards Source/Routines/DrawStarter.s
;;; Copyright © 2022 Bruce-Robert Pocock

DrawStarter:        .block

          ;; 0 = Dirtex, 1 = Aquax, 2 = Airex
          
          .if !DEMO
          lda CurrentGrizzard
          beq DirtexTop
          cmp # 1
          beq AquaxTop
          gne AirexTop

DirtexTop:
          .SkipLines 20
          .ldacolu COLORANGE, $a
          sta COLUBK
          .SkipLines 22

          .ldacolu COLGREEN, $e
          sta COLUP0
          sta COLUP1

          lda ClockFrame
          .BitBit $20
          beq DrawDirtex1

          .SetUpFortyEight Grizzard00
          ldy #Grizzard00.Height
          sty LineCounter
          jsr ShowPicture

          rts

DrawDirtex1:
          .SetUpFortyEight Grizzard01
          ldy #Grizzard01.Height
          sty LineCounter
          jsr ShowPicture

          ldy # 0
          sty PF2

          rts

          .fi                   ; start of Demo/Aquax only version

AquaxTop: 
          .SkipLines 30
          .ldacolu COLSPRINGGREEN, $4
          sta COLUBK

          .SkipLines 12

          .ldacolu COLBROWN, $6

          sta COLUP0
          sta COLUP1

          lda ClockFrame
          .BitBit $20
          beq DrawAquax1

          .SetUpFortyEight Grizzard10
          ldy #Grizzard10.Height
          sty LineCounter
          jsr ShowPicture

          jmp AquaxBottom

DrawAquax1:
          .SetUpFortyEight Grizzard11
          ldy #Grizzard11.Height
          sty LineCounter
          jsr ShowPicture

          ldy # 0
          sty PF2

AquaxBottom:
          jsr Random
          and # 7
          bne +

          jsr Random
          and # 1
          sta PlayerXFraction
+
          lda PlayerXFraction
          beq +
          inc PlayerYFraction
          jmp SetWaveLevel
+
          dec PlayerYFraction
SetWaveLevel:
          lda PlayerYFraction
          lsr a
          clc
          lsr a
          clc
          lsr a
          lsr a
          tax
          and #$1f
          inx
-
          stx WSYNC
          dex
          bne -

          .ldacolu COLBLUE, $e
          sta COLUBK
          stx WSYNC
          .ldacolu COLGRAY, $e
          sta COLUBK
          stx WSYNC
          .ldacolu COLBLUE, $e
          sta COLUBK
          stx WSYNC
          .ldacolu COLBLUE, $8
          sta COLUBK

          rts

          .if !DEMO

AirexTop: 

          .SkipLines 20
          .ldacolu COLGREEN, $4
          sta COLUPF

          lda # 43
          sta Rand
          sta Rand + 1

          ldy # 4
Foliage:
          jsr Random
          sta PF0
          .if NTSC == TV
          jsr Random
          .fi
          sta PF1
          jsr Random
          sta PF2
          .SkipLines 5
          dey
          bne Foliage

          lda # $ff
          sta PF0
          sta PF1
          sta PF2

          .ldacolu COLTEAL, $e

          sta COLUP0
          sta COLUP1

          lda ClockFrame
          .BitBit $20
          beq DrawAirex1

          .SetUpFortyEight Grizzard20
          ldy #Grizzard20.Height
          sty LineCounter
          jsr ShowPicture

          jmp AirexBottom

DrawAirex1:
          .SetUpFortyEight Grizzard21
          ldy #Grizzard21.Height
          sty LineCounter
          jsr ShowPicture

          ldy # 0
          sty PF2

AirexBottom:
          lda #$ff
          sta PF2
          .SkipLines 3
          .ldacolu COLBROWN, $4
          sta COLUPF
          .SkipLines 10
 
          stx WSYNC
          .if TV == SECAM
            lda #COLBLUE
          .else
            .ldacolu COLTURQUOISE, $e
          .fi
          sta COLUBK

          lda #$ff
          sta GRP0
          sta GRP1

          lda # NUSIZQuad
          sta NUSIZ0
          sta NUSIZ1
          .ldacolu COLBROWN, $4
          sta COLUP0
          sta COLUP1

          stx WSYNC
          .SleepX $18
          sta RESP0
          nop
          nop
          nop
          nop
          sta RESP1

          lda # 0
          sta PF0
          sta PF1
          sta PF2

          rts
          .fi

          .bend
