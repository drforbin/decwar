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


C	This routine repairs damaged ship devices.  It is called
C	after every time-consuming move to check for and repair any
C	such damage.  If docked, or if the REPAIR command is used,
C	this normal repair process is accelerated.  A user may
C	specify the exact amount of repairs desired, and the pause
C	time will be computed accordingly.  Also, the ALL switch will
C	determine the repair time needed to fix all the damaged
C	devices and will perform those repairs.  A call to DAMAGE
C	may be appended to such a REPAIR command.

	subroutine REPAIR (il,*)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	v = 0   ;   l = il
	if (docked(who) .and. (l .ne. 3))  l = 2

	if (l .eq. 1)  repsiz =  500   !DOCKed or REPAIR while underway
	if (l .eq. 2)  repsiz = 1000   !REPAIR while docked
	if (l .eq. 3)  repsiz =  300   !normal end-of-turn repair
	ntoken = 2

	if (l .eq. 3) goto 100
	if (typlst(2) .ne. KINT)  goto 100
	repsiz = vallst(2) * 10  ;  ntoken = 3

 100	maxd = 0
	do 200 i = 1, KNDEV
	  maxd = max0 (maxd, shpdam(who,i))
 200	continue
	if (maxd .eq. 0)  goto 600
	repsiz = min0 (repsiz, maxd)
	if (.not. (equal (tknlst(2), 'ALL')))  goto 300
	repsiz = maxd  ;  ntoken = 3

 300	if (l .eq. 3)  go to 400
	v = etim(tim0) + (repsiz * 8) / l

 400	do 500 i = 1, KNDEV
	  shpdam(who,i) = max0((shpdam(who,i) - repsiz), 0)
 500	continue

 600	if (l .eq. 3)  return
	if (equal (tknlst(ntoken), 'DAMAGE'))  call damage (ntoken+1)	!does he want a damage report?

	ptime = v - etim(tim0)
	if (ptime .le. 0)  return 1	!not a time-consuming repair
	return

	end
