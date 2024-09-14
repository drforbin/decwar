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


C	This routine permits players to set/reset their NAME, OUTPUT
C	message length, TTYTYPE, command PROMPT type, SCAN lengths,
C	and default input and output location flags (ICDEF, OCDEF).
C	System players are also able to end the current game, turn
C	on the Romulan, and remove black holes from the board.

	subroutine SET
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	p = 2
 100	if (typlst(p) .ne. KALF)  goto 200	!no switch yet given?
	if (equal (tknlst(p), 'NAME'))     goto 300
	if (equal (tknlst(p), 'OUTPUT'))   goto 500
	if (equal (tknlst(p), 'TTYTYPE'))  goto 700
	if (equal (tknlst(p), 'PROMPT'))   goto 1200
	if (equal (tknlst(p), 'SCANS'))    goto 1400
	if (equal (tknlst(p), 'ICDEF'))    goto 1600
	if (equal (tknlst(p), 'OCDEF'))    goto 1800
	if (.not. PASFLG)  goto 200
	if (equal (tknlst(p), 'ROMOPT'))   goto 1900
	if (equal (tknlst(p), 'ENDFLG'))   goto 2000
	if (equal (tknlst(p), 'BHREMV'))   goto 2100

 200	call out (set001, 0)			!get the switch
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	p = 1  ;  goto 100

*.......SET NAME switch

 300	if (usrnam(p))  return
	call out (set002,0)
	call gtkn
	call usrnam (0)
	return

*.......SET OUTPUT switch

 400	call out (set003, 0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	p = 0
 500	if (typlst(p+1) .ne. KALF)  goto 400
	if (equal (tknlst(p+1), shtfrm))  oflg = short
	if (equal (tknlst(p+1), medfrm))  oflg = medium
	if (equal (tknlst(p+1), lngfrm))  oflg = long
	return

*.......SET TTYTYPE switch

 600	call crlf
	call out (set008,0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	p = 0
 700	if (typlst(p+1) .ne. KALF)  goto 600
	ttytyp = 0
	do 800 i = 1, KNTTY
	  if (.not. (equal(tknlst(p+1), ttydat(1,i))))  goto 800
	  if (ttytyp .ne. 0)  goto 900
	  ttytyp = i
 800	continue
	if (ttytyp .ne. 0)  return
	call crlf
	goto 1000

 900	call out (set009,0)
1000	call out (set010,2)
	call out (ttys00,1)
	goto 600

*.......SET PROMPT switch

1100	call out (set004, 0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	p = 0
1200	if (typlst(p+1) .ne. KALF)  goto 1100
	if (equal (tknlst(p+1), normal))  prtype = 0
	if (equal (tknlst(p+1), inform))  prtype = -1
	return

*.......SET SCAN switch

1300	call out (set005,0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	p = 0
1400	if (typlst(p+1) .ne. KALF)  goto 1300
	if (equal (tknlst(p+1), shtfrm))  SCNFLG = SHORT
	if (equal (tknlst(p+1), lngfrm))  SCNFLG = LONG
	return

*.......SET ICDEF switch

1500	call out (set006,0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	p = 0
1600	if (typlst(p+1) .ne. KALF)  goto 1500
	if (equal (tknlst(p+1), absfrm))  icflg = KABS
	if (equal (tknlst(p+1), relfrm))  icflg = KREL
	return

*.......SET OCDEF switch

1700	call out (set007,0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	p = 0
1800	if (typlst(p+1) .ne. KALF)  goto 1700
	if (equal (tknlst(p+1), absfrm))  ocflg = KABS
	if (equal (tknlst(p+1), relfrm))  ocflg = KREL
	if (equal (tknlst(p+1), bthfrm))  ocflg = KBOTH
	return

*.......Set ROMOPT flag to true

1900	ROMOPT = .TRUE.
	return

*.......Remove HIGH segment flag

2000	ENDFLG = .TRUE.
	call endgam
	return

*.......Remove Black Holes from board.

2100	do 2200 i = 1, KGALV
	do 2200 j = 1, KGALH
	  if (dispc (i,j) .eq. DXBHOL)  call setdsp (i, j, 0)
2200	continue
	return

	end
