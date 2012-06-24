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


	subroutine DEFINE
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	if (ntok .eq. 1)  goto 500
	if (typlst(2) .eq. KALF)  goto 200
 100	call out (defn01,1)
	goto 1500

 200	g = tknlst(1,2)
	p = 3
	if (ntok .gt. 2)  goto 600
	do 300 i = 1, KNGRP
	  if (equal(tknlst(1,2), group(i,1), 5, 5)) goto 400
 300	continue
	call out (defn02,0)
	call outw (tknlst(1,2)) ; call crlf
	goto 1500
 400	call out (defn03,0)
	call outw (group(i,1)) ; call crlf
	group(i,1) = 0 ; group (i,2) = 0
	return

 500	call out (defn04,0)
	call gtkn
	if (typlst(1) .eq. KEOL)  goto 1500
	if (typlst(1) .ne. KALF)  goto 100
	g = tknlst(1,1)
	p = 2
	if (ntok .gt. 1)  goto 600
	call out (defn05,0)
	call gtkn
	if (typlst(1) .eq. KEOL)  goto 1500
	p = 1

 600	ff = 0
	do 700 i = KNGRP, 1, -1
	  if (group(i,1) .eq. 0)  ff = i
	  if (equal(g, group(i,1), 5, 5)) goto 800
 700	continue
	if (ff .ne. 0)  goto 900
	call out (defn06,1)
	goto 1500
 800	ff = i

 900	gbits = 0
	do 1400 i = p, ntok
	  do 1000 j = 1, KNPLAY
	    if (equal(tknlst(1,i), names(j,1), 5, 5)) goto 1100
1000	  continue
	  call out (defn07,0)
	  call outw (tknlst(1,i)) ; call crlf
	  goto 1500
1100	  if (j .ne. who)  goto 1200
	  call out (defn08,1)
	  goto 1400
1200	  if (job(j,KJOB) .ne. 0)  goto 1300
	  call out (defn09,0)
	  call out2w (names(j,1),names(j,2))  ;  call crlf
1300	  gbits = gbits .or. bits(j)
1400	continue

	if (gbits .ne. 0)  goto 1600
1500	call out (defn10,1)
	return

1600	group(ff,1) = g
	group(ff,2) = gbits
	return

	end
