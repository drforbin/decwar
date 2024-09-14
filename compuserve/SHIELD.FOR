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


C	This routine is used to raise or lower a ship's deflector
C	shields, as well as transfer energy between the ship and shield
C	energy reserves.  The switches recognized are: UP, DOWN, and
C	TRANSFER.

	subroutine SHIELD
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	call crlf
	if (typlst(2) .ne. KALF)  goto 100	!no switch yet given?
	if (equal (tknlst(2), 'TRANSFER'))  goto 500
	if (equal (tknlst(2), 'UP'))  goto 800
	if (equal (tknlst(2), 'DOWN'))  goto 1000

 100	call out (shld01,0)			!get the switch
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	if (equal (tknlst(1), 'UP'))  goto 800
	if (equal (tknlst(1), 'DOWN'))  goto 1000
	if (equal (tknlst(1), 'TRANSFER'))  goto 200
	goto 100

*.......Transfer energy between shields and ship (engines)

 200	if (typlst(2) .eq. KINT)  goto 400	!amount of energy to transfer already given?
 300	call out (shld02,0)
	call gtkn
	if (typlst(1) .ne. KINT)  return
	senrgy = vallst(1) * 10
	goto 600
 400	senrgy = vallst(2) * 10
	goto 600
 500	if (typlst(3) .ne. KINT)  goto 300
	senrgy = vallst(3) * 10

*	Is the specified energy transfer reasonable?

 600	senrgy = min0 (senrgy, (1000 - shpcon(who,KSSHPC)) * 25)
	if (senrgy .lt. shpcon(who,KSNRGY))  goto 700
	call out (shld03,0)
	call gtkn
	if (equal (tknlst(1), 'YES'))  goto 700
	call out (shld04,1)
	return

*	Make energy transfer

 700	if ((-1 * senrgy) .gt. (shpcon(who,KSSHPC) * 25)) 
     +	senrgy = -25 * shpcon(who,KSSHPC)
	if ((shpcon(who,KSNRGY) - senrgy) .gt. 50000) 
     +	senrgy = -(50000-shpcon(who,KSNRGY))
	shpcon(who,KSSHPC) = shpcon(who,KSSHPC) + (senrgy / 25)
	shpcon(who,KSNRGY) = shpcon(who,KSNRGY) - senrgy
	call out (shld05,1)
	if (shpcon(who,KSSHPC) .le. 0)  shpcon(who,KSHCON) = -1
	if (shpcon(who,KSNRGY) .lt. 10000)  shpcon(who,KSPCON) = YELLOW
	if (shpcon(who,KSNRGY) .ge. 10000)  shpcon(who,KSPCON) = GREEN
	return

*.......Raise deflector shields if not critically damaged
*.......(Costs 100 units of ship energy)

 800	if (shpdam(who,KDSHLD) .gt. KCRIT)  goto 1100
	shpcon(who,KSHCON) = 1
	shpcon(who,KSNRGY) = max0 (shpcon(who,KSNRGY) - 1000 , 0 )
	call out (shld06,1)
	if (trstat(who) .ne. 0)  call trcoff (who)	!cut tractor beam?
	if (shpcon(who,KSNRGY) .gt. 0)  goto 900
	call out (shld07,1)
 900	return

*.......Lower deflector shields

1000	shpcon(who,KSHCON) = -1
	call out (shld08,1)
	return

1100	call out (shld09,1)
	return

	end
