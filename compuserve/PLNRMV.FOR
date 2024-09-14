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


C	This routine is called whenever a planet is destroyed.  It
C	updates the planetary information, and checks if this ends
C	the game or undocks a player.

	subroutine PLNRMV (i,pteam)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	if (pteam .lt. 0) return
	if (i .gt. nplnet) return
	if (i .le. 0) return
	if (pteam .le. 0)  goto 100		!a captured planet?
	if (pteam .gt. 2) goto 100
	numcap(pteam) = numcap(pteam) - 1
	call baskil (pteam)			!anybody docked at it?

*	Shift the planet array into the empty row

 100	if (i .eq. nplnet) goto 110
	call blkmov (locpln(i+1,KVPOS), locpln(i,KVPOS), nplnet-i)
	call blkmov (locpln(i+1,KHPOS), locpln(i,KHPOS), nplnet-i)
	call blkmov (locpln(i+1,3), locpln(i,3), nplnet-i)
	call blkmov (locpln(i+1,4), locpln(i,4), nplnet-i)

110	nplnet = nplnet - 1

*	update display codes

	if ((nplnet .le. 0) .or. (i .gt. nplnet))  go to 300
	do 200 j = i, nplnet
	  call setdsp (locpln(j,KVPOS), locpln(j,KHPOS), 
     +	  (disp (locpln(j,KVPOS), locpln(j,KHPOS)) - 1))
 200	continue

 300	call endgam				!end of game?
	return

	end
