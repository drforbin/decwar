C	This file is part of Decwar.
C	Copyright 1979, 2011 Bob Hysick, Jeff Potter, The University of Texas
C	Computation Center and Harris Newman.

C	This program is free software; you can redistribute it and/or modify
C	it under the terms of the GNU General Public License as published by
C	the Free Software Foundation; either version 3, or (at your option)
C	any later version.

C	This program is distributed in the hope that it will be useful,
C	but WITHOUT ANY WARRANTY; without even the implied warranty of
C	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
C	GNU General Public License for more details.

C	You should have received a copy of the GNU General Public License
C	along with this program; if not, write to the Free Software
C	Foundation, Inc., 51 Franklin Street - Fifth Floor, Boston, MA
C	02110-1301, USA.  


	implicit integer (a-z)

!;;	General constants used by DECWAR

	parameter knplay=10	!maximum number of players (can't be increased)
	parameter knbase=10	!initial number of bases on each side
	parameter kgalv=75	!maximum Vertical coordinate in galaxy
	parameter ksid=25	!# of words to hold compressed row of galaxy
	parameter kgalh=75	!maximum Horizontal coordinate in galaxy
	parameter brdsiz=1875	!board size (kgalv * kgalh / 3)
	parameter knplnt=60	!maximum number of planets
!	kmnpln==20		;minimum number of planets
!	kmxpln==80		;maximum number of planets
	parameter kndev=9	!number of devices
	parameter kpass='*MINK'	!password for system (*) commands
	parameter knmsg=32	!maximum number of messages in queue
	parameter msglen=17	!max # of words per msg (header + 80 chars)
	parameter kngrp=7	!number of defined message groups
	parameter knhit=64	!maximum number of hits in queue
	parameter kncmd=33	!number of available commands
	parameter knpcmd=16	!number of available commands in PREGAM
	parameter knpoin=8	!number of different scoring categories
	parameter knxtr=8	!# of things besides commands HELP knows
	parameter kscmd=2	!number of * (system) commands
	parameter kmaxtk=15	!max number of tokens to scan per input line
	parameter kntty=8	!number of TTY types supported
	parameter krange=10	!maximum range of scan, phasers, and torps
	parameter kcrit=3000	!amount of device damage deemed critical
	parameter kendam=25000	!amount of ship damage deemed fatal
	parameter kwait=0	!milliseconds to wait before restart
	parameter kcmdtm=2000	!milliseconds to wait for command before loop
	parameter kqlen=10	!length of killed queue
	parameter maxint="377777777777 !biggest integer
	parameter locsiz=200	!size of LOCAL common block

!;;	Token types returned by GTKN

	parameter keol=-1	!end of line
	parameter knul=0	!null
	parameter kint=1	!integer
	parameter kflt=2	!floating point
	parameter kalf=3	!alphanumeric

!;;	SHPCON indeces

	parameter kvpos=1	!V coordinate of ships, etc.
	parameter khpos=2	!H coordinate of ship, etc.
	parameter knturn=3	!number of turns player has taken
	parameter kspcon=4	!condition of ship (1=green, 2 = yellow,
				!  3=red)
	parameter kntorp=5	!number of torps remaining
	parameter kshcon=6	!condition of shields (1=up, -1=down)
	parameter klfsup=7	!life support reserves in stardates
	parameter ksnrgy=8	!units of ship energy remaining
	parameter ksdam=9	!amount of ship damage
	parameter ksshpc=10	!shield %

!;;	SCORE indeces

	parameter kpedam=1	!points for damage to enemy
	parameter kpekil=2	!points for enemies killed
	parameter kpbdam=3	!points for damage to bases
	parameter kppcap=4	!points for planets captured
	parameter kpbbas=5	!points for building bases
	parameter kprkil=6	!points for Romulans killed
	parameter knsdes=7	!numbers of stars destroyed
	parameter knpdes=8	!number of planets destroyed

!;;	SHPDAM indeces

	parameter kdshld=1	!damage to shields
	parameter kdwarp=2	!damage to warp engines
	parameter kdimp=3	!damage to impulse engines
	parameter kdlife=4	!damage to life support
	parameter kdtorp=5	!damage to photon torpedo tubes
	parameter kdphas=6	!damage to phasers
	parameter kdcomp=7	!damage to computer
	parameter kdrad=8	!damage to radio

!;;	JOB constants

	parameter knjbst=9	!total number of job status words
	parameter kjob=1	!job number
	parameter knam1=2	!first half of SIXBIT user name
	parameter knam2=3	!second half of SIXBIT user name
	parameter kppn=4	!PPN
	parameter kttyn=5	!TTY #
	parameter kttysp=6	!TTY speed
	parameter kttytp=7	!TTY type
	parameter kjobtm=8	!daytime at start up of present ship
	parameter kruntm=9	!run time at start up of present ship

!;;	Bits used by LIST

	parameter nambit="000001 !ship name
	parameter prtbit="000002 !PORT
	parameter shpbit="000004 !SHIP
	parameter basbit="000010 !BASE
	parameter plnbit="000020 !PLANET
	parameter crdbit="000040 !coordinate

	parameter fedbit="000100 !FEDERATION, HUMAN
	parameter empbit="000200 !EMPIRE, KLINGON
	parameter rombit="000400 !ROMULAN
	parameter neubit="001000 !NEUTRAL
	parameter capbit="002000 !CAPTURED
	parameter allbit="004000 !ALL
	parameter rngbit="010000 !range
	parameter clsbit="020000 !CLOSEST

	parameter sumbit="040000 !SUMMARY
	parameter lstbit="100000 !LIST
	parameter outmsk="140000 !SUMMARY|LIST

	parameter irnbit="000001 !in range
	parameter isrbit="000002 !in specified range
	parameter igmbit="000004 !in game
	parameter ornbit="000010 !out of range
	parameter pasbit="000020 !selected only because password is set
	parameter knobit="000040 !only known about because it's been scanned

	parameter sidmsk="003700 !fedbit|empbit|neubit|rombit|capbit
	parameter objmsk="000077 !nambit|crdbit|basbit|shpbit|plnbit|prtbit

!;;	Ship conditions

	parameter green=1
	parameter yellow=2
	parameter red=3

!;;	OFLG values

	parameter short=-1	!use short format output
	parameter medium=0	!use medium format output
	parameter long=1	!use long format output

!;;	ICFLG/OCFLG values

	parameter krel=-1	!default to relative coordinates
	parameter kboth=0	!output both relative and absolute coords
	parameter kabs=1	!default to absolute coordinates

!;;	Codes for commands that are entry points in the LIST command

	parameter lstcmd=0	!LIST
	parameter sumcmd=1	!SUMMARY
	parameter bascmd=2	!BASES
	parameter plncmd=3	!PLANETS
	parameter tarcmd=4	!TARGETS

!;;	DISP constants

	parameter dxmpty=0	!empty space
	parameter dxfshp=1	!federation ship
	parameter dxeshp=2	!empire ship
	parameter dxfbas=3	!feceration base
	parameter dxebas=4	!empire base
	parameter dxrom=5	!romulan ship
	parameter dxnpln=6	!neutral planet
	parameter dxfpln=7	!federation planet
	parameter dxepln=8	!empire planet
	parameter dxstar=9	!star
	parameter dxbhol=10	!black hole

	real ran,pwr



