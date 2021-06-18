	BANK = $02

	.include "StartBank.s"

DoLocal:
          cpy #ServiceDecodeAndShowText
          beq DecodeAndShowText
          cpy #ServiceShowText
          beq ShowText
          cpy #ServiceShowGrizzardName
          beq ShowGrizzardName
          cpy #ServiceShowGrizzardStats
          beq ShowGrizzardStats
          cpy #ServiceDrawGrizzard
          beq DrawGrizzard
          cpy #ServiceShowMove
          beq ShowMove
          brk

DecodeAndShowText:
          jsr DecodeText
          jmp ShowText
          
ShowGrizzardName:
          jsr Prepare48pxMobBlob

          lda # >GrizzardNames
          sta Pointer + 1
          lda # 0 ;;; CurrentGrizzard 
          clc
          asl a                 ; × 2
          sta Temp
          asl a                 ; × 4
          adc Temp             ; × 6
          bcc +
          inc Pointer + 1
+
          sta Pointer

          jsr CopyPointerText
          jmp DecodeAndShowText

ShowGrizzardStats:
          jsr ShowGrizzardName

          lda #> StatsText
          sta Pointer +1
          lda #< StatsText
          sta Pointer
          lda CurrentAttack
          jsr AppendDecimalAndPrint

          lda #> StatsText + 6
          sta Pointer +1
          lda #< StatsText + 6
          sta Pointer
          lda CurrentDefense
          jsr AppendDecimalAndPrint

          lda #> StatsText + 12
          sta Pointer +1
          lda #< StatsText + 12
          sta Pointer
          lda CurrentAccuracy
          jsr AppendDecimalAndPrint

          lda #> StatsText + 18
          sta Pointer +1
          lda #< StatsText + 18
          sta Pointer
          lda CurrentHP
          jsr AppendDecimalAndPrint

          lda #> StatsText + 24
          sta Pointer +1
          lda #< StatsText + 24
          sta Pointer
          lda MaxHP
          jmp AppendDecimalAndPrint

CopyPointerText:
          ldy # 0
-
          lda (Pointer), y
          sta StringBuffer, y
          iny
          cpy # 6
          bne -
          
          rts
          
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

DrawGrizzard:
          lda #0
          sta VDELP0
          sta VDELP1
          sta NUSIZ0
          sta NUSIZ1

          .ldacolu COLGREEN | $f
          sta COLUP0
          sta COLUP1
          
          ldy # 8
-
          lda GrizzardImages - 1, y
          sta GRP0
          lda GrizzardImages + 7, y
          sta GRP1
          sta WSYNC
          sta WSYNC
          dey
          bne -

          sty GRP0
          sty GRP1

          rts

ShowMove: 
          lda MoveSelection
          lda # >MovesTable
          sta Pointer + 1
          clc
          ldx #4
-
          asl a
          bcc +
          inc Pointer + 1
+
          sta Pointer

          jsr CopyPointerText
          jsr DecodeText
          jsr ShowText

          lda Pointer
          clc
          adc # 6
          bcc +
          inc Pointer + 1
+
          sta Pointer

          jsr CopyPointerText
          jmp DecodeAndShowText

          
StatsText:
          .MiniText "ATK 00"
          .MiniText "DEF 00"
          .MiniText "ACC 00"
          .MiniText "HP  00"
          .MiniText "MAX 00"
          
          .include "48Pixels.s"
          .include "Prepare48pxMobBlob.s"
          .include "DecodeText.s" 
          .include "ShowText.s"

          .include "GrizzardNames.s"
          .include "GrizzardImages.s"
          
          
          .align $100
          .include "Font.s"

          
	.include "EndBank.s"
