;;; Grizzards Source/Common/Enums.s
;;; Copyright © 2021 Bruce-Robert Pocock
;;;
;;; Enumerated values used in various places.
;;; 

;;; Game modes are set up as a major (upper nybble) and minor (lower nybble)
;;; mode. The major mode usually indicates which kernel will be used; the
;;; minor modes allow the game mode to track its own sub-states.
          
          ModeColdStart = $00
          
          ModeAttract = $10
          ModeAttractTitle = $11
          ModeAttractCopyright = $12
          ModeAttractStory = $13
          ModeBRPPreamble = $1e
          ModePublisherPresents = $1f
          
          ModeSelectSlot = $20
          ModeEraseSlot = $21
          ModeErasing = $22
          ModeNoAtariVox = $23
          ModeStartGame = $24

          ModeMap = $30

          ModeCombat = $40
          ModeDeath = $44
          ModeGrizzardStats = $45

          ModeGrizzardDepot = $50

          ModeNewGrizzard = $60


;;; Sounds in the library (index values)
          SoundDrone = 1
          SoundChirp = 2
          SoundDeleted = 3
          SoundHappy = 4
          SoundBump = 5
          SoundHit = SoundBump
          SoundMiss = SoundDeleted
          SoundError = 6
          SoundSweepUp = 7

;;; Status Effects for player or enemies 
          StatusSleep = $01
          StatusAttackDown = $04
          StatusDefendDown = $08
          StatusMuddle = $10
          StatusAttackUp = $40
          StatusDefendUp = $80

          MoveEffectsToEnemy = $1f
          MoveEffectsToSelf = $e0

;;; Sprite types
          RandomEncounter = $80
          SpriteFixed = $40
          SpriteWander = $20

          SpriteMoveNone = $00
          SpriteMoveIdle = $01
          SpriteRandomEncounter = $02
          SpriteMoveLeft = $10
          SpriteMoveRight = $20
          SpriteMoveUp = $40
          SpriteMoveDown = $80
          
;;; Sprite actions
          SpriteCombat = $00
          SpriteGrizzardDepot = $01
          SpriteGrizzard = $02
          SpriteDoor = $03
          SpriteProvinceDoor = $07

          ;; Save game slot address.
          ;; Must be aligned to 64 bytes
          ;; TODO allocate the appropriate number of pages with AtariAge
          ;;
          ;; https://atariage.com/atarivox/atarivox_mem_list.html
          SaveGameSlotPrefix = $1700
          
          ;; Must be exactly 5 bytes for the driver routines to work
          .enc "ascii"
          SaveGameSignature = "griz0"
          .enc "none"


;;; Special Memory Banks

          ColdStartBank = $00
          SaveKeyBank = $00
          MapServicesBank = $01
          TextBank = $02
          FailureBank = $02
          Province01MapBank = $03
          Province23MapBank = $04
          CombatBank0To127 = $05
          CombatBank128To255 = $06
          SFXBank = $07

;;; Text bank provides multiple services, selected with .y

          ServiceDecodeAndShowText = $01
          ServiceShowText = $02
          ServiceShowGrizzardName = $03
          ServiceShowGrizzardStats = $04
          ServiceDrawGrizzard = $05
          ServiceShowMove = $06
          ServiceGrizzardDepot = $07
          ServiceAppendDecimalAndPrint = $0e

;;; Map services bank, same

          ServiceTopOfScreen = $08
          ServiceBottomOfScreen = $09
          ServiceFireworks = $0a
          ServiceDrawMonsterGroup = $0b
          ServiceNewGrizzard = $0c
          ServiceDeath = $0d

;;; Also the cold start / save game bank

          ServiceColdStart = $00
          ServiceSaveToSlot = $10
          ServiceSaveGrizzard = $11
          ServicePeekGrizzard = $12

;;; Maximum number of Grizzards allowed
;;; The save/load routines should handle up to 36

          NumGrizzards = 30

;;; Screen boundaries for popping to the next screen

          ScreenLeftEdge = 48
          ScreenRightEdge = 200
          ScreenTopEdge = 8
          ScreenBottomEdge = 75
