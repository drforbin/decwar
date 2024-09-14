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


C	This routine is used to randomly position objects in the
C	universe.  It can position one or many such objects in a
C	single call.  It is called by SETUP and ROMDRV.

	subroutine PLACE (object, n, V, H)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	do 600 k = 1, n
 100	  V = iran (KGALV)			!find random V location
	  H = iran (KGALH)			!find random H location
	  if (disp(V,H) .ne. 0)  goto 100	!position already filled?
	  if (object/100 .gt. DXESHP)  goto 500	!PLACEing a ship?

*	  Check to make sure ship is not PLACEd in enemy territory.

	  pteam = 3 - (object/100)
	  if (nbase(pteam) .le. 0)  goto 300
	  do 200 i = 1, KNBASE
	    if (ldis (V, H, base(i,KVPOS,pteam), base(i,KHPOS,pteam), 4)) 
     +	    goto 100
 200	  continue
 300	  if ((nplnet .le. 0) .or. (numcap(pteam) .le. 0))  goto 500
	  do 400 i = 1, nplnet
	    if (pteam .ne. dispc (locpln(i,KVPOS), locpln(i,KHPOS))) 
     +	    goto 400
	    if (ldis (V, H, locpln(i,KVPOS), locpln(i,KHPOS), 2)) 
     +	    goto 100
 400	  continue
 500	  call setdsp (V, H, object)		!set up display code
c---	  if (object/100 .lt. DXSTAR)  call setdsp (V, H, (disp(V,H) + k))
 600	continue
	return

	end
