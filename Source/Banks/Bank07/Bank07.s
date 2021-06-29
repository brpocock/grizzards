;;; Grizzards Source/Banks/Bank07/Bank07.s
;;; Copyright © 2021 Bruce-Robert Pocock
          BANK = $07

          ;;
          ;; Sound and Music services
          ;;

          .include "StartBank.s"

DoLocal:

          .include "PlaySFX.s"
          .include "PlaySpeech.s"

          .include "SoundEffects.s"

          .include "SpeakJetIndex.s"
          ;; Speech index uses a wildcard on this directory
          ;; All files must be included or the index will break
          .include "MovesSpeech.s"
          .include "GrizzardsSpeech.s"
          .include "CombatSpeech.s"
          .include "TitleSpeech.s"

          .include "EndBank.s"
