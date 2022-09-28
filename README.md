Grizzards
=====================

TL;DR  —   A  turn-based  RPG beta  release  that   requires  SaveKey or
AtariVox.


Building: `make` at the top level

Build requires: `64tass`, `sbcl`, and some other stuff.

Copyright © 2021-2022, Bruce-Robert Pocock



https://star-hope.org/games/Grizzards/



You see, what had happened was …
------------------

This is a turn-based RPG for the Atari 2600. The demo version (linked below)
requires only an F4 (32kiB) bank switched cartridge, and a SaveKey device.

The full build is 64kiB (EF banked) and can be compiled for SaveKey or for
its own proprietary AtariAge cartridge with built-in save game support.



How to Play
------------

Check the Manual for full detailed instructions.


Testing
---------

This has  been somewhat  thoroughly tested, mostly  in Stella,  but also
with a real (4 switch) NTSC 2600  woody, a 2600 vader, and a 7800, using
Harmony, Plus, & Uno carts and SaveKey and AtariVox.

If the game crashes,  you'll likely get sent to the  screen with a white
sad  face. If  it's unable  to  communicate with  the SaveKey  (MemCard,
AtariVox save  function) you'll get  a red sad  face; that's not  a bug,
just a limitation. "MEMORY DEVICE NEEDED," as it says.

Naturally, I'm excited to see any feedback.



Development
-----------

Check out Guts.txt for a (usually out-of-date) overview 



Credits
---------

Program, art, etc. — Bruce-Robert Pocock.

Music, manual cover and additional artwork — Zephyr Salz

Full credits in the manual

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
  or AT27C512 EPROMs or compatible.
  
On Fedora, you can install prerequisite packages with

         sudo dnf -y install $(<packages)
         
If you run  into trouble with SBCL not auto-loading  a Quicklisp package
(I'm not  sure why this sometimes  occurs on a fresh  install), then try
running `sbcl` (or, better, `rlwrap sbcl`) and enter:

           (load "~/quicklisp/setup.lisp")
           (ql:quickload "the-package-name")
           (quit)
           
The  next  time you  run  `make`  it  will  probably find  the  packages
just fine. I imagine  this is a limitation of my  setup script not being
smart enough.

`cd` into the top-level directory and run `make demo` to build the demo
software  for  all  three  regions  (NTSC,  PAL,  and  SECAM)  into  the
`Dist` directory.

To build and playtest, run `make  stella` for NTSC, or `make stella-pal`
or `make stella-secam` for the other regions.

To  burn an  EPROM,  run  `make cart-ntsc`,  `make  cart-pal`, or  `make
cart-secam`

If you  have a  Harmony or  Uno cartridge  and mount  the SD  card under
`/run/media/${USER}/HARMONY` or `/run/media/${USER}/TBA_2600`, which are
the  default  mount  points  and   SD  disk  labels  for  those  devices
respectively  on  Fedora at  least,  you  can  write  to the  top  level
directory with `make harmony`  or `make uno`. It may be  just as easy to
`make demo` and copy the `.a26` files over directly.
