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
          
;;; String Buffer for text displays of composed text,
;;; e.g. chat names or monster names.
;;;
;;; XXX This can probably be factored out and save some
;;; work by eliminating DecodeText calls as well
StringBuffer:
          .byte ?, ?, ?, ?, ?, ?

;;; 
;;; Main "Traffic Cop" Switching
;;;

;;; The overall game mode.
;;; Used to select which "kernel" is in use.
GameMode:
          .byte ?

Pause:
          .byte ?

;;; What map is the player currently on?
CurrentMapBank:
          .byte ?
CurrentMap:
          .byte ?

;;; When in combat mode, in which bank are the current enemies found?
CurrentCombatBank:
          .byte ?

;;; 
;;; Game play/progress indicators -- global

;;; This data is saved to the first block of the save game file.
;;; It must never be more than 64 bytes (not that there's a great risk of that)

GlobalGameData:

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

;;; An alarm can be set for various in-game special events.
;;; This happens in real time.
AlarmMinutes:
          .byte ?
AlarmSeconds:
          .byte ?

;;; It's an Atari game, of course we have a score.
Score:
          .byte ?, ?, ?

;;; How much Energy (HP) can the player's Grizzard have?
MaxHP:
          .byte ?
;;; How much Energy does the Grizzard actually have?
CurrentHP:
          .byte ?

;;; Grizzard currently with the player
CurrentGrizzard:
          .byte ?

GrizzardAttack:
          .byte ?
GrizzardDefense:
          .byte ?
GrizzardAccuracy:
          .byte ?
          
;;; Moves known (8 bits = 8 possible moves)
MovesKnown:
          .byte ?

;;;  Where was the player last known to be safe?
BlessedX:
          .byte ?
BlessedY:
          .byte ?

          ;; Game event flags must be followed by CurrentProvince flags immediately
GameEventFlags:
          .byte ?, ?, ?, ?

EndGlobalGameData:

          .if EndGlobalGameData - GlobalGameData > 59
          .error "Global data exceeds 59 bytes (length is ", EndGlobalGameData - GlobalGameData + 1, " bytes)"
          .fi

;;; 
;;; Game play/progress indicators -- local to one province
;;; (paged in/out as player changes provinces)
ProvinceFlags:
          .byte ?, ?, ?, ?

CurrentProvince:
          .byte ?

;;; 
;;; Raw input cooking and partial movement accumulators

DebounceSWCHA:
          .byte ?
DebounceSWCHB:
          .byte ?
DebounceINPT4:
          .byte ?
DeltaX:
          .byte ?
DeltaY:
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

;;; Last frame when animation was updated
;;; used in map display for sprites, and combat
;;; display for health
LastAnimationFrame:
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
;;; Player facing

Facing:
          .byte ?

;;; 
;;; SpeakJet

;;; Pointer to the next phoneme to be spoken, or $0000
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

;;; In which bank do we find the music currently playing?
CurrentMusicBank:
          .byte ?

;;; Pointer to the next note of music to be played
CurrentMusic:
          .word ?

;;; Pointer to the start of the current song, if it's a loop,
;;; or $0000 if not.
CurrentSongStart:
          .word ?

;;; Timer until the current music note is done
NoteTimer:
          .byte ?

;;; When the current sound finishes, play this one next
;;; (index into list of sounds)
NextSound:
          .byte ?

;;; Pointer to the "note" of the sound being played
CurrentSound:
          .word ?

;;; Timer until the current sound "note" is done
SoundTimer:
          .byte ?

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


;;; 
;;; Start Game phase

          * = Scratchpad

;;; Which memory block is being wiped right now?
;;; We need to blank global + all provincial data
StartGameWipeBlock:
          .byte ?

;;; 
;;; Combat mode scratchpad

          * = Scratchpad

;;; What type (index) of enemy are we battling?
CurrentCombatEncounter:
          .byte ?

CurrentMonsterPointer:
          .word ?
          
;;; Pointer to the enemy's sprite graphics
CombatSpritePointer:
          .word ?

;;; Is the Grizzard affected by a Status Effect from combat?
StatusFX:
          .byte ?

;;; HP for each enemy (up to six)
EnemyHP:
          .byte ?, ?, ?, ?, ?, ?

;;; Status effects for each enemy
EnemyStatusFX:
          .byte ?, ?, ?, ?, ?, ?

;;; Player's Grizzard's energy as displayed
;;; (animates towards the direction of CurrentHP)
DisplayedHP:
          .byte ?

;;; Which item on the radial menu did the player select?
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
Sprite0Index:
          .byte ?
Sprite1Index:
          .byte ?
Sprite2Index:
          .byte ?
Sprite3Index:
          .byte ?

;;; X,Y position of virtual sprites
SpriteX:
Sprite0x:
          .byte ?
Sprite1X:
          .byte ?
Sprite2X:
          .byte ?
Sprite3X:
          .byte ?

SpriteY:
Sprite0Y:
          .byte ?
Sprite1Y:
          .byte ?
Sprite2Y:
          .byte ?
Sprite3Y:
          .byte ?

SpriteAction:
Sprite0Action:
          .byte ?
Sprite1Action:
          .byte ?
Sprite2Action:
          .byte ?
Sprite3Action:
          .byte ?

SpriteParam:
Sprite0Param:
          .byte ?
Sprite1Param:
          .byte ?
Sprite2Param:
          .byte ?
Sprite3Param:
          .byte ?

BumpCooldown:
          .byte ?

;;; 
;;; Verify that we don't run over

          ;; There must be at least $10 stack space (to be paranoid)
          .if * > $f0
          .error "Zero page ran right into stack space at ", *
          .if * > $ff
          .error "Zero page overcommitted entirely at ", *
          .fi
          .fi

          .warn "End of zero-page variables at ", *, " leaves ", $100 - *, " bytes for stack"
