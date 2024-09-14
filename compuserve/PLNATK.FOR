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


C	This routine controls the phaser defenses of planets.  These
C	are activated whenever a player (or the Romulan) makes a time-
C	consuming move.  A player only activates enemy and neutral
C	planets, not planets on his own side (the Romulan activates
C	ALL planets).  The size of the hit is controlled by how many
C	'BUILDS' the planet has undergone.

	subroutine PLNATK
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	if (nplnet .le. 0)  go to 400
	do 300 k = 1, nplnet
	  pcode = dispc (locpln(k,KVPOS), locpln(k,KHPOS))
	  pteam = pcode - DXNPLN
	  if ((pcode .eq. DXNPLN) .and. (iran(2) .eq. 1))  goto 300	!50% chance of attack
	  if (PLAYER .and. (pteam .eq. team))  goto 300	!don't activate friendly planets

*.........Search for a player within range

	  do 200 j = 1, KNPLAY
	    jtype = DXFPLN
	    if (j .gt. KNPLAY/2)  jtype = DXEPLN
	    if ((pcode .eq. jtype) .or. (.not. alive(j)))  goto 200
	    if (disp(shpcon(j,KVPOS),shpcon(j,KHPOS)) .le. 0)  goto 200
	    if (.not. ldis (shpcon(j,KVPOS), shpcon(j,KHPOS), 
     +	    locpln(k,KVPOS), locpln(k,KHPOS), 2))  goto 200	!in range?

*	    Set up parameters for call to MAKHIT

	    dispfr = disp (locpln(k,KVPOS), locpln(k,KHPOS))
	    dispto = disp (shpcon(j,KVPOS), shpcon(j,KHPOS))
	    shstfr = locpln(k,3)
	    Vfrom = locpln(k,KVPOS)  ;  Hfrom = locpln(k,KHPOS)
	    Vto   = shpcon(j,KVPOS)  ;  Hto   = shpcon(j,KHPOS)
	    shjump = 0
	    iwhat = 1  ;  phit = (50 + (30 * locpln(k,3))) / numply
	    id = pdist (Vfrom, Hfrom, Vto, Hto)
	    call phadam (2, j, id, phit, .FALSE.)	!hit him!
	    if (pcode .ne. DXNPLN)  tmscor(pteam,KPEDAM) = 
     +	    tmscor(pteam,KPEDAM) + ihita
	    if ((klflg .ne. 0) .and. (pcode .ne. DXNPLN)) 
     +	    tmscor(pteam,KPEKIL) = tmscor(pteam,KPEKIL) + 5000
	    call pridis (shpcon(j,KVPOS), shpcon(j,KHPOS), KRANGE, 
     +	    pteam, 0)
	    call pridis (shpcon(j,KVPOS), shpcon(j,KHPOS), 4, 0, 1)
	    call makhit				!send hit message
 200	  continue

*.........Hit romulan if he's alive and in range

	  if (.not. ROM)  goto 300
	  if (.not. ldis(locr(KVPOS), locr(KHPOS), locpln(k,KVPOS), 
     +	  locpln(k,KHPOS), 2))  goto 300
	  dispfr = disp (locpln(k,KVPOS), locpln(k,KHPOS))
	  dispto = DXROM * 100  ;  iwhat = 1
	  shstfr = locpln(k,3)
	  Vfrom = locpln(k,KVPOS)  ;  Hfrom = locpln(k,KHPOS)
	  Vto = locr(KVPOS)  ;  Hto = locr(KHPOS)  ;  shjump = 0
	  call pridis (locr(KVPOS), locr(KHPOS), KRANGE, pteam, 0)
	  call pridis (locr(KVPOS), locr(KHPOS), 4, 0, 1)
	  id = pdist (Vfrom, Hfrom, Vto, Hto)
	  call pharom (50 + (30 * locpln(k,3)), id)
	  shstto = erom  ;  shcnto = 1
	  if (pcode .ne. DXNPLN)  tmscor(pteam,KPRKIL) = 
     +	  tmscor(pteam,KPRKIL) + ihita
	  if ((.not. ROM) .and. (pcode .ne. DXNPLN)) 
     +	  tmscor(pteam,KPRKIL) = tmscor(pteam,KPRKIL) + 5000
	  call makhit				!send hit message
 300	continue
 400	return

	end
