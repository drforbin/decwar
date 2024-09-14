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


C	This routine checks for an adjacent friendly starbase or planet,
C	and if either is found, the ship's energy and supplies are
C	fractionally increased (up to the maximum possible).  Bases
C	supply twice the energy and supplies per dock as do planets.

	subroutine DOCK (*)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

*.......Check for friendly base in range

	v = etim(tim0) + (slwest * 1000) + 1000
	ifract=0
	do 100 j = 1, KNBASE
	  if (base(j,3,team) .le. 0)  goto 100			!is base alive?
	  if (ldis (shpcon(who,KVPOS), shpcon(who,KHPOS), 
     +	  base(j,KVPOS,team), base(j,KHPOS,team), 1))
     +    ifract = ifract + 2	!is base within 1 sector?
 100	continue

*.......Check for friendly planet in range

	if (numcap(team) .le. 0)  goto 300
	do 200 i = 1, nplnet
	  if ((team + DXNPLN) .ne. dispc(locpln(i,KVPOS),locpln(i,KHPOS))) 
     +	  goto 200						!planet friendly?
	  if (.not. ldis(shpcon(who,KVPOS), shpcon(who,KHPOS), 
     +	  locpln(i,KVPOS), locpln(i,KHPOS), 1))  goto 200	!planet within 1 sector?
	  ifract=ifract + 1
 200	continue

*.......No adjacent bases or planets

 300    if (ifract .ne. 0) goto 400
    	call crlf
	call odisp (disp(shpcon(who,KVPOS),shpcon(who,KHPOS)), 1)
	call out (dock01,1)
	return 1

*.......Dock the ship  (R & R)!!

 400	if (.not. alive(who))  return 1		!ship already dead
	shpcon(who,KNTORP) = min0((shpcon(who,KNTORP) + (ifract*5)), 10)
	shpcon(who,KSNRGY) = min0((shpcon(who,KSNRGY) + (ifract*5000)), 
     +	50000)
	shpcon(who,KSSHPC) = min0((shpcon(who,KSSHPC) + (100*ifract)), 
     +	1000)
	shpcon(who,KSDAM) = max0 ((shpcon(who,KSDAM) - (ifract*500)), 0)
	if (docked(who))  shpcon(who,KSDAM) = max0((shpcon(who,KSDAM) - 
     +	(ifract*500)), 0)
	docked(who) = .TRUE.
	shpcon(who,KLFSUP) = 5  ;  shpcon(who,KSPCON) = GREEN

	call out (dockin,1)
	if (equal(tknlst(2), 'STATUS')) 
     +	call status (3)			!status report?

	ptime = v - etim(tim0)		!compute pause time for DOCK.
	return

	end
