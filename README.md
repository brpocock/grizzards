Grizzards
=====================

TL;DR  —   A  turn-based  RPG   alpha  release  that   requires  SaveKey
or AtariVox.


Building: `make` at the top level

Build requires: `64tass`, `sbcl`, and some other stuff.

Copyright © 2021, Bruce-Robert Pocock






You see, what had happened was …
------------------

Back in  June I started  a little  project somewhat loosely  inspired by
Pokémon for the 2600. This requires a SaveKey (MemCard) or AtariVox, and
it works in Stella.

Aside  from requiring  a SaveKey,  this  is a  straightforward F4  32kiB
cartridge.

At this point  I have reached a  sort of alpha quality  and put together
a  little demo  build that  shows  off some  of the  main mechanisms  of
the game.

You are a Grizzard Handler, and you can take your Grizzard companion out
with  you to  fight monsters.  The  goals are  to find  all 30  Grizzard
companions (only  one is in this  demo) and destroy all  the monsters in
the game world (except random encounters).

Hopefully it seems entertaining enough, and  I'll put out a beta version
at some time in future (as time permits).


Cartridge Image files
---------------------

https://star-hope.org/games/Grizzards/Grizzards.Demo.NTSC.a26

https://star-hope.org/games/Grizzards/Grizzards.Demo.PAL.a26

https://star-hope.org/games/Grizzards/Grizzards.Demo.SECAM.a26

All image files with draft PDF manuals
-----------------------

https://star-hope.org/games/Grizzards/Grizzards.Demo.zip


Major Bugs
-----------

* Combat moves after  the first move do not work  properly. If you don't
  "one-hit" a  monster you'll  probably end up  in a  weird, error-prone
  loop until you're killed.
  
* Combat Moves  are not associated correctly with  the player's Grizzard
  or  monsters,  and  the  outcomes  of  those  Moves  need  to  be  set
  up properly.

* There  may still be  screen line count  issues with some  screens that
  will  cause rolling,  flickering,  or even  blanking  (or blue  screen
  blanking) on modern (digital) TVs. Please report them if you find such
  a bug: support@star-hope.orgsup


How to Play
------------

From the  title screen, press  Game Select to  choose a save  game slot.
If you don't  have a SaveKey connected (or configured  in Stella) you'll
get  a  "red sad  face"  screen  —  it's  not optional,  it's  required.
There are 3 "slots" to choose from, each of which takes up 4 "blocks" on
the SaveKey. Press Game Reset to start.

On  the  map screen,  navigate  with  the  joystick. You  may  encounter
a Grizzard  Depot, a (party  of) monster(s), a  door, or a  new Grizzard
(not in this demo). Just walk into them to engage.

A Grizzard Depot restores your Grizzard's hit points to its maximum, and
saves your  game. Press Fire to  leave. (Later you'll be  able to switch
between Grizzard  companions there.)  Press Game  Select to  review your
Grizzard's stats.

A door just  leads you to another  room. In the demo,  there's a one-way
door in the first room.

A new Grizzard will join you (replacing your current Grizzard companion)
if you run into  it (not in this demo). Unlike  Pokémon, you don't catch
the monsters that you fight against.

Monsters bring up the combat screen.  On the map, all monsters appear as
a  Slime;  you won't  know  what  actual  monsters  you face  until  you
encounter them.

From the  combat screen,  press Up and  Down to select  a Move  for your
Grizzard to perform.  RUN AWAY is a  special move that takes  you out of
combat,  but does  not  heal your  Grizzard. Other  moves  may hurt  the
monsters, or  apply status effects that  might make them lose  attack or
defense points, or even heal your Grizzard or “buff” your own attack and
defend stats.

Moves that you can  perform appear in color (blue for  RUN AWAY, red for
other  moves); moves  that  your Grizzard  does not  (yet)  know how  to
perform appear in black. Moves that  target the enemy will display a box
under the monster's image; when facing multiple monsters, press Left and
Right on the joystick to target a monster.

Press  Fire  to  execute  the   move  you've  selected.  You'll  see  an
announcement  of  the  move,  and  then the  outcome  of  it.  Then  the
monster(s) take their turn(s), and you'll see them announced as well.

If you're defeated, you'll be sent to  the GAME OVER screen. If you win,
you'll return  to the  Map Screen.  Your Grizzard  may also  improve its
stats slightly with each victory.

There is a chance that seeing a  monster execute a Move will teach it to
your Grizzard, if  it has that Move  in its collection. This  is how the
“moves in black” can turn to “moves in red” over time.

In  this Demo  you can  only wander  around a  small area  and encounter
a few monsters.

Pausing  is  the Color/B&W  switch  on  NTSC  or  PAL systems,  or  Left
Difficulty Switch on SECAM.

The Difficulty Switches don't affect the game play itself.


Erasing a game
---------------

To erase a save game slot  (to start over), set both Difficulty Switches
to A/expert/hard  mode, then pull  back on  the joystick, hold  down the
fire  button,  and  press  forward. This  is  intentionally  obscure  to
avoid accidents.  Once you hear  the “toilet  flush” sound, the  game is
basically gone forever.


