;;; Grizzards Source/Routines/GrizzardDepot.s
;;; Copyright © 2021 Bruce-Robert Pocock
GrizzardDepot:    .block

          .WaitScreenTop
          .KillMusic

          .FarJSR SaveKeyBank, ServiceSaveToSlot

          ldx MaxHP
          stx CurrentHP

          .WaitScreenBottom
;;; 
Loop:     
          jsr VSync
          jsr VBlank

          .ldacolu COLTEAL, $f
          sta COLUBK
          .ldacolu COLINDIGO, 0
          sta COLUP0
          sta COLUP1

          ldx #4
-
          sta WSYNC
          dex
          bne -

          jsr Prepare48pxMobBlob
          .SetPointer DepotText
          jsr ShowPointerText

          jsr ShowGrizzardName
          jsr DrawGrizzard

          jsr Prepare48pxMobBlob
          .ldacolu COLINDIGO, 0
          sta COLUP0
          sta COLUP1

          .SetPointer PlayTimeText
          jsr ShowPointerText
;;; 
          lda # 40              ; blank space
          sta StringBuffer + 0
          sta StringBuffer + 5

;;; The clock hours-to-decimal routine is based upon http://6502.org/source/integers/hex2dec.htm

;;; Note that our max hours = 255 × 4 where we display XXXX

          lda # 0
          sta Temp
          lda ClockFourHours
          cmp #$ff
          bne +

          lda # 22              ; M
          sta StringBuffer + 1
          lda # 10              ; A
          sta StringBuffer + 2
          lda # 23              ; N
          sta StringBuffer + 3
          lda # 34              ; Y
          sta StringBuffer + 4
          jmp HTDdone

+
          clc
          asl a
          rol Temp
          clc
          asl a
          rol Temp
          sta DeltaX

          lda ClockMinutes
          ;; ÷ 60 is too slow so we cheat, since the output is 0..3
          cmp # 180
          blt +
          inc DeltaX
+
          cmp # 120
          blt +
          inc DeltaX
+
          cmp # 60
          blt HTD
          inc DeltaX
;;; 
HTD:
          sed             ; Output gets added up in decimal.
          ldy #0
          sty StringBuffer+1
          sty StringBuffer+2
          sty StringBuffer+3
          sty StringBuffer+4

          ldx # 4 * 15
HTDloop:
          asl DeltaX      ; (0 to 15 is 16 bit positions.)
          rol Temp    ; If the next highest bit was 0,
          bcc HTDnext       ; then skip to the next bit after that.
          lda StringBuffer+4     ; But if the bit was 1,
          clc             ; get ready to
          adc DecimalTable+3, x   ; add the bit value in the table to the
          sta StringBuffer+4     ; output sum in decimal--  first low byte,
          and #$f0               ; (with a carry on 10 not 100)
          beq +
          sec
          lda StringBuffer+4
          and #$0f
          sta StringBuffer+4
+          
          lda StringBuffer+3    ; then middle byte, etc
          adc DecimalTable+2, x
          sta StringBuffer+3
          and #$f0
          beq +
          sec
          lda StringBuffer+3
          and #$0f
          sta StringBuffer+3
+          
          lda StringBuffer+2
          adc DecimalTable+1, x
          sta StringBuffer+2
          and #$f0
          beq +
          sec
          lda StringBuffer+2
          and #$0f
          sta StringBuffer+2
+
          lda StringBuffer+1
          adc DecimalTable, x
          sta StringBuffer+1
          
HTDnext:
          dex
          dex             ; By taking X in steps of 4, we don't have to
          dex             ; multiply by 4 to get the right bytes from the
          dex             ; table.
          bpl HTDloop

HTDdone:  
          cld
          stx DeltaX            ; 0

          jsr DecodeText
          jsr ShowText
;;; 
;;; End of the hours decode + display routine

          lda #>PlayHoursText
          sta Pointer + 1
          lda #<PlayHoursText
          sta Pointer
          jsr ShowPointerText

          .if TV == NTSC
          .SkipLines KernelLines - 135
          .else
          .SkipLines KernelLines - 144
          .fi

          lda SWCHA
          ;; TODO handle stick

          lda NewSWCHB
          beq SwitchesDone
          .BitBit SWCHBReset
          bne NoReset
          jmp GoQuit
NoReset:
          .BitBit SWCHBSelect
          bne SwitchesDone
          lda #ModeGrizzardStats
          sta GameMode
          lda #ModeGrizzardDepot
          sta DeltaY            ; where to return after stats display
          bne TriggerDone       ; always taken

SwitchesDone:
          lda INPT4
          .BitBit PRESSED
          bne TriggerDone
          lda #ModeMap
          sta GameMode
          jsr Overscan
          rts

TriggerDone:
;;; 
          jsr Overscan
          lda GameMode
          cmp #ModeGrizzardDepot
          bne +
          jmp Loop
+
          cmp #ModeGrizzardStats
          jmp GrizzardStatsScreen

;;; 
ShowPointerText:
          jsr CopyPointerText
          jmp DecodeAndShowText

;;; 
                ; The table below has high byte first just to
                ; make it easier to see the number progression.
DecimalTable:
          .byte    0,0,0,1,  0,0,0,2,  0,0,0,4,  0,0,0,8
          .byte    0,0,1,6,  0,0,3,2,  0,0,6,4,  0,1,2,8
          .byte    0,2,5,6,  0,5,1,2

          .bend
