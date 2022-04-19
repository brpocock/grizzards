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
          .byte StatusSleep
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
HeartyThump:
          .byte 0
HardJab:
          .byte 0
ClawBadly:
          .byte 0
BackKick:
          .byte 0
HeadButt:
          .byte 0
PirateCurse:
          .byte StatusMuddle | StatusSleep
SharpFangs:
          .byte 0
          ;; 56
NastyGoop:
          .byte 0
TalonVise:
          .byte 0
DeathGlare:
          .byte 0
PoundSand:
          .byte 0
WingsFlap:
          .byte 0
CursedGlance:
          .byte StatusSleep
SlimeImpact:
          .byte StatusMuddle
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
          .byte 2
SplishSplash:
          .byte 2
MildShock:
          .byte 2
HotSpark:
          .byte 4
BuryDeep:
          .byte 1
DirtyFoot:
          .byte 6
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
          .byte 6
GreatMojo:
          .byte 8
WindFight:
          .byte 6
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
          .byte 8
RogueFlare:
          .byte 12
          ;; 20
DoubleFlares:
          .byte 18
TailWhip:
          .byte 10
TailLash:
          .byte 14
Bite:
          .byte 16
          ;; 24
PoisonBite:
          .byte 24
          ;; 25
CruelStab:
          .byte 22
          ;; 26
BlindBlob:
          .byte 0
          ;; 27
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
          .byte 10
MuddleMind:
          .byte 0
GreatMuddle:
          .byte 8
ScareAway:
          .byte 0
WetNoodle:
          .byte 12
          ;; 40
StompDown:
          .byte 20
Crush:
          .byte 26
FireyBreath:
          .byte 30
EvilEye:
          .byte 28
ClawsOut:
          .byte 14
DeadlySwoop:
          .byte 10
Shove:
          .byte 8
Slash:
          .byte 18
          ;; 48
VampyBite:
          .byte 14
          ;; 49
HeartyThump:
          .byte 16
          ;; 50
HardJab:
          .byte 16
          ;; 51
ClawBadly:
          .byte 20
          ;; 52
          .byte 22
          ;; 53
          .byte 24
          ;; 54
          .byte 26
          ;; 55
          .byte 28
          ;; 56
          .byte 30
          ;; 57
          .byte 28
          ;; 58
          .byte 30
          ;; 59
          .byte 12
          ;; 60
          .byte 16
          ;; 61
          .byte 22
          ;; 62
          .byte 26
          ;; 63
MegaKill:
          .byte 50
          ;; ↑ 63

          .bend
