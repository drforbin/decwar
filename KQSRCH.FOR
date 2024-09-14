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


C	This routine searches the KILQUE array for an entry matching
C	the argument list.  If a match is found, KINDEX contains the
C	the matching KILQUE row number, else it returns as zero.

	subroutine KQSRCH (ttynum, jobnum, ppn, kindex)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	kindex = 0
	if (nkill .eq. 0)  return	!no one has been killed yet
	do 100 ii = 1, nkill
	    i = ii
	  if ((jobnum .eq. kilque(i,1)) .and. (ppn .eq. kilque(i,2))) 
     +	  goto 200
c--	  if ((ttynum .eq. kilque(i,3)) .and. 
c--     +	  (etim(kilque(i,4)) .lt. 180000))  goto 200
 100	continue
	return				!player not found in kill queue

*.......Set KINDEX, update KILQUE entries

 200	kindex = i
	kilque(i,1) = jobnum
	kilque(i,2) = ppn
	kilque(i,3) = ttynum
	return

	end
