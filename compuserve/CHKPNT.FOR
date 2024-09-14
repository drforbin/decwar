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


C	This routine is used by CHECK to determine the next position
C	on the display board to check for objects.
C	If the fractional part of C is greater than 0.60, return
C	INT(C)+1 in C1, and 0 in C2
C	If the fractional part of C is less than 0.40, return
C	INT(C) in C1, and 0 in C2
C	Otherwise, return INT(C) in C1 and INT(C)+1 in C2

	subroutine CHKPNT (c, c1, c2)
	include 'param/nolist'
	real c

	if (iabs (mod (int(c*100), 100) - 50) .lt. 10)  goto 100

	c1 = int(c + .5)
	c2 = 0
	return

  100	c1 = int(c)
	c2 = c1 + 1
	return

	end
