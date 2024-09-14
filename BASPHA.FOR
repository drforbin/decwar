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


C	This routine controls the phaser defenses of the starbases.
C	These defenses are activated whenever a player (or the Romulan)
C	performs a time-consuming move.  A player only activates the
C	opposite team's starbases, with the Romulan activating both
C	side's bases.

	subroutine BASPHA
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	jb = 1  ;  je = 2
	if (.not. PLAYER)  goto 100			!Romulan?
	jb = 3 - team  ;  je = jb

 100	do 500 i = jb, je
	  if (nbase(i) .le. 0)  goto 500		!active bases?
	  do 400 j = 1, KNBASE
	    if (base(j,3,i) .le. 0)  goto 400		!base alive?

*...........Attack the players

	    do 300 k = (KNPLAY/2) * (2 - i) + 1, (KNPLAY/2) * (3 - i)
	      if (.not. alive(k))  goto 300		!player dead?
	      if (disp(shpcon(k,KVPOS), shpcon(k,KHPOS)) .le. 0) 
     +	      goto 300					!player cloaked?
	      if (.not. ldis(shpcon(k,KVPOS), shpcon(k,KHPOS), 
     +	      base(j,KVPOS,i), base(j,KHPOS,i), 4))  goto 300	!player in range?
	      Vfrom = base(j,KVPOS,i)  ;  Hfrom = base(j,KHPOS,i)
	      Vto   = shpcon(k,KVPOS)  ;  Hto   = shpcon(k,KHPOS)
	      dispto = (DXFSHP + (2 - i)) * 100 + k  ;  iwhat = 1
	      dispfr = (DXFBAS + (i - 1)) * 100 + j  ;  shjump = 0
	      id = pdist (Vfrom, Hfrom, Vto, Hto)
	      call phadam (3-i, k, id, 200/numply, .FALSE.)	!hit him!
	      tmscor(i,KPEDAM) = tmscor(i,KPEDAM) + ihita
	      shstfr = base(j,3,i)       ;  shcnfr = 1
	      if (klflg .ne. 0) tmscor(i,KPEKIL) = tmscor(i,KPEKIL) + 5000
 200	      call pridis (shpcon(k,KVPOS), shpcon(k,KHPOS), KRANGE, 
     +        team, 0)
	      call pridis (shpcon(k,KVPOS), shpcon(k,KHPOS), 4, 0, 1)
	      dbits = dbits .or. bits(k)
	      call makhit				!send hit message
 300	    continue

*...........Attack the Romulan (if he's alive)

	    if (.not. ROM)  goto 400		!Romulan alive?
	    if (.not. ldis (locr(KVPOS), locr(KHPOS), base(j,KVPOS,i),
     +	    base(j,KHPOS,i), 4))  goto 400	!Romulan in range?
	    dispto = DXROM * 100  ;  shjump = 0
	    dispfr = (DXFBAS + (i - 1)) * 100 + j  ;  iwhat = 1
	    Vfrom = base(j,KVPOS,i)  ;  Hfrom = base(j,KHPOS,i)
	    Vto   = locr(KVPOS)      ;  Hto   = locr(KHPOS)
	    id = pdist (Vfrom, Hfrom, Vto, Hto)
	    call pharom (200/numply, id)		!hit Romulan!
	    shstfr = base(j,3,i)  ;  shcnfr = 1
	    shstto = erom         ;  shcnto = 1
	    call pridis (locr(KVPOS), locr(KHPOS), KRANGE, 0, 0)
	    tmscor(i,KPRKIL) = tmscor(i,KPRKIL) + ihita
	    if (.not. ROM)  tmscor(i,KPRKIL) = tmscor(i,KPRKIL) + 5000
	    call makhit				!send hit message
 400	  continue
 500	continue
	return

	end
