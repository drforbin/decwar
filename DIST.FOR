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


C	This routine is used by the Romulan to find the nearest attackable
C	object (ship or base).

	subroutine DIST (ip, np, num)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /distlc/ V(4), H(4), iV(4), z(4)

	call blkset (z, (KGALV * KGALH + 1), 4)
	RV = locr(KVPOS)  ;  RH = locr(KHPOS)

*.......Find closest Federation ship

	do 100 j = 1, KNPLAY / 2
	  if (.not. alive(j))  goto 100
	  if (disp(shpcon(j,KVPOS),shpcon(j,KHPOS)) .le. 0)  goto 100
	  ztem = (RV - shpcon(j,KVPOS)) * (RV - shpcon(j,KVPOS)) + 
     +	  (RH - shpcon(j,KHPOS)) * (RH - shpcon(j,KHPOS))
	  if (ztem .ge. z(1))  goto 100
	  iV(1) = j  ;  z(1) = ztem
	  V(1) = shpcon(j,KVPOS)  ;  H(1) = shpcon(j,KHPOS)
 100	continue

*.......Find closest Klingon ship

	do 200 j = (KNPLAY / 2) + 1, KNPLAY
	  if (shpcon(j,KVPOS) .eq. 0)  goto 200
	  if (disp(shpcon(j,KVPOS),shpcon(j,KHPOS)) .le. 0)  goto 200
	  ztem = (RV - shpcon(j,KVPOS)) * (RV - shpcon(j,KVPOS)) + 
     +	  (RH - shpcon(j,KHPOS)) * (RH - shpcon(j,KHPOS))
	  if (ztem .ge. z(2))  goto 200
	  iV(2) = j  ;  z(2) = ztem
	  V(2) = shpcon(j,KVPOS)  ;  H(2) = shpcon(j,KHPOS)
 200	continue

*.......Find closest Federation and Klingon starbase

	do 400 k = 1, 2
	  if (nbase(k) .le. 0)  goto 400
	  do 300 j = 1, KNBASE
	    if (base(j,3,k) .le. 0)  goto 300
	    if (disp (base(j,KVPOS,k), base(j,KHPOS,k)) .eq. 0)  goto 300
	    ztem = (RV - base(j,KVPOS,k)) * (RV - base(j,KVPOS,k)) + 
     +	    (RH - base(j,KHPOS,k)) * (RH - base(j,KHPOS,k))
	    if (ztem .ge. z(2+k))  goto 300
	    iV(2+k) = j  ;  z(2+k) = ztem
	    V(2+k) = base(j,KVPOS,k)  ;  H(2+k) = base(j,KHPOS,k)
 300	  continue
 400	continue

*.......Figure out which of the above is closest of all

	np = 1
	if ((z(2) .lt. z(1))  .or. ((z(1) .eq. z(2))  .and. 
     +	(iran(2) .eq. 1)))  np = 2
	if ((z(3) .lt. z(np)) .or. ((z(3) .eq. z(np)) .and. 
     +	(iran(2) .eq. 1)))  np = 3
	if ((z(4) .lt. z(np)) .or. ((z(4) .eq. z(np)) .and. 
     +	(iran(2) .eq. 1)))  np = 4
	ip = iV(np)
	num = pdist (V(np), H(np), RV, RH)
	return

	end
