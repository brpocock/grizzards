;;; Grizzards Source/Routines/SetGrizzardAddress.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
SetGrizzardAddress: .block
          ;; Call with Grizzard ID in .A

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
          .if ATARIAGESAVE
            lda SaveGameSlot
          .fi
          jsr i2cStartWrite
          .if !ATARIAGESAVE
            lda #>SaveGameSlotPrefix
            clc
            adc SaveGameSlot
            jsr i2cTxByte
          .fi
          lda Pointer
          jmp i2cTxByte         ; tail call

          .bend
