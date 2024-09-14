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


C	SNOVA -- This routine is called whenever a star is destroyed by
C	a torp.  It checks all objects around the destroyed star, and maims
C	and destroys as necessary.

	subroutine SNOVA
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /chkout/ V1, H1, iVc, iHc, dcode, idisV, idisH
	common /snlocl/ objstk(8,4), strstk(80,2)
	real idisV, idisH

	call setdsp (iVc, iHc, 0)		!get rid of star
	objptr = 0  ;  strptr = 0		!initialize stack pointers

 100	do 400 V = max0 (1,iVc-1), min0(KGALV,iVc+1)
	  do 300 H = max0 (1,iHc-1), min0(KGALH,iHc+1)
	    object = dispc (V,H)
	    if ((object .lt. 1) .or. (object .gt. DXEPLN))  goto 200
	    objptr = objptr + 1
	    objstk(objptr,1) = V  ;  objstk(objptr,2) = H
	    objstk(objptr,3) = V - iVc  ;  objstk(objptr,4) = H - iHc
	    goto 300
 200	    if ((object .ne. DXSTAR) .or. (iran(5) .eq. 5))  goto 300
	    if (strptr .eq. 29)  goto 300	!no more room, so don't blow up star
	    strptr = strptr + 1
	    strstk(strptr,1) = V  ;  strstk(strptr,2) = H
	    call setdsp (V, H, 0)
 300	  continue
 400	continue

 500	if (objptr .eq. 0)  goto 600		!awwww!  no more victims!
	V1    = objstk(objptr,1)  ;  H1    = objstk(objptr,2)
	idisV = objstk(objptr,3)  ;  idisH = objstk(objptr,4)
	objptr = objptr - 1
	thing = disp (V1, H1)
	if ((thing .le. 0) .or. (thing .ge. 100*DXSTAR))  goto 500
	call nova (thing/100, mod(thing,100))	!damage object
	goto 500

 600	if (strptr .eq. 0)  goto 700		!no stars to destroy
	iVc = strstk(strptr,1)  ;  iHc = strstk(strptr,2)
	strptr = strptr - 1
	dispfr = DXSTAR * 100  ;  iwhat = 7
	Vfrom = iVc  ;  Hfrom = iHc
	call pridis (Vfrom, Hfrom, KRANGE, 0, 0)
	call makhit
	if (PLAYER)  tpoint(KNSDES) = tpoint(KNSDES) - 500
	if (.not. PLAYER)  rsr(KNSDES) = rsr(KNSDES) - 500
	goto 100

 700	return

	end
