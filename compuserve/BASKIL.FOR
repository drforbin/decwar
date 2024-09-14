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


C	This routine is activated whenever a starbase or captured
C	planet is destroyed.  The purpose of the routine is to check
C	whether any adjacent ships were docked at this object at the
C	time of the attack, and reset their ship's condition to RED
C	if true.  ITYPE = team of destroyed port.

	subroutine BASKIL (itype)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	ib = 1  ;  ie = KNPLAY
	if (itype .eq. 1)  ie = KNPLAY / 2
	if (itype .eq. 2)  ib = (KNPLAY / 2) + 1

	do 400 i = ib, ie
	  if (.not. docked(i))  goto 400	!is he docked?

*.........Check for adjacent starbase

	  if (nbase(itype) .le. 0)  goto 200	!any bases alive?
	  do 100 j = 1, KNBASE
	    if (base(j,3,itype) .le. 0)  goto 100
	    if (ldis(shpcon(i,KVPOS), shpcon(i,KHPOS), 
     +	    base(j,KVPOS,itype), base(j,KHPOS,itype), 1))  goto 400
 100	  continue

*.........Check for adjacent friendly planet

 200	  if (numcap(itype) .le. 0)  goto 400	!any friendly planets?
	  do 300 j = 1, nplnet
	    if ((itype + DXNPLN) .ne. dispc(locpln(j,KVPOS), 
     +	    locpln(j,KHPOS)))  goto 300
	    if (ldis(shpcon(i,KVPOS), shpcon(i,KHPOS), locpln(j,KVPOS), 
     +	    locpln(j,KHPOS), 1))  goto 400
 300	  continue

*.........No adjacent friendly port, undock player.

	  shpcon(i,KSPCON) = RED
	  docked(i) = .FALSE.
 400	continue
	return

	end
