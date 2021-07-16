;;; Grizzards Source/Banks/Bank02/Bank02.s
;;; Copyright © 2021 Bruce-Robert Pocock
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
          cpy #ServiceGrizzardDepot
          beq GrizzardDepot
          cpy #ServiceAppendDecimalAndPrint
          beq AppendDecimalAndPrintThunk
          cpy #ServiceFetchGrizzardMove
          beq FetchGrizzardMove
          cpy #ServiceCombatOutcome
          beq CombatOutcomeScreen
          brk

DecodeAndShowText:
          jsr DecodeText
          jmp ShowText

AppendDecimalAndPrintThunk:
          lda Temp
          jmp AppendDecimalAndPrint.BINBCD8

FetchGrizzardMove:
          ldx MoveSelection
          beq FetchedRunAway
          dex
          stx Temp
          lda CurrentGrizzard
          asl a
          asl a
          asl a
          clc
          adc Temp
          tax
          lda GrizzardMoves, x
          sta Temp
          rts
FetchedRunAway:
          stx Temp
          rts

          .include "ShowText.s"
          .include "VSync.s"
          .include "VBlank.s"
          .include "Overscan.s"
          .include "48Pixels.s"
          .include "Prepare48pxMobBlob.s"
          .include "DecodeText.s"
          .include "ShowMove.s"
          .include "DrawGrizzard.s"
          .include "AppendDecimalAndPrint.s"
          .include "CopyPointerText.s"
          .include "ShowGrizzardName.s"
          .include "ShowGrizzardStats.s"
          .include "GrizzardDepot.s"
          .include "Failure.s"
          .include "CombatOutcomeScreen.s"
          .include "SetNextAlarm.s"
          .include "FindHighBit.s"

          .include "GrizzardNames.s"
          .include "GrizzardImages.s"
          .include "GrizzardArt.s"
          .include "GrizzardMoves.s"
          .include "MovesTable.s"

StatsText:
          .MiniText "ATK 00"
          .MiniText "DEF 00"
          .MiniText "HP  00"
          .MiniText "MAX 00"

DepotText:
          .MiniText "DEPOT "
PlayTimeText:
          .MiniText "PLAYED"
PlayHoursText:
          .MiniText "HOURS "

          .align $100, "font"

          .include "Font.s"

	.include "EndBank.s"
