;;; Grizzards Source/Banks/Bank07/Bank07.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $07

          ;;
          ;; Sound and Music services
          ;;

          .include "StartBank.s"

DoLocal:
          .include "PlaySFX.s"
          .if DEMO
          .include "PlayMusic.s"
          .else
DoMusic:  
          ldx # MusicBank
          jsr FarCall
          .fi
          .include "PlaySpeech.s"
          rts

          .include "SoundEffects.s"

          .include "SpeakJetIndex.s"
          ;; Speech index uses a wildcard on this directory
          ;; All files must be included or the index will break
          .include "MovesSpeech.s"
          .include "GrizzardsSpeech.s"
          .include "CombatSpeech.s"
          .include "TitleSpeech.s"
          .include "Monsters6Speech.s"
          .if !DEMO
          .include "Monsters7Speech.s"
          .fi

          .include "AtariToday.s"

          .include "Victory.s"
          .include "GameOver.s"

          .if DEMO
          .include "Theme.s"
          .fi

          .include "EndBank.s"
