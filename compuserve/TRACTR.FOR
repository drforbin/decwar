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


C	This routine allows a ship to tow another friendly ship.  The
C	deflector shields of both ships must be down.  Incoming torpedo
C	hits or nova damage breaks the tractor beam, as does raising
C	either ship's deflector shields.  The entry point TRCOFF is
C	used to break an active tractor beam.

	subroutine TRACTR (ip)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	call crlf
	index = 2
	if ((ntok .gt. 1) .or. (trstat(who) .eq. 0))  goto 100
	ip = who  ;  goto 1400

*.......Input desired ship to tractor beam

 100	if (typlst(index) .eq. KALF)  goto 200
	call out (tract1,0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	index = 1
	goto 100

*.......Turn tractor beam off?

 200	if (.not. equal(tknlst(index), 'OFF'))  goto 300
	ip = who  ;  if (trstat(ip) .ne. 0)  goto 1400
	call out (tract2,1)
	return

*.......Tractor beam ALREADY active?

 300	if (trstat(who) .eq. 0)  goto 400
	call out (tract3,1)
	return

*.......Match input with ship name

 400	do 500 i = 1, KNPLAY
	  if (equal (tknlst(index), names(i,1)))  goto 600
 500	continue
	call out (unkshp,1)		!unknown ship name
	return

*.......Tractoring your own ship?

 600	if (i .ne. who)  goto 700
	call out (tract4,1)
	return

*.......Attempting to tractor an enemy ship?

 700	dteam = 1  ;  if (i .gt. (KNPLAY/2))  dteam = 2
	if (team .eq. dteam)  goto 800
	call out (tract5,1)
	return

*.......Ship in game?

 800	if (alive(i))  goto 900
	call out (noship,1)
	return

*.......Adjacent to destination ship?

 900	if (ldis(shpcon(who,KVPOS), shpcon(who,KHPOS), 
     +	shpcon(i,KVPOS), shpcon(i,KHPOS), 1))  goto 1000
	call out (energ3,1)
	return

*.......Destination ship already has active tractor beam?

1000	iship = (DXFSHP * 100) + i
	if (i .gt. KNPLAY/2)  iship = iship + 100
	if (trstat(i) .eq. 0)  goto 1100
	call odisp (iship,1)
	call out (tract6,1)
	return

*.......Trying to apply tractor beam with YOUR shields up?

1100	if (shpcon(who,KSHCON) .lt. 0)  goto 1200
	call out (tract7,1)
	return

*.......Trying to apply tractor beam with HIS shields up?

1200	if (shpcon(i,KSHCON) .lt. 0)  goto 1300
	call odisp (iship,1)
	call out (tract8,1)
	return

*.......Apply tractor beam, inform players

1300	trstat(who) = i  ;  trstat(i) = who
	dbits = bits(who) .or. bits(i)
	iwhat = 13
	call makhit
	return

*.......Entry point for removing tractor beam

	entry TRCOFF (ip)

1400	dbits = bits(ip) .or. bits(trstat(ip))
	iwhat = 14
	trstat(trstat(ip)) = 0  ;  trstat(ip) = 0	!remove beam
	call makhit					!inform players
	return

	end
