;;; Grizzards Source/Banks/Bank07/Bank07.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $07

          ;;
          ;; Sound and Music services
          ;;

          .include "StartBank.s"

DoLocal:
          .include "PlaySFX.s"
          ;; falls through to
          .include "PlayMusic.s"
          ;; falls through to
          .include "PlaySpeech.s"
          ;; ↑ returns

          .include "SoundEffects.s"

          .include "SpeakJetIndex.s"

          ;; Speech index uses a wildcard on this directory
          ;; All files must be included or the index will break
          .include "Monsters6Speech.s"
          .include "MovesSpeech.s"
          .include "GrizzardsSpeech.s"
          .include "CombatSpeech.s"
          .include "TitleSpeech.s"
          .include "FinalSpeech.s"

          .include "AtariToday.s"
          .include "Theme.s"
          .include "Victory.s"
          .include "GameOver.s"
          .include "DepotJingle.s"

          .include "EndBank.s"
