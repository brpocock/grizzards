; vcs.s
; Version 1.05, 13/November/2003 — revised for 64tass assembler, 2007

VERSIONVCS         = 105

;;; This is a port of *the* "standard" vcs.h
;;;
;;; Taken from the DASM macro assembler (aka small systems cross assembler)
;;;
;;;     Copyright © 1988-2002 by Matthew Dillon.
;;;     Copyright © 1995 by Olaf "Rhialto" Seibert.
;;;     Copyright © 2003-2008 by Andrew Davie.
;;;     Copyright © 2008 by Peter H. Froehlich.
;;;
;;;     This program is free software; you can redistribute it and/or modify
;;;     it under the terms of the GNU General Public License as published by
;;;     the Free Software Foundation; either version 2 of the License, or
;;;     (at your option) any later version.
;;;
;;;     This program is distributed in the hope that it will be useful,
;;;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;     GNU General Public License for more details.
;;;
;;;     You should have received a copy of the GNU General Public License along
;;;     with this program; if not, write to the Free Software Foundation, Inc.,
;;;     51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
;;;
;;; This file defines hardware registers and memory mapping for the
;;; Atari 2600. It is distributed as a companion machine-specific support package
;;; for the DASM compiler. Updates to this file, DASM, and associated tools are
;;; available at at http://www.atari2600.org/dasm
;;;
;;; Many thanks to the original author(s) of this file, and to everyone who has
;;; contributed to understanding the Atari 2600.  If you take issue with the
;;; contents, or naming of registers, please write to me (atari2600@taswegian.com)
;;; with your views.  Please contribute, if you think you can improve this
;;; file!
;;;
;;; Latest Revisions...
;;;
;;; 1.05  21/OCT/2007 — Bruce-Robert Pocock (brpocock@star-hope.org)
;;;                   — ported to Turbo Assembler syntax
;;;
;;; 1.05  13/NOV/2003      - Correction to 1.04 - now functions as requested by MR.
;;;                        - Added VERSIONVCS equate (which will reflect 100x version #)
;;;                          This will allow conditional code to verify VCS.H being
;;;                          used for code assembly.
;;;
;;; 1.04  12/NOV/2003     Added TIABASEWRITEADDRESS and TIABASEREADADDRESS for
;;;                       convenient disassembly/reassembly compatibility for hardware
;;;                       mirrored reading/writing differences.  This is more a
;;;                       readability issue, and binary compatibility with disassembled
;;;                       and reassembled sources.  Per Manuel Rotschkar's suggestion.
;;;
;;; 1.03  12/MAY/2003     Added SEG segment at end of file to fix old-code compatibility
;;;                       which was broken by the use of segments in this file, as
;;;                       reported by Manuel Polik on [stella] 11/MAY/2003
;;;
;;; 1.02  22/MAR/2003     Added TIMINT($285)
;;;
;;; 1.01	        		Constant offset added to allow use for 3F-style bankswitching
;;;						 - define TIABASEADDRESS as $40 for Tigervision carts, otherwise
;;;						   it is safe to leave it undefined, and the base address will
;;;						   be set to 0.  Thanks to Eckhard Stolberg for the suggestion.
;;;                          Note, may use -DLABEL=EXPRESSION to define TIABASEADDRESS
;;;                        - register definitions are now generated through assignment
;;;                          in uninitialised segments.  This allows a changeable base
;;;                          address architecture.
;;;
;;; 1.0	22/MAR/2003		Initial release


;

;;; TIABASEADDRESS
;;; The TIABASEADDRESS defines the base address of access to TIA registers.
;;; Normally 0, the base address should (externally, before including this file)
;;; be set to $40 when creating 3F-bankswitched (and other?) cartridges.
;;; The reason is that this bankswitching scheme treats any access to locations
;;; < $40 as a bankswitch.

          		.weak
TIABASEADDRESS	= 0
          		.endweak

;;; Note: The address may be defined on the command-line using the -D switch, eg:
;;; dasm.exe code.asm -DTIABASEADDRESS=$40 -f3 -v5 -ocode.bin
;;; *OR* by declaring the label before including this file, eg:
;;; TIABASEADDRESS = $40
;;;   include "vcs.h"

;;; Alternate read/write address capability - allows for some disassembly compatibility
;;; usage ; to allow reassembly to binary perfect copies).  This is essentially catering
;;; for the mirrored ROM hardware registers.

;;; Usage: As per above, define the TIABASEREADADDRESS and/or TIABASEWRITEADDRESS
;;; using the -D command-line switch, as required.  If the addresses are not defined,
;;; they defaut to the TIABASEADDRESS.

     .weak
TIABASEREADADDRESS = TIABASEADDRESS
     .endweak

     .weak
TIABASEWRITEADDRESS = TIABASEADDRESS
     .endweak

;

          * = TIABASEWRITEADDRESS

          ; DO NOT CHANGE THE RELATIVE ORDERING OF REGISTERS!

