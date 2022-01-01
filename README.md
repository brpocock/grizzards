Grizzards
=====================

TL;DR  —   A  turn-based  RPG   alpha  release  that   requires  SaveKey
or AtariVox.


Building: `make` at the top level

Build requires: `64tass`, `sbcl`, and some other stuff.

Copyright © 2021-2022, Bruce-Robert Pocock



https://star-hope.org/games/Grizzards/



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



How to Play
------------

Check the Manual for full detailed instructions.


Erasing a game
---------------

To erase a save game slot  (to start over), set both Difficulty Switches
to A/expert/hard  mode, then pull  back on  the joystick, hold  down the
fire  button,  and  press  forward. This  is  intentionally  obscure  to
avoid accidents.  Once you hear  the “toilet  flush” sound, the  game is
basically gone.

To recover, there's a separate utility program that can immediately
"Un-erase" a slot if you have not started a new game in it yet.


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

Program, art, etc. — Bruce-Robert Pocock.

Music, manual cover and additional artwork — Zephyr Salz



Includes  VCS header  file by  Matthew Dillon,  Olaf “Rhialto”  Seibert,
Andrew Davie, and Peter H. Froehlich (converted for 64tass syntax).
 
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
