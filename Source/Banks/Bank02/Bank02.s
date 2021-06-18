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
          
          .include "48Pixels.s"
          .include "Prepare48pxMobBlob.s"
          .include "DecodeText.s"
          .include "ShowMove.s"
          .include "ShowText.s"
          .include "DrawGrizzard.s"
          .include "AppendDecimalAndPrint.s"
          .include "CopyPointerText.s"
          .include "ShowGrizzardName.s"
          .include "ShowGrizzardStats.s"
          
          .include "GrizzardNames.s"
          .include "GrizzardImages.s"
          .include "MovesTable.s"
          
StatsText:
          .MiniText "ATK 00"
          .MiniText "DEF 00"
          .MiniText "ACC 00"
          .MiniText "HP  00"
          .MiniText "MAX 00"
          
          .align $100
          .include "Font.s"

          
	.include "EndBank.s"
