;;; Grizzards Source/Banks/Bank02/Bank02.s
;;; Copyright © 2021 Bruce-Robert Pocock
	BANK = $02

	.include "StartBank.s"
          .include "Source/Generated/Bank07/SpeakJetIDs.s"

          
          .include "Font.s"

DoLocal:
          cpy #ServiceDecodeAndShowText
          beq DecodeAndShowText
          cpy #ServiceShowText
          beq ShowText
          cpy #ServiceShowGrizzardName
          beq ShowGrizzardName 
          cpy #ServiceCombatOutcome
          beq CombatOutcomeScreen
          cpy #ServiceShowGrizzardStats
          beq ShowGrizzardStats
          cpy #ServiceShowMove
          beq ShowMove
          cpy #ServiceShowMoveDecoded
          beq ShowMoveDecoded
          cpy #ServiceAppendDecimalAndPrint
          beq AppendDecimalAndPrintThunk
          cpy #ServiceFetchGrizzardMove
          beq FetchGrizzardMove
          cpy #ServiceLevelUp
          beq LevelUp
          cpy #ServiceCombatIntro
          beq CombatIntroScreen
          brk

DecodeAndShowText:
          jsr DecodeText
          jmp ShowText

AppendDecimalAndPrintThunk:
          lda Temp
          jmp AppendDecimalAndPrint.BINBCD8

ShowMoveDecoded:
          ldy Temp
          jmp ShowMove.WithDecodedMoveID
          
          .include "ShowText.s"
          .include "VSync.s"
          .include "VBlank.s"
          .include "Overscan.s"
          .include "48Pixels.s"
          .include "Prepare48pxMobBlob.s"
          .include "DecodeText.s"
          .include "ShowMove.s"
          .include "AppendDecimalAndPrint.s"
          .include "CopyPointerText.s"
          .include "ShowGrizzardName.s"
          .include "ShowGrizzardStats.s"
          .include "SetNextAlarm.s"
          .include "FindHighBit.s"
          .include "FetchGrizzardMove.s"
          .include "Random.s"
          .include "CombatOutcomeScreen.s"
          .include "CombatIntroScreen.s"
          .include "LevelUp.s"

          .include "GrizzardNames.s"
          .include "GrizzardMoves.s"
          .include "MovesTable.s"
          .include "StringsTable.s"
          .include "WaitScreenBottom.s"

CombatText:
          .MiniText "COMBAT"

	.include "EndBank.s"
