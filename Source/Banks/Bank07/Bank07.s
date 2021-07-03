;;; Grizzards Source/Banks/Bank07/Bank07.s
;;; Copyright © 2021 Bruce-Robert Pocock
          BANK = $07

          ;;
          ;; Sound and Music services
          ;;

          .include "StartBank.s"

DoLocal:
          jsr PlaySFX
          jsr PlaySpeech
          rts

          .include "PlaySFX.s"
          .include "PlaySpeech.s"

          .include "SoundEffects.s"

          .include "SpeakJetIndex.s"
          ;; Speech index uses a wildcard on this directory
          ;; All files must be included or the index will break
          .include "Monsters5Speech.s"
          .include "Monsters6Speech.s"
          .include "MovesSpeech.s"
          .include "GrizzardsSpeech.s"
          .include "CombatSpeech.s"
          .include "TitleSpeech.s"
          .include "NumbersSpeech.s"

          .include "Theme.s"
          .include "Province0.s"
          .include "Province1.s"
          .include "Province2.s"
          .include "Province3.s"

          .include "EndBank.s"
