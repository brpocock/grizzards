;;; Grizzards Source/Routines/SetGrizzardAddress.s
;;; Copyright © 2021 Bruce-Robert Pocock
SetGrizzardAddress: .block
          ;; Call with Grizzard ID in .A

          tax    ; stash it for a second
          
          ;; Grizzard data is weirder storage layout.
          ;; We save 12 grizzards at 5 bytes each in each of
          ;; the 3 blocks following the master block. That
          ;; leaves 6 in the final block and half of it is blank.

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
          asl a
          asl a
          asl a
          asl a
          asl a
          asl a                 ; × $40 (64)
          sta Pointer           ; start of the block we want
          txa                   ; index within the block
          sta Temp
          asl a
          asl a                 ; × 4
          clc
          adc Temp              ; × 5

          adc Pointer
          sta Pointer

          ;; Finally we know our offset, let's send  it.
          jsr i2cStartWrite
          lda Pointer + 1
          jsr i2cTxByte
          lda Pointer
          jsr i2cTxByte


          .bend
