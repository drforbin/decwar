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


C	This routine is used by MOVE, TORP, ROMDRV, and ROMTOR to
C	check the projected path of a ship or torpedo for objects
C	in the way.
C	INPUT
C	  H,V	  Initial coordinate
C	  DH,DV	  Relative V and H displacement (for direction only)
C	  Dist	  Maximum V or H displacement (distance to travel)
C	  Displ	  Displacement per sector (abs(Displ) < 0.50)
C
C	OUTPUT
C	  H1,V1	  Final location
C	  H2,V2	  Location of object that blocked path, else final location
C	  Dcode	  DISP code of object that blocked path, else 0
C	  DSH,DSV Delta H and Delta V to add to object to get displacement

	subroutine CHECK (H, V, dH, dV, dist, displ)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /chkout/ H1, V1, H2, V2, dcode, dHs, dVs
	real rH, rV, displ, dHs, dVs

	H1 = H  ;  V1 = V  ;  dcode = 0
	if (iabs(dV) .gt. iabs(dH))  goto 400

	inc = isign (1,dH)  ;  dHs = float (inc)
	dVs = float(dV) / float(iabs(dH)) + displ
	H2 = H  ;  rV = float(V)
	do 300 i = 1, dist
	  H2 = H2 + inc  ;  if (.not. ingal(5,H2))  goto 900
	  rV = rV + dVs
	  call chkpnt (rV, iV1, iV2)
	  if (.not. ingal(iV1,5))  goto 900
	  V2 = iV1
	  if (disp(H2,V2) .gt. 0) goto 800	!ran into something
	  if (iV2 .eq. 0) goto 100
	  if (.not. ingal(iV2,5))  goto 900
	  V2 = iV2
	  if (disp(H2,V2) .gt. 0) goto 800	!ran into something
	  V1 = int(rV + ran(0))
	  goto 200
  100	  V1 = int(rV + .5)
  200	  H1 = H2
  300	continue
	V2 = V1
	return					!made it to destination

  400	inc = isign (1, dV)  ;  dVs = float (inc)
	dHs = float(dH) / float(iabs(dV)) + displ
	V2 = V  ;  rH = float(H)
	do 700 i = 1, dist
	  V2 = V2 + inc  ;  if (.not. ingal(V2,5))  goto 900
	  rH = rH + dHs
	  call chkpnt (rH, iH1, iH2)
	  if (.not. ingal(5,iH1))  goto 900
	  H2 = iH1
	  if (disp(H2,V2) .gt. 0) goto 800	!ran into something
	  if (iH2 .eq. 0)  goto 500
	  if (.not. ingal(5,iH2))  goto 900
	  H2 = iH2
	  if (disp(H2,V2) .gt. 0) goto 800	!ran into something
	  H1 = int(rH + ran(0))
	  goto 600
  500	  H1 = int(rH + .5)
  600	  V1 = V2
  700	continue
	H2 = H1
	return					!made it to destination

  800	dcode = disp(H2,V2)			!ran into something
	return

  900	H2 = H1  ;  V2 = V1			!out of the galaxy
	return

	end
