Failure:	.block

          jsr VSync

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

          jsr VBlank

          ldx # 8
DrawSadFace:
          lda SadFace-1,x
          sta PF2
          ldy #10
Skip10:   
          sta WSYNC
          dey
          bne Skip10
          dex
          bne DrawSadFace

          stx PF2               ; .x = 0

          txa
          ldx #20
SadPad:
          sta WSYNC
          dex
          bne SadPad

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
          inx
          cpx #$80
          bne DumpBits

          lda #0
          sta PF1
          sta PF2
          sta COLUBK

          ldx # KernelLines + OverscanLines - 64 - 103
FillScreen:
          sta WSYNC
          dex
          bne FillScreen

          lda SWCHB
          cmp DebounceSWCHB
          beq SkipSwitches
          sta DebounceSWCHB
          and #SWCHBReset
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
          
