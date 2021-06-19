AppendDecimalAndPrint:        
          sta Temp
          jsr CopyPointerText

          ;; based on  https://stackoverflow.com/questions/65432063/6502-assembly-binary-to-bcd-is-that-possible-on-x86

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

          jmp DecodeAndShowText
