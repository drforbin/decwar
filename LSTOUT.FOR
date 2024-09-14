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


C	LSTOUT -- Output requested LIST info.

	subroutine LSTOUT
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	include 'lstvar/nolist'
	integer sum(0:2)

	sum(0) = 0 ; sum(1) = 0 ; sum(2) = 0	!nothing flagged for summary
	nt = 0					!no targets yet

C.......Romulan

	if (romctr .eq. 0)  goto 100
	xf = romlst
	if ((xf .and. LSTBIT) .eq. 0)  goto 50
	side = 3  ;  code = DXROM*100  ;  object = DXROM
	vpos = locr(KVPOS)  ;  hpos = locr(KHPOS)
	call crlf
	call lstobj
   50	if ((xf .and. SUMBIT) .eq. 0)  goto 100
	nt = nt + 1
	call crlf
	call lstsum (romctr, 'Romulan', rxf)

C.......ships

  100	first = 1  ;  last = KNPLAY
	if (shpctr(1) .eq. 0)  first = KNPLAY/2 + 1
	if (shpctr(2) .eq. 0)  last = KNPLAY/2
	if (first .gt. last)  goto 300
	call crlf
	do 200 index = first, last
	  xf = shplst(index)
	  if (xf .eq. 0)  goto 200
	  side = 1  ;  if (index .gt. KNPLAY/2)  side = 2
	  if ((xf .and. LSTBIT) .eq. 0)  goto 150
	  object = side
	  code = object * 100 + index
	  vpos = shpcon(index,KVPOS)  ;  hpos = shpcon(index,KHPOS)
	  call lstobj
  150	  if ((xf .and. SUMBIT) .eq. 0)  goto 200
	  sum(side) = sum(side) + 1
	  if (side .ne. team)  nt = nt + 1
  200	continue
	if (cmd .eq. TARCMD)  goto 300
	call crlf
	call lstsum (sum(1), fedshp, sxf(1))	!"Federation ship"
	call lstsum (sum(2), empshp, sxf(2))	!"Empire ship"

C.......bases

  300	first = 1  ;  last = 2
	if (basctr(1) .eq. 0)  first = 2
	if (basctr(2) .eq. 0)  last = 1
	if (first .gt. last)  goto 600
	call crlf
	do 500 side = first, last
	  do 400 index = 1, KNBASE
	    xf = baslst(index,side)
	    if (xf .eq. 0)  goto 400
	    if ((xf .and. LSTBIT) .eq. 0)  goto 350
	    object = side + 2
	    code = object * 100 + index
	    vpos = base(index,KVPOS,side) ; hpos = base(index,KHPOS,side)
	    call lstobj
	    if ((xf .and. PASBIT) .eq. 0) 
     +	    base(index,4,side) = base(index,4,side) .or. team
  350	    if ((xf .and. SUMBIT) .eq. 0)  goto 400
	    sum(side) = sum(side) + 1
	    if (side .ne. team)  nt = nt + 1
  400	  continue
  500	continue
	if (cmd .eq. TARCMD)  goto 600
	call crlf
	call lstsum (sum(1), fedbas, bxf(1))	!"Federation base"
	call lstsum (sum(2), empbas, bxf(2))	!"Empire base"

C.......planets

  600	if (plnctr .eq. 0)  goto 800
	call crlf
	do 700 index = 1, nplnet
	  xf = plnlst(index)
	  if (xf .eq. 0)  goto 700
	  vpos = locpln(index,KVPOS)  ;  hpos = locpln(index,KHPOS)
	  object = dispc(vpos,hpos)
	  side = object - 6
	  if ((xf .and. LSTBIT) .eq. 0)  goto 650
	  code = object * 100 + index
	  call lstobj
	  if ((xf .and. PASBIT) .eq. 0) 
     +	  locpln(index,4) = locpln(index,4) .or. team
  650	  if ((xf .and. SUMBIT) .eq. 0)  goto 700
	  sum(side) = sum(side) + 1
	  if (side .eq. (3-team))  nt = nt + 1
  700	continue
	if (cmd .eq. TARCMD)  goto 800
	call crlf
	call lstsum (sum(0), neupln, pxf(0))	!"neutral planet"
	call lstsum (sum(1), fedpln, pxf(1))	!"Federation planet"
	call lstsum (sum(2), emppln, pxf(2))	!"Empire planet"

C.......targets summary

  800	if (cmd .ne. TARCMD)  return
	if (nt .eq. 0)  return
	call crlf
	call lstsum (nt, 'target', txf)
	return

	end
