;;; Grizzards Source/Routines/DrawStarter.s
;;; Copyright © 2022 Bruce-Robert Pocock

DrawStarter:        .block

          ;; 0 = Dirtex, 1 = Aquax, 2 = Airex
          
          .if !DEMO             ; all of the stuff that isn't Aquax-only
          ;; demo only gets the Aquax screen

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

          .fi                   ; if !DEMO block ends
          ;; start of Demo/Aquax only version
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
          jsr ShowPicture

          ldy # 0
          sty PF2

AquaxBottom:
          jsr Random
          rol a
          and #$70
          bne AquaxWaveNoChange
          ;; A = 0
          bcc AquaxWaveZero

          rol a                 ; A = 1

AquaxWaveZero:
          sta PlayerXFraction
AquaxWaveNoChange:
          lda PlayerXFraction
          beq AquaxWaveNegative

          inc PlayerYFraction
          gne SetWaveLevel

AquaxWaveNegative:
          dec PlayerYFraction
SetWaveLevel:
          lda PlayerYFraction
          lsr a
          lsr a
          lsr a
          lsr a
          and #$1f
          tax
          inx
WaveWait:
          stx WSYNC
          dex
          bne WaveWait

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

          lda # 43              ; We don't actually want legit random here.
          sta Rand
          sta Rand + 1

          ldy # 4
Foliage:
          jsr Random            ; not really random, seeded just above

          sta PF0
          .if NTSC == TV
            jsr Random          ; XXX out of space for non-NTSC
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
          jsr ShowPicture

          jmp AirexBottom

DrawAirex1:
          .SetUpFortyEight Grizzard21
          jsr ShowPicture

          ldy # 0
          sty PF2

AirexBottom:
          .mva PF2, #$ff
          .SkipLines 3
          .ldacolu COLBROWN, $4
          sta COLUPF
          .SkipLines 10
 
          stx WSYNC
          .SetSkyColor
          sta COLUBK

          ldy # 0
          sty VDELP0
          sty VDELP1

          lda # NUSIZQuad
          sta NUSIZ0
          sta NUSIZ1
          .ldacolu COLBROWN, $4
          sta COLUP0
          sta COLUP1

          .page
          stx WSYNC
          .SleepX $18
          sta RESP0
          nop
          nop
          nop
          sta RESP1
          .endp

          lda #$ff
          sta GRP0
          sta GRP1

          ldy # 0
          sty PF0
          sty PF1
          sty PF2

          rts
          .fi

          .bend
