;;; Grizzards Source/Common/ZeroPage.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
;;;
;;; ZZZZZ EEEEE RRRR   OOO     PPPP    A    GGGG EEEEE
;;;    Z  E     R   R O   O    P   P  A A  G     E
;;;   Z   EEE   RRRR  O   O    PPPP  AAAAA G GGG EEE
;;;  Z    E     R   R O   O    P     A   A G   G E
;;; ZZZZZ EEEEE R   R  OOO     P     A   A  GGGG EEEEE
;;;
;;;
;;; Not only zero page RAM, but, in fact, all of the RAM
;;; available on the CX-2600 at all.

          * = $80
ZeroPage:
;;; 
;;; General-purpose short-term variable
;;;
;;; Use this as a temp var only within a block (non-reentrant)
Temp:
          .byte ?

Pointer:
          .word ?
;;; 
;;; Main "Traffic Cop" Switching
;;;

;;; The overall game mode.
;;; Used to select which "kernel" is in use.
GameMode:
          .byte ?

Pause:
          .byte ?
;;; 
;;; Game play/progress indicators -- global

;;; This data is saved to the first block of the save game file.
;;; It must never be more than 64 bytes (not that there's a great risk of that)
;;; In fact, it must be less than ( 64 - 4 × ProvincesCount )
;;; Currently ProvincesCount = 2 so it must be < 56 bytes

GlobalGameData:

;;; What map is the player currently on?
CurrentMap:
          .byte ?

;;; Global Timer (updated in VSYNC)
;;; This timer resets to zero when an alarm is set,
;;; but the Frame counter is used for some animation purposes.
;;; (The number of frames does in fact vary with 60Hz/50Hz locales)
ClockFourHours:
          .byte ?
ClockMinutes:
          .byte ?
ClockSeconds:
          .byte ?
ClockFrame:
          .byte ?

;;; It's an Atari game, of course we have a score.
Score:
          .byte ?, ?, ?

;;;  Where was the player last known to be safe?
BlessedX:
          .byte ?
BlessedY:
          .byte ?

;;; How much Energy does the Grizzard actually have?
CurrentHP:
          .byte ?

;;; Grizzard currently with the player
CurrentGrizzard:
          .byte ?

CurrentProvince:
          .byte ?

Potions:
          .byte ?

EndGlobalGameData:

          GlobalGameDataLength = EndGlobalGameData - GlobalGameData + 1

          .if GlobalGameDataLength > 27
          .error "Global data exceeds 27 bytes (length is ", GlobalGameDataLength, " bytes)"
          .fi
;;; 
;;; Game play/progress indicators -- local to one province
;;; (paged in/out as player changes provinces)
ProvinceFlags:
          .byte ?, ?, ?, ?,   ?, ?, ?, ?
;;; 
;;; How much Energy (HP) can the player's Grizzard have?
MaxHP:
          .byte ?
GrizzardAttack:
          .byte ?
GrizzardDefense:
          .byte ?
GrizzardXP:
          .byte ?

;;; Moves known (8 bits = 8 possible moves)
MovesKnown:
          .byte ?

;;; Temporarily used when switching rooms
NextMap:
          .byte ?
;;; An alarm can be set for various in-game special events.
;;; This happens in real time. The units are ½ seconds.
AlarmCountdown:
          .byte ?

;;; String Buffer for text displays of composed text,
;;; e.g.  monster names.
StringBuffer:
          .byte ?, ?, ?, ?, ?, ?

DebounceSWCHA:
          .byte ?
DebounceSWCHB:
          .byte ?
DebounceButtons:
          .byte ?
NewSWCHA:
          .byte ?
NewSWCHB:
          .byte ?
NewButtons:
          .byte ?
;;; XXX  these  should be  moved  into  the  overlay section,  but  that
;;; requires some remediation
DeltaX:
CombatMoveSelected:             ; actual Move ID, not relative to creature
          .byte ?
DeltaY:
CombatMoveDeltaHP:              ; base value, MoveHP has actual calculated effective value
          .byte ?
;;; Player current X,Y position on screen
PlayerX:
          .byte ?
PlayerY:
          .byte ?
;;; 
;;; Variables used in drawing

;;; Line counter for various sorts of "kernels"
LineCounter:
          .byte ?

;;; Run length counter used by map screens
RunLength:
          .byte ?

;;; Pixel pointers used in 48px graphics and text, and sometimes
;;; used as general-purpose short-term pointers as well.
PixelPointers:

pp0l:	.byte ?
pp0h:	.byte ?
pp1l:	.byte ?
pp1h:	.byte ?
pp2l:	.byte ?
pp2h:	.byte ?
pp3l:	.byte ?
pp3h:	.byte ?
pp4l:	.byte ?
pp4h:	.byte ?
pp5l:	.byte ?
pp5h:	.byte ?
;;; 
;;; SpeakJet

;;; What part of a sentence has been sent to the AtariVox/SpeakJet?
SpeechSegment:
          .byte ?

;;; Pointer to the next phoneme to be spoken, or $0000
;;; When commanding new speech, set to utterance ID with $00 high byte
CurrentUtterance:
          .word ?

SpeakJetCooldown:
          .byte ?
;;; 
;;; EEPROM

;;; The active game slot, 0-2 (1-3)
SaveGameSlot:
          .byte ?
;;; 
;;; Music and Sound FX

;;; Pointer to the next note of music to be played
CurrentMusic:
          .word ?

;;; Timer until the current music note is done
NoteTimer:
          .byte ?

;;; Timer until the current sound effects note is done
SFXNoteTimer:
          .byte ?

;;; When the current sound finishes, play this one next
;;; (index into list of sounds)
NextSound:
          .byte ?

;;; Pointer to the "note" of the sound being played
CurrentSound:
          .word ?


;;; Random number generator workspace
Rand:
          .word ?
;;; 
;;; Transient work space for one game mode
;;;
;;; The scratchpad pages are "overlaid," each game mode uses them differently.
;;; Upon entering a game mode, some care must be taken to re-initialize this
;;; area of memory appropriately.

            Scratchpad = *
;;; 
;;; Attract mode flags

;;; Attract mode flag for whether the speech associated with a certain mode
;;; has been started yet. (It's delayed on the title to avoid a conflict
;;; with the title screen jingle or the AtariVox start-up sound)

AttractHasSpoken:
          .byte ?

;;; The Story mode has several "panels" to be shown

AttractStoryPanel:
          .byte ?
AttractStoryProgress:
          .byte ?

;;; 
;;; SIgnpost mode scratchpad

          * = Scratchpad

SignpostIndex:
          .byte ?

SignpostText:
          .word ?

SignpostWork:
          .word ?

SignpostAction:
          .word ?

SignpostFG:
          .byte ?

SignpostBG:
          .byte ?

SignpostScanline:
          .byte ?

SignpostTextLine:
          .byte ?

SignpostInquiry:
          .byte ?

          * = $f0 - 9
SignpostLineCompressed:
          .byte ?, ?, ?, ?,  ?, ?, ?, ?,  ?

;;; 
;;; Combat mode scratchpad

          * = Scratchpad

;;; Reference to current combat scenario
CurrentCombatEncounter:
          .byte ?

;;; What flag do we set if victorious?
CurrentCombatIndex:
          .byte ?

;;; Which monster specifically are we fighting?
CurrentMonsterPointer:
          .word ?

;;; Index of monster's art, used to communicate between ROM banks
CurrentMonsterArt:
          .byte ?

;;; Pointer to the enemy's sprite graphics
CombatSpritePointer:
          .word ?

;;; Is the Grizzard affected by a Status Effect from combat?
StatusFX:
          .byte ?

;;; HP for each enemy (up to six)
MonsterHP:
          .byte ?, ?, ?, ?, ?, ?

;;; Status effects for each enemy
EnemyStatusFX:
          .byte ?, ?, ?, ?, ?, ?

;;; Which item on the menu did the player (or monster) select?
MoveSelection:
          .byte ?

;;; Whose turn is it?
;;; 0 = Player
;;; 1-6 = Enemies
WhoseTurn:
          .byte ?

;;; Target of the move, if it's the player's turn
MoveTarget:
          .byte ?

;;; When presenting the move being executed or its results,
;;; what part are we currently displaying/speaking?
MoveAnnouncement:
          .byte ?

;;; Overlain: when drawing vs. executing a move

          .union
          .struct
MonsterColorPointer:
          .word ?

CurrentMonsterNumber:
          .byte ?
          .endstruct

          .struct
;;; The move's outcome
MoveHitMiss:
          .byte ?

;;; The move's change in hit points
MoveHP:
          .byte ?

;;; The move's new status effects
MoveStatusFX:
          .byte ?

;;; Was this a critical hit?
CriticalHitP:
          .byte ?

          .endstruct
          .endunion
AttackerAttack:
          .byte ?

DefenderDefend:
          .byte ?

DefenderHP:
          .byte ?

DefenderStatusFX:
          .byte ?

;;; Non-zero if this is a Major Combat in stead of a regular one
;;; (only differences are how the enemy is drawn and numbers are omitted)
;;; This has to be past the SpriteParam fields which are $e8-$eb!
CombatMajorP:
          .byte ?

          CombatEnd = * - 1
;;; 
;;; Scratchpad for Name Entry
          * = Scratchpad
;;; Which memory block is being wiped right now?
;;; We need to blank global + all provincial data
StartGameWipeBlock:
          .word ?

;;; Which save slot did we last test?
SaveSlotChecked:
          .byte ?

;;; Is the current slot in use?
SaveSlotBusy:
          .byte ?

;;; Is the current slot recently erased?
SaveSlotErased:
          .byte ?

;;; Jatibu Code progress
SelectJatibuProgress:
          .byte ?

;;; Cursor position on name entry screeen
NameEntryPosition:
          .byte ?

;;; Buffer for name entry
NameEntryBuffer:
          .byte ?, ?, ?, ?, ?, ?
;;; 
;;; Scratchpad for Map mode
            * = Scratchpad

;;; Pointer to the start of the map's RLE display data
MapLinesPointer:
          .word ?

;;; How many non-player sprites are on screen now?
;;; These virtual sprites are multiplexed onto Player Graphic 1
;;;
;;; pp0 is pointer to player graphics.
;;; pp1-pp4 are pointers to the other sprites, if any.
SpriteCount:
          .byte ?

;;; Which non-player sprite should be drawn on this frame?
SpriteFlicker:
          .byte ?


;;; Counters for drawing P0 and P1 on this frame
P0LineCounter:
          .byte ?
P1LineCounter:
          .byte ?

SpriteIndex:
          .byte ?, ?, ?, ?

;;; X,Y position of virtual sprites
SpriteX:
          .byte ?, ?, ?, ?

SpriteY:
          .byte ?, ?, ?, ?

SpriteMotion:
          .byte ?, ?, ?, ?

SpriteAction:
          .byte ?, ?, ?, ?

SpriteParam:
          .byte ?, ?, ?, ?

BumpCooldown:
          .byte ?

MapFlags:
          .byte ?

PlayerXFraction:
          .byte ?
PlayerYFraction:
          .byte ?

          MapEnd = * - 1
;;; 
;;; Verify that we don't run over

          LastRAM = CombatEnd > MapEnd ? CombatEnd : MapEnd

          ;; There must be at least $10 stack space (to be fairly safe)
          .if LastRAM >= $f0
          .error "Zero page ran right into stack space at ", LastRAM
          .fi

          .if LastRAM >= $ff
          .error "Zero page overcommitted entirely at ", LastRAM
          .fi

          .if LastRAM >= $e0
          .warn "End of zero-page variables at ", LastRAM, " leaves ", $100 - LastRAM - 1, " bytes for stack"
          .fi
