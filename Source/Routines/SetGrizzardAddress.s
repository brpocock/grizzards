;;; Grizzards Source/Routines/SetGrizzardAddress.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
SetGrizzardAddress: .block
          ;; Call with Grizzard ID in .A

          .if ATARIAGESAVE

          ;; Each Grizzard's  data must be aligned to 16-byte boundaries
          ;; so we must divide into 3 sets The easiest way to do this is
          ;; to group  by 15 byte  (3×5) groupings, which we'll  use the
          ;; high bits to select.

          tax
          lda GrizAddrTable, x
          .StartI2C
          lda Pointer
          jmp i2cTxByte         ; tail call

GrizAddrTable:
          .byte $40 ; Grizzard #1
          .byte $45 ; Grizzard #2
          .byte $4A ; Grizzard #3
          .byte $50 ; Grizzard #4
          .byte $55 ; Grizzard #5
          .byte $5A ; Grizzard #6
          .byte $60 ; Grizzard #7
          .byte $65 ; Grizzard #8
          .byte $6A ; Grizzard #9
          .byte $70 ; Grizzard #10
          .byte $75 ; Grizzard #11
          .byte $7A ; Grizzard #12
          .byte $80 ; Grizzard #13
          .byte $85 ; Grizzard #14
          .byte $8A ; Grizzard #15
          .byte $90 ; Grizzard #16
          .byte $95 ; Grizzard #17
          .byte $9A ; Grizzard #18
          .byte $A0 ; Grizzard #19
          .byte $A5 ; Grizzard #20
          .byte $AA ; Grizzard #21
          .byte $B0 ; Grizzard #22
          .byte $B5 ; Grizzard #23
          .byte $BA ; Grizzard #24
          .byte $C0 ; Grizzard #25
          .byte $C5 ; Grizzard #26
          .byte $CA ; Grizzard #27
          .byte $D0 ; Grizzard #28
          .byte $D5 ; Grizzard #29
          .byte $DA ; Grizzard #30

          .else

          ;; Grizzard data is weirder storage layout.
          ;; We save 12 grizzards at 5 bytes each in each of
          ;; the 3 blocks following the master block. That
          ;; leaves 6 in the final block and half of it is blank.

          ;; The four 64 byte blocks together make one page,
          ;; so the high byte of the address is the same for all.

          ;; First, figure out which block the desired Grizzard
          ;; can be found in.
          cmp # 12
          blt InBlock1

          cmp # 24
          blt InBlock2

          ;; must be in Block 3 if it's 24-29.
          sec
          sbc # 24
          tax
          lda # 3
          gne ReadyToSendAddress

InBlock1:
          tax
          lda # 1
          gne ReadyToSendAddress

InBlock2:
          sec
          sbc # 12
          tax
          lda # 2
          ;; fall through

ReadyToSendAddress:
          ;; .A = block (1, 2, 3)
          ;; .X = index (to be × 5) within that block
          .rept 6
            asl a               ; × $40 (64)
          .next
          sta Pointer           ; start of the block we want
          txa                   ; index within the block
          sta Temp
          asl a
          asl a                 ; × 4
          clc
          adc Temp              ; × 5 (never carries)
          adc Pointer           ; never carries
          sta Pointer

          ;; Finally we know our offset, let's send  it.
          .StartI2C
          lda Pointer
          jmp i2cTxByte         ; tail call

          .fi

          .bend
