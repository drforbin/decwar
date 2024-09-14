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


C	SCAN/SRCAN -- Display the contents of nearby space.
C	SCAN range defaults to 10 sectors in each direction.
C	SRSCAN range defaults to 7 sectors in each direction.
C	The format is:
C	SCAN		square scan, default distance in each direction
C	SCAN d		square scan, d sectors each direction
C	SCAN dV dH	rectangular scan, dV up/down, dH right/left
C	SCAN UP		scan up/right/left default distance
C	SCAN UP d	scan up/right/left d sectors
C	SCAN UP dV dH	scan up dV sectors, right/left dH sectors
C	SCAN DOWN/RIGHT/LEFT	same format as SCAN UP
C	SCAN CORNER dV dH

	subroutine SCAN
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /local/ screen(200)
	dimension dist(4)		!distance to scan in each direction
					!(up, down, right, left)

*.......SCAN entry point -- default to maximum scanning distance

		dist(1) = krange ; dist(2) = krange
		dist(3) = krange  ;  dist(4) = krange
	goto 100

*.......SRSCAN entry point -- use a smaller default scanning distance

	entry SRSCAN
	dist(1) = 7       ;  dist(2) = 7
	dist(3) = 7       ;  dist(4) = 7

*.......Check for warning switch

  100	warn = .FALSE.
	k = (terwid - 9)/4		! calc. max width for user
	if (dist(1) .le. k) goto 101
		dist(1) = k; dist(2) = k; dist(3) = k; dist(4) = k
101	if (ntok .eq. 1)  goto 500
	if (.not. equal (tknlst(ntok), 'WARNING'))  goto 200
	warn = .TRUE.
	typlst(ntok) = KEOL  ;  ntok = ntok - 1

*.......Check for direction modifier

 200	mod = 0  ;  n = 0  ;  p = 2
	if (equal (tknlst(2), 'UP'))  mod = 2
	if (equal (tknlst(2), 'DOWN'))  mod = 1
	if (equal (tknlst(2), 'RIGHT'))  mod = 4
	if (equal (tknlst(2), 'LEFT'))  mod = 3
	if (equal (tknlst(2), 'CORNER'))  mod = 5
	if (mod .ne. 0)  p = 3
	if (typlst(p) .eq. KEOL)  goto 300	!no range given; use default
	if (typlst(p) .ne. KINT)  goto 1000	!expecting range; syntax error

*.......Get first number

	d = vallst(p)  ;  n = n + 1  ;  p = p + 1
	dist(1) = d  ;  dist(2) = d
	dist(3) = d  ;  dist(4) = d

	if (typlst(p) .eq. KEOL)  goto 300	!no second #; give square scan
	if (typlst(p) .ne. KINT)  goto 1000	!wasn't number; syntax error

*.......Get second number

	d = vallst(p)  ;  n = n + 1  ;  p = p + 1
	dist(3) = d  ;  dist(4) = d

	if (typlst(p) .ne. KEOL)  goto 1000	!not last item; error

*.......Trim scan direction for up/down/right/left

 300	if (mod .eq. 5)  goto 400		!corner
	if (mod .ne. 0)  dist(mod) = 0		!up, down, right, or left
	goto 500

*.......Trim scan direction for corner scan

 400	if (n .ne. 2)  goto 1000		!2 #s not given; error
	if (dist(1) .gt. 0)  dist(2) = 0
	if (dist(1) .lt. 0)  dist(2) = -dist(1)
	if (dist(3) .gt. 0)  dist(4) = 0
	if (dist(3) .lt. 0)  dist(4) = -dist(3)

*.......Compute scan bounds

 500	do 600 i = 1, 4
	  if (dist(i) .lt. 0)  dist(i) = 0
	  if (dist(i) .gt. KRANGE)  dist(i) = KRANGE
 600	continue
	Hpos = shpcon(who,KHPOS)
	Vpos = shpcon(who,KVPOS)
	Vmax = min0 (Vpos+dist(1), KGALV)
	Vmin = max0 (Vpos-dist(2), 1)
	Hmax = min0 (Hpos+dist(3), KGALH)
	Hmin = max0 (Hpos-dist(4), 1)
		
	call setscn (Hmin, Hmax, Vmin, Vmax)	!set up initial scan display
	enemy = 3 - team

*.......Look for planets in scan range

	if (nplnet .le. 0)  goto 800		!no planets
	do 700 i = 1, nplnet
	  if (.not. ldis (locpln(i,KVPOS), locpln(i,KHPOS), Vpos, Hpos, 
     +	  KRANGE))  goto 700
	  locpln(i,4) = locpln(i,4) .or. team	!our side has seen this planet
	  if (dispc(locpln(i,KVPOS),locpln(i,KHPOS))-DXNPLN .ne. enemy) 
     +    goto 700				!not an enemy planet
	  if (warn)  call mark (locpln(i,KVPOS), locpln(i,KHPOS), 2)
 700	continue

*.......Look for enemy bases in scan range

 800	do 900 i = 1, KNBASE
	  if (base(i,3,enemy) .le. 0)  goto 900	!not a live base
	  if (.not. ldis (base(i,KVPOS,enemy), base(i,KHPOS,enemy), 
     +	  Vpos, Hpos, KRANGE))
     +	  goto 900
	  base(i,4,enemy) = base(i,4,enemy) .or. team
	  if (warn) call mark (base(i,KVPOS,enemy),base(i,KHPOS,enemy),4)
 900	continue

*.......Finally output the scan

	call shwscn				!display scan
	return

1000	call out (syntax,1)
	return

	end
