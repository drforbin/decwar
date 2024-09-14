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


C	This routine builds a low segment variable DBITS which
C	indicates (using individual bits) the active ships within ILIM
C	sectors of the specified location (iV, iH).  IFLAG modifies
C	this command: 0 = all ships, 1 = only federation ships, and
C	2 = only klingon ships.  This routine is used by MAKHIT and
C	GETHIT to determine who should receive a particular hit
C	message.  If ZERO = 0, then DBITS is initially set to 0.

	subroutine PRIDIS (iV, iH, ilim, iflag, zero)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	li = 1  ;  lj = KNPLAY
	if (iflag .eq. 1)  lj = KNPLAY / 2
	if (iflag .eq. 2)  li = (KNPLAY / 2) + 1
	if (zero .eq. 0)  dbits = 0
	do 100 i = li, lj
	  if (alive(i) .gt. 0)  goto 100	!alive?
	  if (ldis(iV,iH,shpcon(i,KVPOS),shpcon(i,KHPOS),ilim)) 
     +	  dbits = dbits .or. bits(i)		!add to DBITS if in range
 100	continue
	return

	end
