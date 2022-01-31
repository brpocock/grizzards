;;; Grizzards Source/Routines/Failure.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
Failure:	.block
          tsx
          cpx #$fd
          bge NoStack

          pla
          sta Score + 2
          pla                   ; discard junk
          pla
          sta Score
          pla
          sta Score + 1

          jmp DoneWithStack

NoStack:
          lda # 0
          sta Score
          sta Score + 1
          sta Score + 2

DoneWithStack:
Loop:
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

          .ldacolu COLRED, $6
          gne CommonSadness

WhiteSadFace:
          lda #COLGRAY | $f

CommonSadness:      
          sta COLUPF
          .ldacolu COLRED, $a
          sta COLUP0
          sta COLUP1
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

          jsr Prepare48pxMobBlob

          lda GameMode
          cmp #ModeNoAtariVox
          bne Crashed
NoVoxMessage:
          .SetPointer MemoryText
          jsr DrawPointerText
          .SetPointer DeviceText
          jsr DrawPointerText
          .SetPointer NeededText
          jsr DrawPointerText
          jmp ShowReturnAddress

Crashed:
          .SetPointer ErrorText
          jsr DrawPointerText
          
ShowReturnAddress:
          jsr DecodeScore
          .FarJSR TextBank, ServiceDecodeAndShowText

          .SkipLines 4

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

          jmp Loop

Reset:
          jmp GoColdStart

;;; 

DrawPointerText:
          jsr CopyPointerText
          .FarJMP TextBank, ServiceDecodeAndShowText

;;; 

MemoryText:
          .MiniText "MEMORY"
DeviceText:
          .MiniText "DEVICE"
NeededText:
          .MiniText "NEEDED"
ErrorText:
          .MiniText "ERROR "
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
