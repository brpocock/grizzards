;;; Grizzards Source/Routines/AppendDecimalAndPrint.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
AppendDecimalAndPrint:        .block
          sta Temp
FromTemp:
          jsr CopyPointerText

          ;; Doing +100/200 we want to adjust to make room
          ;; in the case of "-##" we want "-###" to appear
          lda Temp
          cmp # 200
          blt Done200
          lda StringBuffer + 3
          cmp # 39              ; "-"
          bne +
          sta StringBuffer + 2
+
          lda # 2
          sta StringBuffer + 3
Done200
          cmp # 100
          blt Done100
          lda StringBuffer + 3
          cmp # 39              ; "-"
          bne +
          sta StringBuffer + 2
          lda # 1
          sta StringBuffer + 3
Done100

          ;; based on  https://stackoverflow.com/questions/65432063/6502-assembly-binary-to-bcd-is-that-possible-on-x86
          ;; Not to self, consider also https://atariage.com/forums/topic/330847-binary-to-bcd/?do=findComment&comment=4999910 ?

BINBCD8:
          sed
          lda Temp

          ldx # 8
CNVBIT:                         
          asl Temp
          lda StringBuffer + 5
          adc StringBuffer + 5
          sta StringBuffer + 5
          dex
          bne CNVBIT

          cld

          lda StringBuffer + 5
          and #$f0
          lsr a
          lsr a
          lsr a
          lsr a
          sta StringBuffer + 4
          lda StringBuffer + 5
          and #$0f
          sta StringBuffer + 5

          .if BANK == TextBank
            jmp DecodeAndShowText ; tail call
          .else
            .FarJMP TextBank, ServiceDecodeAndShowText ; also tail call
          .fi

          .bend
