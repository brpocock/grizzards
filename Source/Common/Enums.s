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
          ModeCreditSecret = $14
          ModeBRPPreamble = $1e
          ModePublisherPresents = $1f

          ModeSelectSlot = $20
          ModeEraseSlot = $21
          ModeErasing = $22
          ModeNoAtariVox = $23
          ModeStartGame = $24

          ModeMap = $30
          ModeMapNewRoom = $31

          ModeCombat = $40
          ModeCombatAnnouncement = $41
          ModeCombatOutcome = $43
          ModeDeath = $44
          ModeCombatNextTurn = $45
          ModeLearntMove = $46

          ModeGrizzardDepot = $50

          ModeNewGrizzard = $60

          ModeGrizzardStats = $70

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
          SoundAtariToday = 8
          SoundVictory = 9
          SoundGameOver = 10
          SoundFootstep = 11

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
          ;; Must be page-aligned
          ;; Uses the subsequent 12 64-byte blocks
          .if DEMO
          SaveGameSlotPrefix = $3000
          .else
          ;; TODO allocate the appropriate number of pages with AtariAge
          ;;
          ;; https://atariage.com/atarivox/atarivox_mem_list.html
          SaveGameSlotPrefix = $1700
          .fi
          
          ;; Must be exactly 5 bytes for the driver routines to work
          .enc "ascii"
          SaveGameSignature = "griz0"
          .enc "none"


;;; Special Memory Banks

          ColdStartBank = $00
          SaveKeyBank = $00
          MapServicesBank = $01
          AnimationsBank = $01
          TextBank = $02
          FailureBank = $01
          Province0MapBank = $04
          Province1MapBank = $03
          CombatBank0To127 = $06
          CombatBank128To255 = $05
          SFXBank = $07

;;; Text bank provides multiple services, selected with .y

          ServiceAppendDecimalAndPrint = $0e
          ServiceCombatOutcome = $14
          ServiceDecodeAndShowText = $01
          ServiceDrawGrizzard = $05
          ServiceFetchGrizzardMove = $13
          ServiceGrizzardDepot = $07
          ServiceLearntMove = $18
          ServiceNewGame = $0f
          ServiceShowGrizzardName = $03
          ServiceShowGrizzardStats = $04
          ServiceShowMove = $06
          ServiceShowMoveDecoded = $17
          ServiceShowText = $02

;;; Map services bank, same

          ServiceBottomOfScreen = $09
          ServiceNewGrizzard = $0c
          ServiceStartNewGame = $16
          ServiceTopOfScreen = $08

;;; Animations share the map services bank in 32k

          ServiceAttractStory = $15
          ServiceDeath = $0d
          ServiceDrawMonsterGroup = $0b
          ServiceFireworks = $0a

;;; Also the cold start / save game bank

          ServiceColdStart = $00
          ServicePeekGrizzard = $12
          ServiceSaveGrizzard = $11
          ServiceSaveToSlot = $10

;;; Maximum number of Grizzards allowed
;;; The save/load routines should handle up to 36

          NumGrizzards = 30

;;; Screen boundaries for popping to the next screen

          ScreenLeftEdge = 48
          ScreenRightEdge = 200
          ScreenTopEdge = 8
          ScreenBottomEdge = 75

;;; Using TIM64T to skip a frame

          TimerSkipFrame = 215
          TimerSkipLines = 181

;;; Localization

          LangEng = $0e
          LangSpa = $05
          LangFra = $0f
