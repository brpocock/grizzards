;;; Grizzards Source/Common/MoveEffects.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
MoveEffects:        .block
          ;; 0
RunAway:
          .byte 0
KickDirt:
          .byte 0
SplishSplash:
          .byte 0
MildShock:
          .byte 0
HotSpark:
          .byte 0
BuryDeep:
          .byte StatusSleep
DirtyFoot:
          .byte StatusDefendDown
LoamyFear:
          .byte StatusAttackDown
          ;; 8
DustyEyes:
          .byte StatusDefendDown
RaiseHope:
          .byte StatusDefendUp
SureSplash:
          .byte StatusAttackUp
QuickFoot:
          .byte StatusDefendDown
GreatMojo:
          .byte StatusAttackDown
WindFight:
          .byte 0
StealAttack:
          .byte StatusAttackDown
StealDefend:
          .byte StatusDefendDown
          ;; 16
StealTurn:
          .byte StatusSleep
FireStart:
          .byte StatusAttackUp
BurntEdges:
          .byte 0
RogueFlare:
          .byte 0
DoubleFlares:
          .byte 0
TailWhip:
          .byte 0
TailLash:
          .byte 0
Bite:
          .byte 0
          ;; 24
PoisonBite:
          .byte 0
CruelStab:
          .byte 0
BlindBlob:
          .byte StatusAttackDown | StatusDefendDown
SlimyTrick:
          .byte StatusAttackDown
GuardDown:
          .byte StatusDefendDown
FirstAid:
          .byte 0
SimpleCure:
          .byte 0
CommonCure:
          .byte 0
          ;; 32
GreatCure:
          .byte 0
HealWound:
          .byte 0
LifeReturn:
          .byte 0
Nibble:
          .byte 0
MuddleMind:
          .byte StatusMuddle
GreatMuddle:
          .byte 0
ScareAway:
          .byte 0
WetNoodle:
          .byte 0
          ;; 40
StompDown:
          .byte StatusSleep | StatusDefendDown
Crush:
          .byte 0
FireyBreath:
          .byte 0
EvilEye:
          .byte StatusMuddle
ClawsOut:
          .byte StatusDefendDown
DeadlySwoop:
          .byte 0
Shove:
          .byte 0
Slash:
          .byte 0
          ;; 48
VampyBite:
          .byte StatusSleep
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          ;; 56
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
MegaKill:
          .byte StatusDefendDown | StatusAttackDown | StatusMuddle | StatusSleep
          ;; ↑ 63

          .bend
;;; 
MoveDeltaHP:        .block
          ;; 0
RunAway:
          .byte $ff             ; RUN AWAY has fake value to indicate there's no target
KickDirt:
          .byte 1
SplishSplash:
          .byte 1
MildShock:
          .byte 1
HotSpark:
          .byte 2
BuryDeep:
          .byte 0
DirtyFoot:
          .byte 5
LoamyFear:
          .byte 0
          ;; 8
DustyEyes:
          .byte 0
RaiseHope:
          .byte $ff
SureSplash:
          .byte $ff
QuickFoot:
          .byte 5
GreatMojo:
          .byte 5
WindFight:
          .byte 3
StealAttack:
          .byte 0
StealDefend:
          .byte 0
          ;; 16
StealTurn:
          .byte 0
FireStart:
          .byte $ff
BurntEdges:
          .byte 5
RogueFlare:
          .byte 10
DoubleFlares:
          .byte 15
TailWhip:
          .byte 5
TailLash:
          .byte 10
Bite:
          .byte 15
          ;; 24
PoisonBite:
          .byte 25
CruelStab:
          .byte 25
BlindBlob:
          .byte 0
SlimyTrick:
          .byte 0
GuardDown:
          .byte 0
FirstAid:
          .byte $ff ^ 2
SimpleCure:
          .byte $ff ^ 5
CommonCure:
          .byte $ff ^ 10
          ;; 32
GreatCure:
          .byte $ff ^ 25
HealWound:
          .byte $ff ^ 50
LifeReturn:
          .byte $ff ^ 99
Nibble:
          .byte 7
MuddleMind:
          .byte 0
GreatMuddle:
          .byte 0
ScareAway:
          .byte 0
WetNoodle:
          .byte 4
          ;; 40
StompDown:
          .byte 19
Crush:
          .byte 27
FireyBreath:
          .byte 39
EvilEye:
          .byte 33
ClawsOut:
          .byte 12
DeadlySwoop:
          .byte 10
Shove:
          .byte 7
Slash:
          .byte 14
          ;; 48
VampyBite:
          .byte 5
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          ;; 56
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
          .byte 0
MegaKill:
          .byte 50
          ;; ↑ 63

          .bend
