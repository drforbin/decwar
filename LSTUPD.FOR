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


C	LSTUPD -- Update list flags for given object (ship, base, planet)
C	if it's allowed to be listed (or included in a summary).

	subroutine LSTUPD (lstmsk, objctr, scnbts, xxf)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	include 'lstvar/nolist'

	d = pdist (sVpos, sHpos, Vpos, Hpos)

	xf = gxf

	if (d .le. KRANGE)  goto 400		!within range
	if (side .eq. team)  goto 400		!friendly
	if (.not. PASFLG)  goto 100
	xf = xf .or. PASBIT  ;  goto 400	!god
 100	xf = xf .or. ORNBIT			!out of range
	if (range .le. KRANGE)  goto 200
	grpbts = grpbts .or. KNOBIT		!"no KNOWN x in s.range/game"
	if ((xf .and. IGMBIT) .eq. 0)  xf = xf .or. KNOBIT
 200	txf = txf .or. xf			!update target summary flags
	if ((scnbts .and. team) .ne. 0)  goto 400  !already scanned

	if ((xf .and. SUMBIT) .eq. 0)  goto 700	!not requesting summary
	if ((xf .and. IGMBIT) .eq. 0)  goto 700	!not requesting entire game
	xf = xf.and..not.LSTBIT			!allow summary only (no list)
	goto 500

 400	if (d .gt. range)  goto 700		!not in requested range
	if ((imask .and. CLSBIT) .ne. 0)  goto 600  !looking for closest
 500	lstmsk = lstmsk .or. xf
	objctr = objctr + 1
	grpbts = grpbts .or. xf
	xxf = xxf .or. xf
	return

 600	if (d .gt. clsest)  goto 700		!looking for closest
	clsest = d  ;  Vposc = Vpos  ;  Hposc = Hpos
 700	grpbts = grpbts .or. (xf .and. (IRNBIT .or. ISRBIT .or. 
     +	IGMBIT .or. ORNBIT))
	xxf = xxf .or. xf
	return

	end
