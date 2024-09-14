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


C	LISOBJ -- List object (ship, base, or planet).  Include
C	possibly name, location, shield percent, number of builds,
C	depending on the object, range, side, etc.  Flag line with *
C	in column 1 if the object is an enemy.

	subroutine LSTOBJ
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	include 'lstvar/nolist'

C	Input from LSTVAR:
C	  SVPOS,SHPOS	ship position
C	  CODE		display code of object
C	  OBJECT	object code [CODE/100]
C	  INDEX		object index [MOD(CODE,100)]
C	  VPOS,HPOS	position of object
C	  SIDE		which side the object is on
C	  CMD		command being executed
C	  XF		ORNBIT

	if ((side .eq. 0) .or. (side .eq. team) .or. (cmd .eq. TARCMD)) 
     +	goto 100
	call outc ('*')  ;  goto 200
  100	call space

  200	call odisp (code,0)
	if (oflg .eq. LONG)  call tab (14)
	if (oflg .ne. LONG)  call tab (5)

	goto (400, 400, 600, 600, 300, 700, 700, 700)  object

C.......Romulan
  300	if ((xf .and. ORNBIT) .ne. 0)  goto 500		!out of range
	call prloc (vpos, hpos, 0, 2, ocflg, oflg)
	call oflt (erom,6)
	if (oflg .ne. SHORT)  call outc ('%')
	goto 800

C.......ship
  400	if ((xf .and. ORNBIT) .ne. 0)  goto 500		!out of range
	call prloc (vpos, hpos, 0, 2, ocflg, oflg)
	spc = shpcon(index,KSHCON) * shpcon(index,KSSHPC)
	call osflt (spc,6)
	if (oflg .ne. SHORT)  call outc ('%')
	goto 800
  500	call out ('out of range',0)
	goto 800

C.......base
  600	call prloc (vpos, hpos, 0, 2, ocflg, oflg)
	if ((xf .and. ORNBIT) .ne. 0)  goto 800		!out of range
	call oflt (base(index,3,side),6)
	if (oflg .ne. SHORT)  call outc ('%')
	goto 800

C.......planet
  700	call prloc (vpos, hpos, 0, 2, ocflg, oflg)
	b = locpln(index,3)  ;  if (b .eq. 0)  goto 800
	call odec (b,6)
	if ((oflg .eq. LONG) .and. (b .ne. 1))  call out (' builds',0)
	if ((oflg .eq. LONG) .and. (b .eq. 1))  call out (build3,0)
	if (oflg .eq. MEDIUM)  call out (' b',0)

  800	call crlf
	return
c
	end
