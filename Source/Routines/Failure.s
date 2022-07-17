;;; Grizzards Source/Routines/Failure.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
Failure:	.block
          tsx
          cpx #$fb
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
          ldy # 0
          sty Score
          sty Score + 1
          sty Score + 2

DoneWithStack:
Loop:
          .WaitScreenTop

          ldy # 0
          sty GRP0
          sty GRP1
          sty ENAM0
          sty ENAM1
          sty ENABL
          sty AUDV0
          sty AUDV1

          .if !ATARIAGESAVE
            .ldacolu COLGRAY, $e
            ldx GameMode
            cpx #ModeNoAtariVox
            bne CommonSadness

            .ldacolu COLRED, $6
          .fi

CommonSadness:      
          sta COLUPF
          .ldacolu COLRED, $a
          sta COLUP0
          sta COLUP1
          .mva CTRLPF, #CTRLPFREF

          ldy # 8
DrawSadFace:
          lda SadFace-1, y
          sta PF2
          .SkipLines 10
          dey
          bne DrawSadFace

          sty PF2               ; Y = 0

          .SkipLines 20

          jsr Prepare48pxMobBlob

          .if !ATARIAGESAVE
            lda GameMode
            cmp #ModeNoAtariVox
            bne Crashed

NoVoxMessage:
            .SetPointer MemoryText
            jsr ShowPointerText

            .SetPointer DeviceText
            jsr ShowPointerText

            .SetPointer NeededText
            jsr ShowPointerText

            jmp ShowReturnAddress
          .fi

Crashed:
          .SetPointer ErrorText
          jsr ShowPointerText

ShowReturnAddress:
          jsr DecodeScore
          .FarJSR TextBank, ServiceDecodeAndShowText

          .SkipLines 4

          lda #0
          sta PF1
          sta PF2
          sta COLUBK

          .WaitScreenBottom

          .if !ATARIAGESAVE     ; XXX maybe out of room
            lda NewButtons
            beq DoneButtons

            and #ButtonIII
            beq Reset
DoneButtons:
          .fi

          lda NewSWCHB
          beq DoneSwitches

          and #SWCHBReset
          beq Reset

DoneSwitches:	
          jmp Loop

Reset:
          jmp GoWarmStart

;;; 
          .if !ATARIAGESAVE
MemoryText:
            .MiniText "MEMORY"
DeviceText:
            .MiniText "DEVICE"
NeededText:
            .MiniText "NEEDED"
          .fi
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
