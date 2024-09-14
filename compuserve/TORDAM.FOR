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


C	This routine, along with it's entry point PHADAM, determines
C	the amount of damage inflicted on ships and bases by torpedo
C	and phaser hits.  It also updates the scoring information, and
C	sets up many of the variables eventually needed by MAKHIT.

	subroutine TORDAM (nplc, j, id, phit, ship)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	real rand, rana, hit, ranb, hita

*.......Has the target already been destroyed?

	if ((nplc .lt. DXFBAS) .and. ((shpcon(j,KSDAM) .ge. KENDAM) 
     +	.or. (shpcon(j,KSNRGY) .le. 0)))  return
	if ((nplc .ge. DXFBAS) .and. (base(j,3,nplc-2) .le. 0))  return
	iwhat = 2
	rand = ran(0)
	rana = ran(0)
	hit  = 0.0
	hita = 0.0
	ranb = rand - 0.5

*.......Determine size of hit and amount absorbed by shields (if up)
*.......Reduce shield energy due to attack

	hit = 4000.0 + 4000.0 * ran(0)
	if (nplc .ge. DXFBAS)  goto 1100
	if (shpcon(j,KSHCON) .gt. 0)  1000, 300
 100	if (nplc .ge. DXFBAS)  goto 200
	hita = hit * (1000.0 - shpcon(j,KSSHPC)) * 0.001
	shpcon(j,KSSHPC) = shpcon(j,KSSHPC) - 
     +	(hit * amax1 (float(shpcon(j,KSSHPC)) * 0.001, 0.1)
     +  + 10) * 0.03
	if (shpcon(j, ksshpc) .lt. 0) shpcon(j, ksshpc) = 0
	goto 300
 200	hita = hit * (1000 - base(j,3,nplc-2)) * 0.001
	base(j,3,nplc-2) = base(j,3,nplc-2) - 
     +  (hit * amax1(float(base(j,3,nplc-2)) * 0.001, 0.1) + 10) * 0.03
	goto 400
 300	if (shpcon(j,KSHCON) .lt. 0)  hita = hit

*.......Determine if hit critical.

 400	ihita = hita
	if (((hita * (rana + 0.1)) .lt. 1700.0) .and. (nplc .lt. DXFBAS)) 
     +	goto 500
	if (((hita * (rana + 0.1)) .lt. 1700.0) .and. (nplc .ge. DXFBAS)) 
     +	goto 600
	if ((iran(5) .eq. 5) .and. (nplc .ge. DXFBAS))  goto 1400
	if (nplc .ge. DXFBAS)  goto 600

*.......Critically damage a random ship device

	hita = hita / 2.0
	critdv = int (KNDEV * ran(0) + 1.0)		!pick a device
	shpdam(j,critdv) = shpdam(j,critdv) + hita	!and damage it
	if (critdv .eq. KDSHLD)  shpcon(j,KSHCON) = -1	!shields down?
	critdm = hita
	hita = hita + (ran(0) - 0.5) * 1000.0
	ihita = hita

 500	shpcon(j,KSDAM) = shpcon(j,KSDAM) + hita
	shpcon(j,KSNRGY) = shpcon(j,KSNRGY) - hita
 600	if (nplc .ge. DXFBAS)  base(j,3,nplc-2) = 
     +	max0 (int(base(j,3,nplc-2) - hita * 0.01), 0)
 700	if ((nplc .lt. DXFBAS) .and. (shpcon(j,KSSHPC) .le. 0)) 
     +	shpcon(j,KSHCON) = -1

*.......Update scoring information

	if (SHIP .and. PLAYER .and. (5-team .eq. nplc)) 
     +	tpoint(KPBDAM) = tpoint(KPBDAM) + hita
	if (SHIP .and. (.not. PLAYER) .and. (nplc .ge. DXFBAS)) 
     +	rsr(KPBDAM) = rsr(KPBDAM) + hita
	if (PLAYER .and. SHIP .and. (3-team .eq. nplc)) 
     +	tpoint(KPEDAM) = tpoint(KPEDAM) + hita
	if (SHIP .and. (.not. PLAYER) .and. (nplc .lt. DXFBAS)) 
     +	rsr(KPEDAM) = rsr(KPEDAM) + hita

	if (nplc .ge. DXFBAS)  goto 1300	!base?
	shpcon(j,KSPCON) = RED
	shstto = shpcon(j,KSSHPC)  ;  shcnto = shpcon(j,KSHCON)
	if ((shpcon(j,KSDAM) .ge. KENDAM) .or. 
     +	(shpcon(j,KSNRGY) .le. 0))  klflg = 2

	if (klflg .ne. 0)  goto 750		!player destroyed?
	if (iwhat .eq. 1)  return		!phaser hit?
	call jump (nplc,j)			!displaced by torp?
	if (klflg .eq. 0)  return		!displaced into BH?

 750	call setdsp (shpcon(j,KVPOS), shpcon(j,KHPOS), 0)
	alive(j) = 0
	if (PLAYER .and. SHIP)  tpoint(KPEKIL) = tpoint(KPEKIL) + 5000
	if (SHIP .and. .not. PLAYER)  rsr(KPEKIL) = rsr(KPEKIL) + 5000
	return

	entry PHADAM (nplc, j, id, phit, ship)

