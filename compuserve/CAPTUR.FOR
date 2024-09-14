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


C	This routine is used to capture neutral or enemy planets.
C	Player must be adjacent to planet specified (in 'orbit').
C	If a planet has been fortified by the enemy (using the BUILD
C	command), the pause time is increased 1 second and the
C	attacking ship's energy is reduced 50 units for each BUILD.

	subroutine CAPTUR (*)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	v = etim (tim0) + 5000
	tem = locate(2)
 100	if (tem .lt. 0)  return 1		!abort 'capture'
	if (tem .ne. 0)  goto 200
	tem = reloc(2)
	goto 100

 200	Vloc = vallst(1)  ;  Hloc = vallst(2)
	if (.not. ldis(shpcon(who,KVPOS), shpcon(who,KHPOS), Vloc, 
     +	Hloc, 1))  goto 500			!adjacent to sector specified?
	c = dispc (Vloc, Hloc)
	if ((c .lt. DXNPLN) .or. (c .gt. DXEPLN))  goto 400	!is there a planet here?
	if (c .eq. (DXNPLN + team))  goto 600	!planet already captured?

*.......Capture planet for the good guys!

300	call lock (plnlok,'CAPTUR')		!lock LOCPLN array
	if (.not. lkfail) goto 301
	call out ('The planet''s government refuses to surrender.', 1)
	return	1
301	tcap = c - DXNPLN
	if (tcap .ne. 0)  call pridis (Vloc, Hloc, KRANGE, tcap, 0)
	call pridis (Vloc, Hloc, 4, 0, 1)

*.......Update planet information

	i = dispx (Vloc, Hloc)
	if (tcap .ne. 0)  call baskil (tcap)
	if (tcap .ne. 0)  numcap(tcap) = numcap(tcap) - 1
	numcap(team) = numcap(team) + 1
	phit = 50 + (30 * locpln(i,3))		!set planet's phaser strength
	shstfr = locpln(i,3)
	v = v + locpln(i,3) * 1000
	shpcon(who,KSNRGY) = shpcon(who,KSNRGY) - locpln(i,3) * 500
	locpln(i,3) = 0
	call unlock (plnlok)			!unlock LOCPLN array
	dispfr = disp (Vloc, Hloc)   ;  iwhat = 1
	call setdsp (Vloc, Hloc, ((team + DXNPLN) * 100) + i)
	dispto = who + (team * 100)  ;  shjump = 0
	Vfrom = Vloc  ;  Hfrom = Hloc
	Vto = shpcon(who,KVPOS)  ;  Hto = shpcon(who,KHPOS)
	id = pdist (Vfrom, Hfrom, Vto, Hto)
	call phadam (team, who, id, phit, .FALSE.) !planet defends itself!
	if (tcap .ne. 0) tmscor(tcap,KPEDAM) = tmscor(tcap,KPEDAM) + ihita
	if ((klflg .ne. 0) .and. (tcap .ne. 0)) 
     +	tmscor(tcap,KPEKIL) = tmscor(tcap,KPEKIL) + 5000
	call pridis (shpcon(who,KVPOS), shpcon(who,KHPOS), KRANGE, 
     +	team, 0)
	call pridis (shpcon(who,KVPOS), shpcon(who,KHPOS), 4, 0, 1)

*.......Inform player of hit

	call crlf
	call odisp (who + (team * 100), 1)
	call out (captu0,0)
	call odisp ((tcap + DXNPLN) * 100, 1)
	call prloc (Vloc, Hloc, 1, 0, ocflg, oflg)
	call makhit
	tpoint(KPPCAP) = tpoint(KPPCAP) + 1000	!get points
	ptime = v - etim(tim0)			!pause for capture
	if ((shpcon(who,KSDAM) .lt. KENDAM) .and. 
     +	(shpcon(who,KSNRGY) .gt. 0))  return	!if player alive, return

*.......Player dies!

	if (team .eq. 1)  call out (captu1,1)
	if (team .eq. 2)  call out (captu2,1)
	call odisp (who + (team * 100), 1)
	call out (captu4,1)
	return

*.......Error messages

 400	idsp = dispc (Vloc, Hloc)		!no planet at location
	if (idsp .le. 0)  call out (noplnt,1)
	if ((team .eq. idsp) .or. (team+2 .eq. idsp))  call out (nosur1,1)
	if ((3-team .eq. idsp) .or. (5-team .eq. idsp)) 
     +	call out (nosur2,1)
	if (idsp .eq. DXROM)  call out (nosur3,1)
	if (idsp .ge. DXSTAR)  call out (nosur4,1)
	return 1

 500	call crlf				!not adjacent to specified location
	call odisp (disp(shpcon(who,KVPOS),shpcon(who,KHPOS)), 1)
	call out (captu5,1)
	return 1

 600	if (oflg .eq. long)  goto 700		!planet already captured
	call out (captu7, 1)
	goto 800
 700	if (team .eq. 1)  call out (captu6,1)
	if (team .eq. 2)  call out (captu8,1)
 800	return 1

	end