VSYNC       = $00	;   0000 00x0   Vertical Sync Set-Clear
VBLANK		= $01	;   xx00 00x0   Vertical Blank Set-Clear
WSYNC		= $02	;   ---- ----   Wait for Horizontal Blank
RSYNC		= $03	;   ---- ----   Reset Horizontal Sync Counter
NUSIZ0		= $04	;   00xx 0xxx   Number-Size player/missile 0
NUSIZ1		= $05	;   00xx 0xxx   Number-Size player/missile 1
COLUP0		= $06	;   xxxx xxx0   Color-Luminance Player 0
COLUP1      = $07	;   xxxx xxx0   Color-Luminance Player 1
COLUPF      = $08	;   xxxx xxx0   Color-Luminance Playfield
COLUBK      = $09	;   xxxx xxx0   Color-Luminance Background
CTRLPF      = $0A	;   00xx 0xxx   Control Playfield, Ball, Collisions
REFP0       = $0B	;   0000 x000   Reflection Player 0
REFP1       = $0C	;   0000 x000   Reflection Player 1
PF0         = $0D	;   xxxx 0000   Playfield Register Byte 0
PF1         = $0E	;   xxxx xxxx   Playfield Register Byte 1
PF2         = $0F	;   xxxx xxxx   Playfield Register Byte 2
RESP0       = $10	;   ---- ----   Reset Player 0
RESP1       = $11	;   ---- ----   Reset Player 1
RESM0       = $12	;   ---- ----   Reset Missile 0
RESM1       = $13	;   ---- ----   Reset Missile 1
RESBL       = $14	;   ---- ----   Reset Ball
AUDC0       = $15	;   0000 xxxx   Audio Control 0
AUDC1       = $16	;   0000 xxxx   Audio Control 1
AUDF0       = $17	;   000x xxxx   Audio Frequency 0
AUDF1       = $18	;   000x xxxx   Audio Frequency 1
AUDV0       = $19	;   0000 xxxx   Audio Volume 0
AUDV1       = $1A	;   0000 xxxx   Audio Volume 1
GRP0        = $1B	;   xxxx xxxx   Graphics Register Player 0
GRP1        = $1C	;   xxxx xxxx   Graphics Register Player 1
ENAM0       = $1D	;   0000 00x0   Graphics Enable Missile 0
ENAM1       = $1E	;   0000 00x0   Graphics Enable Missile 1
ENABL       = $1F	;   0000 00x0   Graphics Enable Ball
HMP0        = $20	;   xxxx 0000   Horizontal Motion Player 0
HMP1        = $21	;   xxxx 0000   Horizontal Motion Player 1
HMM0        = $22	;   xxxx 0000   Horizontal Motion Missile 0
HMM1        = $23	;   xxxx 0000   Horizontal Motion Missile 1
HMBL        = $24	;   xxxx 0000   Horizontal Motion Ball
VDELP0      = $25	;   0000 000x   Vertical Delay Player 0
VDELP1      = $26	;   0000 000x   Vertical Delay Player 1
VDELBL      = $27	;   0000 000x   Vertical Delay Ball
RESMP0      = $28	;   0000 00x0   Reset Missile 0 to Player 0
RESMP1      = $29	;   0000 00x0   Reset Missile 1 to Player 1
HMOVE       = $2A	;   ---- ----   Apply Horizontal Motion
HMCLR       = $2B	;   ---- ----   Clear Horizontal Move Registers
CXCLR       = $2C	;   ---- ----   Clear Collision Latches

;

          		* = TIABASEREADADDRESS

                    ;											bit 7   bit 6
CXM0P       = $00	;       xx00 0000       Read Collision  M0-P1   M0-P0
CXM1P       = $01	;       xx00 0000                       M1-P0   M1-P1
CXP0FB      = $02	;       xx00 0000                       P0-PF   P0-BL
CXP1FB      = $03	;       xx00 0000                       P1-PF   P1-BL
CXM0FB      = $04	;       xx00 0000                       M0-PF   M0-BL
CXM1FB      = $05	;       xx00 0000                       M1-PF   M1-BL
CXBLPF      = $06	;       x000 0000                       BL-PF   -----
CXPPMM      = $07	;       xx00 0000                       P0-P1   M0-M1
INPT0       = $08	;       x000 0000       Read Pot Port 0
INPT1       = $09	;       x000 0000       Read Pot Port 1
INPT2       = $0A	;       x000 0000       Read Pot Port 2
INPT3       = $0B	;       x000 0000       Read Pot Port 3
INPT4       = $0C	;		x000 0000       Read Input (Trigger) 0
INPT5       = $0D	;		x000 0000       Read Input (Trigger) 1

;

RIOT = $280

          * = RIOT

          ;; RIOT MEMORY MAP

SWCHA       = $280	; Port A data register for joysticks:
          ;;			Bits 4-7 for player 1.  Bits 0-3 for player 2.

SWACNT      = $281	; Port A data direction register (DDR)
SWCHB       = $282	; Port B data (console switches)
SWBCNT      = $283	; Port B DDR
INTIM       = $284	; Timer output

TIMINT  	= $285	;
          ;; Unused/undefined registers ($285-$294)


TIM1T       = $294	; set 1 clock interval
TIM8T       = $295	; set 8 clock interval
TIM64T      = $296	; set 64 clock interval
T1024T      = $297	; set 1024 clock interval

;;; end of vcs.h

;;; Added the following Jim Butterfield-compatible names for the IRQ/NMI/RES vectors (brp)

          NMIVEC = $fffa
          RESVEC = $fffc
          IRQVEC = $fffe


;;; end of vcs.s
