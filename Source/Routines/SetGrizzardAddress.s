;;; Grizzards Source/Routines/SetGrizzardAddress.s
;;; Copyright © 2021 Bruce-Robert Pocock
SetGrizzardAddress: .block
          ;; Call with Grizzard ID in .A

          tax    ; stash it for a second
          
          ;; Grizzard data is weirder storage layout.
          ;; We save 12 grizzards at 5 bytes each in each of
          ;; the 3 blocks following the master block. That
          ;; leaves 6 in the final block and half of it is blank.

          ;; The four 64 byte blocks together make one page,
          ;; so the high byte of the address is the same for all.
          lda #>SaveGameSlotPrefix
          clc
          adc SaveGameSlot
          sta Pointer + 1

          txa                   ; get back Grizzard ID

          ;; First, figure out which block the current Grizzard
          ;; can be found in.
          cmp # 12
          bmi InBlock1
          cmp # 24
          bmi InBlock2

          ;; must be in Block 3 if it's 24-29.
          sec
          sbc # 24
          tax
          lda # 3
          jmp ReadyToSendAddress

InBlock1:
          tax
          lda # 1
          jmp ReadyToSendAddress

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
          asl a                 ; × $40 (64)
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
          jsr i2cStartWrite
          lda Pointer + 1
          jsr i2cTxByte
          lda Pointer
          jmp i2cTxByte         ; tail call

          .bend
