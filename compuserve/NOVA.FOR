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


C	This routine is called by SNOVA to damage an object caught by
C	an exploding star.  Scoring is updated, plus modifying and/or
C	killing the object specified.

	subroutine NOVA (nplc, j)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /chkout/ V1, H1, iVc, iHc, dcode, idisV, idisH
	real idisV, idisH

	Vfrom = iVc  ;  Hfrom = iHc
	Vto = V1  ;  Hto = H1
	if (nplc .eq. DXROM)  goto 800					!Romulan?
	if ((nplc .ge. DXNPLN) .and. (nplc .le. DXEPLN))  goto 1000	!Planet?

*.......Compute size of nova

	d = 1000
	if (nplc .ge. DXFBAS)  d = d - base(j,3,nplc-2)
	if ((nplc .lt. DXFBAS) .and. (shpcon(j,KSHCON) .gt. 0)) 
     +	d = d - shpcon(j,KSSHPC)
	if (d .lt. 200)  d = 250
	if (nplc .ge. DXFBAS)  goto 200		!base?

*.......Damage ship's devices

	do 100 i = 1, KNDEV
	  shpdam(j,i) = shpdam(j,i) + int(ran(0) * d * 4.0)
 100	continue
	if (shpdam(j,KDSHLD) .ge. KCRIT)  shpcon(j,KSHCON) = -1

*.......Update scoring due to nova

 200	ihita = d * 8 + iran (1000)
	if (PLAYER .and. (5-team .eq. nplc))  tpoint(KPBDAM) = 
     +	tpoint(KPBDAM) + ihita
	if ((.not. PLAYER) .and. (nplc .ge. DXFBAS))  rsr(KPBDAM) = 
     +	rsr(KPBDAM) + ihita
	if (PLAYER .and. (3-team .eq. nplc))  tpoint(KPEDAM) = 
     +	tpoint(KPEDAM) + ihita
	if ((.not. PLAYER) .and. (nplc .lt. DXFBAS))  rsr(KPEDAM) = 
     +	rsr(KPEDAM) + ihita
	if (PLAYER .and. (team+2 .eq. nplc))  tpoint(KPBDAM) = 
     +	tpoint(KPBDAM) - ihita
	if (PLAYER .and. (team .eq. nplc))  tpoint(KPEDAM) = 
     +	tpoint(KPEDAM) - ihita

*.......Damage ship

	if (nplc .ge. DXFBAS)  goto 500		!base?
	shpcon(j,KSDAM) = shpcon(j,KSDAM) + ihita
	shpcon(j,KSNRGY) = shpcon(j,KSNRGY) - ihita * ran(0)
	if (shpcon(j,KSHCON) .gt. 0)  shpcon(j,KSSHPC) = max0( 
     +	shpcon(j,KSSHPC) - 300 + iran(100), 0)
	if (shpcon(j,KSSHPC) .le. 0)  shpcon(j,KSHCON) = -1

*	Ship destroyed?  Else, displace it

	if ((shpcon(j,KSDAM) .lt. KENDAM) .and. (shpcon(j,KSNRGY) .gt. 0)) 
     +	goto 300
	call setdsp (shpcon(j,KVPOS), shpcon(j,KHPOS), 0)
	alive(j) = 0  ;  klflg = 2
	goto 400
 300	call jump (nplc,j)			!displace the ship
 400	dispfr = DXSTAR * 100  ;  dispto = (nplc * 100) + j  ;  iwhat = 8
	Vto = shpcon(j,KVPOS)  ;  Hto = shpcon(j,KHPOS)
	shstto = shpcon(j,KSSHPC)  ;  shcnto = shpcon(j,KSHCON)
	if ((klflg .ne. 0) .and. PLAYER .and. (team .eq. nplc)) 
     +	tmscor(team,KPEKIL) = tmscor(team,KPEKIL) - 5000
	if ((klflg .ne. 0) .and. PLAYER .and. (team .ne. nplc)) 
     +	tmscor(team,KPEKIL) = tmscor(team,KPEKIL) + 5000
	if ((klflg .ne. 0) .and. (.not. PLAYER)) 
     +	rsr(KPEKIL) = rsr(KPEKIL) + 5000
	call pridis (shpcon(j,KVPOS), shpcon(j,KHPOS), KRANGE, 0, 0)
	call makhit			!send hit message
	if (trstat(j) .ne. 0)  call trcoff (j)	!break tractor beam?
	return

