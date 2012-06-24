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


C	This routine plots a possible new location for ships and bases
C	after novas or photon torpedo hits.  If the new location contains
C	a black hole, death!

	subroutine JUMP (nplc, j)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /chkout/ V1, H1, V2, H2, dcode, disV, disH
	real disV, disH

	shjump = 0
	if (nplc .gt. DXESHP)  goto 100			!ship?
	iloc1 = shpcon(j,KVPOS)  ;  jloc1 = shpcon(j,KHPOS)
	goto 300
 100	if (nplc .eq. DXROM)  goto 200			!base?
	iloc1 = base(j,KVPOS,nplc-2)  ;  jloc1 = base(j,KHPOS,nplc-2)
	goto 300
 200	iloc1 = locr(KVPOS)  ;  jloc1 = locr(KHPOS)	!romulan

*.......Determine direction of blast, possible new location

 300	iVV = iloc1 + disV
	iHH = jloc1 + disH
	if (.not. ingal (IVV, IHH))  return
	if (.not. (pdist (iloc1, jloc1, iVV, iHH) .eq. 1))  return
	l = dispc (iVV,iHH)
	if (l .eq. DXBHOL)  goto 600	!blown into black hole?
	if (l .ne. DXMPTY)  return	!new location already occupied?

*.......Displace to new location

	call setdsp (iloc1, jloc1, 0)
	call setdsp (iVV, iHH, (nplc * 100) + j)
	if (nplc .ne. DXROM)  goto 400
	locr(KVPOS) = iVV  ;  locr(KHPOS) = iHH  ;  goto 500
 400	if (nplc .lt. DXFBAS)  shpcon(j,KVPOS) = iVV
	if (nplc .lt. DXFBAS)  shpcon(j,KHPOS) = iHH
	if (nplc .ge. DXFBAS)  base(j,KVPOS,nplc-2) = iVV
	if (nplc .ge. DXFBAS)  base(j,KHPOS,nplc-2) = iHH
 500	Vto = iVV  ;  Hto = iHH
	shjump = 1
	if (nplc .ge. DXFBAS)  return
	shpcon(j,KSPCON) = RED  ;  docked(j) = .FALSE.
	return

*.......Displaced into black hole!

 600	call setdsp (iloc1, jloc1, 0)	!zero out object's old location
	shjump = 1
	klflg = 1  ;  Vto = iVV  ;  Hto = iHH
	if (nplc .ne. DXROM)  goto 700	!romulan?
	ROM = .FALSE.
	return

 700	if (nplc .lt. DXFBAS)  shpcon(j,KSDAM) = KENDAM
	if (nplc .lt. DXFBAS)  alive(j) = 0
	if (nplc .ge. DXFBAS)  base(j,3,nplc-2) = 0
	return

	end
