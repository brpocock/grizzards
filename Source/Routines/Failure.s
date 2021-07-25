;;; Grizzards Source/Routines/Failure.s
;;; Copyright © 2021 Bruce-Robert Pocock
Failure:	.block
          .WaitScreenTop

          lda # 0
          sta GRP0
          sta GRP1
          sta ENAM0
          sta ENAM1
          sta ENABL
          sta AUDV0
          sta AUDV1

          lda GameMode
          cmp #ModeNoAtariVox
          bne WhiteSadFace
          
          lda #COLRED
          jmp CommonSadness

WhiteSadFace:
          lda #COLGRAY | $f

CommonSadness:      
          sta COLUPF
          lda #CTRLPFREF
          sta CTRLPF

          ldy # 8
DrawSadFace:
          lda SadFace-1,y
          sta PF2
          .SkipLines 10
          dey
          bne DrawSadFace

          sty PF2               ; always 0

          tya
          .SkipLines 20

          .if TV != SECAM
          lda #COLGRAY|$4
          sta COLUBK
          lda #COLGRAY|$a
          sta COLUPF
          .fi
          
          ldx #0
DumpBits:
          lda $80, x
          sta PF1
          inx
          lda $80, x
          sta PF2
          sta WSYNC
          .if TV != NTSC
          sta WSYNC
          .fi
          inx
          cpx #$80
          bne DumpBits

          lda #0
          sta PF1
          sta PF2
          sta COLUBK

          .WaitScreenBottom

          lda NewSWCHB
          beq SkipSwitches
          .BitBit SWCHBReset
          beq Reset
SkipSwitches:	

          jmp Failure

Reset:
          jmp GoColdStart
          

SadFace:
          .byte %11111100
          .byte %00000010
          .byte %00001001
          .byte %11110001
          .byte %00000001
          .byte %00110001
          .byte %00000010
          .byte %11111100
          
          .bend