*.......Damage base

 500	jbase = nplc - 2
	if (base(j,3,jbase) .ne. 1000)  goto 600  !base ALREADY damaged?
	dispfr = DXSTAR * 100  ;  dispto = (nplc * 100) + j  ;  iwhat = 9
	call pridis (30, 30, 100, jbase, 0)
	dbits = dbits .and. .not. nomsg
	call makhit		!send galaxy-wide distress call

 600	base(j,3,jbase) = max0 (base(j,3,jbase) - 300 + iran (100) , 0)
	if (base(j,3,jbase) .gt. 0)  call jump (nplc,j)	!if base still alive, displace
	dispfr = DXSTAR * 100  ;  dispto = (nplc * 100) + j  ;  iwhat = 8
	Vfrom = iVc  ;  Hfrom = iHc
	Vto = base(j,KVPOS,jbase)  ;  Hto = base(j,KHPOS,jbase)
	shstto = base(j,3,jbase)  ;  shcnto = 1
	if (base(j,3,jbase) .gt. 0)  goto 700
	if (.not. PLAYER)  rsr(KPBDAM) = rsr(KPBDAM) + 10000
	if (PLAYER .and. (team .eq. jbase))  tpoint(KPBDAM) = 
     +	tpoint(KPBDAM) - 10000
	if (PLAYER .and. (team .ne. jbase))  tpoint(KPBDAM) = 
     +	tpoint(KPBDAM) + 10000
	nbase(jbase) = nbase(jbase) - 1
	call baskil (jbase)
	klflg = 2
 700	call pridis (base(j,KVPOS,jbase), base(j,KHPOS,jbase), 
     +	KRANGE, 0, 0)
	call makhit

*.......Base killed?

	if (base(j,3,jbase) .gt. 0)  return
	call setdsp (base(j,KVPOS,jbase), base(j,KHPOS,jbase), 0)
	iwhat = 10  ;  dispfr = DXSTAR * 100  ;  dispto = (nplc * 100) + j
	call pridis (30, 30, 100, jbase, 0)
	dbits = dbits .and. .not. nomsg
	Vto = base(j,KVPOS,jbase)  ;  Hto = base(j,KHPOS,jbase)
	call makhit		!send galaxy-wide death notice
	return

*.......Romulan damaged/killed by nova

c-- 800	if (iran(2) .eq. 1)  call deadro (d1,d2)!kill Romulan?
800	continue			! don't kill the Romulan
	if (ROM)  call jump (DXROM,1)
	if (ROM)  erom = erom / 2
	if (.not. PLAYER)  rsr(KPRKIL) = rsr(KPRKIL) - erom
	if (PLAYER)  tpoint(KPRKIL) = tpoint(KPRKIL) + erom
	dispfr = DXSTAR * 100  ;  dispto = DXROM * 100  ;  iwhat = 8
	shstto = erom  ;  shcnto = 1
	Vto = locr(KVPOS)  ;  Hto = locr(KHPOS)
	call pridis (Vto, Hto, KRANGE, 0, 0)
	call makhit			!send hit message
	if (ROM)  goto 900
	if (.not. PLAYER)  rsr(KPRKIL) = rsr(KPRKIL) - 5000
	if (PLAYER)  tpoint(KPRKIL) = tpoint(KPRKIL) + 5000
 900	return

*.......Planet damaged/destroyed by nova

1000	dispfr = DXSTAR * 100  ;  dispto = (nplc * 100) + j  ;  iwhat = 8
	call lock (plnlok,'NOVA')		!lock LOCPLN array
	if (lkfail) return			! ignore the destruction
	Vto = locpln(j,KVPOS)  ;  Hto = locpln(j,KHPOS)
	locpln(j,3) = locpln(j,3) - 3
	if (locpln(j,3) .lt. 0)  klflg = 2	!planet killed?
	shstto = max0 (locpln(j,3), 0)
	call pridis (Vto, Hto, KRANGE, 0, 0)
	call makhit			!send hit message
	if (locpln(j,3) .ge. 0)  goto 1100

*	Update planet information

	if (PLAYER) tpoint(KNPDES) = tpoint(KNPDES) - 1000
	if (.not. PLAYER)  rsr(KNPDES) = rsr(KNPDES) - 1000
	pteam = dispc (locpln(j,KVPOS), locpln(j,KHPOS)) - DXNPLN
	call setdsp (locpln(j,KVPOS), locpln(j,KHPOS), 0)
	call plnrmv (j,pteam)
1100	call unlock (plnlok)			!unlock LOCPLN array
	return

	end
