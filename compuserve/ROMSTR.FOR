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


C	This routine is used by the Romulan to see if there is a star
C	adjacent to his target.  If so, the star becomes the new target.

	subroutine ROMSTR (iV, iH)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	iVf = max0(iV - 1, 1)  ;  iVl = min0(iV + 1, KGALV)
	iHf = max0(iH - 1, 1)  ;  iHl = min0(iH + 1, KGALH)
	do 100 i = iVf, iVl
	do 100 j = iHf, iHl
	  if (dispc (i,j) .ne. DXSTAR)  goto 100	!star?
	  iV = i  ;  iH = j  ;  return			!Yes!  retarget, return
 100	continue
	return

	end