*.......Determine size of phaser hit, and the amount absorbed by the
*.......shields (if up).  Decrease shield energy due to attack.

	iwhat = 1
	powfac = 80
	rana = ran(0)
	hit  = 0.0
	if ((nplc .lt. DXFBAS) .and. (shpcon(j,KSHCON) .gt. 0)) 
     +	powfac = powfac / 2
	if (nplc .ge. DXFBAS)  powfac = powfac / 2
	hit = pwr ((0.9 + 0.02 * ran(0)), id)

*.......If player firing, check if computer or phaser damaged.
*.......Modify size of hit if true.

	if (PLAYER .and. SHIP .and. ((shpdam(who,KDPHAS) .gt. 0) .or. 
     +	(shpdam(who,KDCOMP) .gt. 0)))  hit = hit * 0.8
	if (nplc .ge. DXFBAS)  goto 900
	if (shpcon(j,KSHCON) .lt. 0)  goto 800
	hita = hit
	hit = (1000 - shpcon(j,KSSHPC)) * hita * 0.001
	shpcon(j,KSSHPC) = shpcon(j,KSSHPC) - (hita * powfac * phit * 
     +	amax1 (float(shpcon(j,KSSHPC)) * 0.001, 0.1) + 10) * 0.03
	if (shpcon(j, ksshpc) .lt. 0) shpcon(j, ksshpc) = 0
 800	hita = hit * powfac * phit
	goto 400			!use damage and scoring code in common with TORDAM
 900	hita = hit
	hit = (1000 - base(j,3,nplc-2)) * hita * 0.001
	base(j,3,nplc-2) = base(j,3,nplc-2) - (hita * powfac * phit * 
     +	amax1 (float(base(j,3,nplc-2)) * 0.001, 0.1) + 10) * 0.03
	goto 800

*.......See if torpedo deflected by shields

1000	rand = rana - (shpcon(j,KSSHPC) * 0.001 * rand) + 0.1
1100	if (nplc .ge. DXFBAS)  rand = rana - (base(j,3,nplc-2) 
     +	* 0.001 * rand) + 0.1
	if (rand .gt. 0.0)  goto 100	!torpedo deflected?
	iwhat = 3  ;  ihita = 0
	if (nplc .ge. DXFBAS)  base(j,3,nplc-2) =
     +	amax1((float(base(j,3,nplc-2)) - 50.0 * rana), 0.0) 
	if (nplc .ge. DXFBAS)  goto 1200
	shpcon(j,KSSHPC) = amax1((float(shpcon(j,KSSHPC))-50.*rana),0.)
	if (shpcon(j, ksshpc) .lt. 0) shpcon(j, ksshpc) = 0
1200	hita = 0.0
	goto 700

*.......Critical hit on starbase (base destroyed if klflg .ne. 0)

1300	shstto = base(j,3,nplc-2)  ;  shcnto = 1
	if (base(j,3,nplc-2) .gt. 0)  return
1400	base(j,3,nplc-2) = base(j,3,nplc-2) - 50 - int(100.0 * ran(0))
	critdm = 1
	if ((iran(10) .eq. 10) .or. (base(j,3,nplc-2) .le. 0))  klflg = 2
	shstto = base(j,3,nplc-2)  ;  shcnto = 1

*.......Destroy starbase if shields gone

	if (klflg .eq. 0)  return
	call baskil (nplc-2)
	nbase(nplc-2) = nbase(nplc-2) - 1
	if (SHIP .and. .not. PLAYER)  rsr(KPBDAM) = rsr(KPBDAM) + 10000
	if (SHIP .and. PLAYER)  tpoint(KPBDAM) = tpoint(KPBDAM) + 10000
	call setdsp (base(j,KVPOS,nplc-2), base(j,KHPOS,nplc-2), 0)
	base(j,3,nplc-2) = 0
	return

	end
