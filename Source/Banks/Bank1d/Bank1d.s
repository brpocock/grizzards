;;; Grizzards Source/Banks/Bank1d/Bank1d.s
;;; Copyright © 2022, Bruce-Robert Pocock

          BANK = $1d

          ;; Combat sound, speech, and visual effects bank

          .include "StartBank.s"

DoLocal:
          cpy #ServiceCombatSpeech
          beq Speak
          cpy #ServiceCombatHitMonster
          beq CombatHitMonster
          cpy #ServiceCombatMissMonster
          beq CombatMissMonster
          cpy #ServiceCombatHitGrizzard
          beq CombatHitGrizzard
          cpy #ServiceCombatMissGrizzard
          beq CombatMissGrizzard
          brk

CombatHitMonster:
          
CombatMissMonster:
          
CombatHitGrizzard:
          
CombatMissGrizzard:

          rts

Speak:
          .include "PlaySpeech.s"
          rts
          
          .include "SpeakJetIndex.s"
          .include "MovesSpeech.s"
          .include "GrizzardsSpeech.s"
          .include "CombatSpeech.s"
          .include "Monsters6Speech.s"
          .include "Monsters7Speech.s"

          .include "EndBank.s"