Testing
---------

This  has only  been lightly  tested, mostly  in Stella,  but also  with
a real (4 switch) NTSC 2600 using  Harmony & Uno carts and an AtariVox.

If the game crashes,  you'll likely get sent to the  screen with a white
sad  face. If  it's unable  to  communicate with  the SaveKey  (MemCard,
AtariVox save  function) you'll get  a red sad  face; that's not  a bug,
just a limitation.

There's an Easter  Egg hidden that displays a special  message and shows
the build date  of the cartridge image file (as  YYMMDD). It's not super
complicated to access but I'd be curious if anyone ran into it.

Naturally, I'm excited to see any feedback.



Development
-----------

This is written in hand-coded assembler — no surprises there, I'm sure —
using the 64tass (Turbo Assembler), which  is more familiar to me coming
from a  C=64 background than DASM  or others. It's pretty  similar until
you  start playing  with macros  and compile-time  conditionals and  the
like. I  wrote a little utility  to convert the symbol  tables it writes
out into DASM-alike format for Stella. I'm running it under Linux but it
should work just as well on macOS.

Music was written in MIDI using MuseScore3; monster, Grizzard, and title
graphics were draw in PNG using  Gimp. MIDI and PNG conversion to source
code use a Lisp utility that is  just an awful example of spaghetti code
but has been used for C=64 conversions in the past. It actually began as
part of an  Atari 2600 game that  I was working on many  years ago which
was derailed when my house burned  down, so it's called the Skyline Tool
after that game.

It  also relies  on  Perl  for some  build  functions, particularly  for
encoding the text  to speech phonemes, and Gnu Make  drives the process.
I  have  updated the  SpeakJet.dic  file  that  came with  the  SpeakJet
developers' kit with  many “new” words and would love  to share that and
the  Perl   program  convert-to-speakjet   with  anyone   interested  in
(compile-time)  text-to-speech   for  AtariVox.  Perhaps   the  expanded
dictionary will help someone else.

Another  Perl program  reads  the  includes from  the  source files  and
generates  the  dependency graph  for  Make  automatically, so  I  don't
have to.

It's pressing  right up against the  limits of the 32k  space (with some
duplication of  code in the map  banks & combat banks),  so the monsters
aren't  animated and  the graphics  are all  solid-colored. I  intend to
release this as  a 32k game with these current  limitations, but I would
not rule out expanding to 64k to create an enhanced sequel with 

The source  code is not  too much  of a mess,  and if anything  is maybe
a little  more modular  than it  needs to  be right  now, with  over 100
individual files: 57 are major routines broken out into their own files,
19 are things that are local to  one memory bank (many of those are data
tables, e.g. monster  definitions), 8 “bank” files that  include all the
other files specific to a memory  bank (basically like a link table), 16
source files common to all banks (including VCS.s and things like Math.s
and Macros.s), and  23 files generated automatically by  tools, like the
music, title graphics, and phoneme tables for speech synthesis.



Credits
---------

Program, art, music, etc. — Bruce-Robert Pocock.



Includes  VCS header  file by  Matthew Dillon,  Olaf “Rhialto”  Seibert,
Andrew David, and Peter H. Froehlich (converted for 64tass syntax).
 
Binary-to-decimal translation  based upon  code by Andrew  Jacobs, based
upon code by Garth Wilson.

Some math  functions by  AtariAge Forum  user Omegamatrix;  others taken
from December 1984  Apple Assembly Line. (actually, I'm not  sure if I'm
using these, but they're in the macro files.)

“Have You Played Atari Today”  jingle transcribed by AtariAge Forum user
tiggerthehun and converted to MIDI myself.

And, of course thanks to everyone in the Stella and AtariAge communities
for making this game possible.



How To Build
---------------

First off,  you'll probably want a  Linux® system as this  build process
has  not been  tested under  macOS  and is  very unlikely  to work  with
Windows (since most of the tools are missing).

Make sure you have installed:

* SBCL (Steel Bank Common Lisp)
* Perl 5(.x)
* XeLaTeX
* 64tass (Turbo Assembler)
* GNU Make

and, to test:
* Stella

and, to burn EPROMS:
* MiniPro USB recording tools, a  MiniPro USB EPROM burner, and AT27C256
  EPROMs or compatible.

`cd` into the top-level directory and  run `make demo` to build the demo
software  for  all  three  regions  (NTSC,  PAL,  and  SECAM)  into  the
`Dist` directory.

To build and playtest, run `make  stella` for NTSC, or `make stella-pal`
or `make stella-secam` for the other regions.

To  burn an  EPROM,  run  `make cart-ntsc`,  `make  cart-pal`, or  `make
cart-secam`

If you  have a  Harmony or  Uno cartridge  and mount  the SD  card under
`/run/media/${USER}/HARMONY` or `/run/media/${USER}/TBA_2600`, which are
the  default  mount  points  and  SD disk  labels  for  those  platforms
respectively,  you can  write  to  the top  level  directory with  `make
harmony` or `make uno`.  It may be just as easy to  `make demo` and copy
the `.a26` files over directly.
