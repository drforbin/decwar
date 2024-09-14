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


C	This routine reports on current ship device damages (if any).
C	STOKEN = 2 if this is a call from the DAMAGE command,
C	STOKEN = 3 if this is a call from the REPAIR routine.
C
	subroutine DAMAGE (stoken)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	call crlf
	do 100 i = 1, KNDEV		!anything damaged?
	  if (shpdam(who,i) .gt. 0)  goto 200
 100	continue
	call out (alldok,1)		!nope!
	goto 1800

*.......Specific device information requested?

 200	if (typlst(stoken) .ne. KALF)  goto 900
	do 800 i = stoken, KMAXTK
	  if (typlst(i) .ne. KALF)  goto 1800
	  do 700 j = 1, KNDEV
	    if (.not. (equal(tknlst(i), device(j))))  goto 700
	    call odev (j)
	    if (oflg)  300, 400, 500
 300	    call space  ;  goto 600
 400	    call tab (10)    ;  goto 600
 500	    call tab (19)
 600	    call oflt (shpdam(who,j), 4)
	    if (oflg .eq. long)  call out (units1,0)
	    call crlf
 700	  continue
 800	continue
	goto 1800

*.......General report on ALL damaged devices.

 900	if (oflg)  1200, 1100, 1000
1000	call out (damrep,0)
	call odisp(disp(shpcon(who,KVPOS),shpcon(who,KHPOS)), 0)
	call skip (2)
1100	call out (dmhdr1,0)
	if (oflg .eq. long)  call spaces (9)
	call out (dmhdr2,2)
1200	do 1700 i = 1, KNDEV			!scan the devices
	  if (shpdam(who,i) .le. 0)  goto 1700	!damaged?
	  call odev (i)
	  if (oflg)  1300, 1400, 1500
1300	  call space  ;  goto 1600
1400	  call tab (10)    ;  goto 1600
1500	  call tab (19)
1600	  call oflt (shpdam(who,i), 4)
	  if (oflg .eq. long)  call out (units1,0)
	  call crlf
1700	continue

1800	return

	end
