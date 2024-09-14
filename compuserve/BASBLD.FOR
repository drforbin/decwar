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


C	This routine is activated whenever any player (or the Romulan)
C	makes a time-consuming move.  It's purpose is to strengthen
C	weakened starbases of the opposite team.  The Romulan rebuilds
C	both side's starbases.  The percentage gain in base energy per
C	BASBLD call is reduced as the number of players increase.

	subroutine BASBLD
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	ib = 1  ;  ie = 2  ;  n = 50 / (numply + 1)
	if (.not. PLAYER)  goto 100		!Romulan?
	if (team .eq. 1)  ib = 2  ;  ie = ib
	n = 25 / numsid(team)
 100	do 300 j = ib, ie
	  do 200 i = 1, KNBASE
	    if (base(i,3,j) .le. 0)  goto 200	!is base dead?
	    base(i,3,j) = min0 (base(i,3,j) + n, 1000)
 200	  continue
 300	continue
	return

	end
