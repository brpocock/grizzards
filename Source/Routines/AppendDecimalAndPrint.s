AppendDecimalAndPrint:        
          sta Temp
          jsr CopyPointerText

          ;; based on  https://stackoverflow.com/questions/65432063/6502-assembly-binary-to-bcd-is-that-possible-on-x86

BINBCD8:
          sed
          
          ldx #8
CNVBIT:                         
          asl Temp
          lda StringBuffer + 6
          adc StringBuffer + 6
          sta StringBuffer + 6
          dex
          bne CNVBIT
          
          cld

          lda StringBuffer + 6
          and #$f0
          lsr a
          lsr a
          lsr a
          lsr a
          sta StringBuffer + 5
          lda StringBuffer + 6
          and #$0f
          sta StringBuffer + 6

          jmp DecodeAndShowText
