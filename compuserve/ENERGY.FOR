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


C	This routine allows ship-to-ship transfer of energy between
C	friendly ships.  There is a 10% loss during the transfer.

	subroutine ENERGY
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	call crlf
	index = 2

*.......Input ship name and energy to transfer

 100	if ((typlst(index) .eq. KALF) .and. (typlst(index+1) .eq. KINT)) 
     +	goto 500
	if (oflg)  200, 200, 300
 200	call out (ener1S, 0)  ;  goto 400
 300	call out (ener1L, 0)
 400	call gtkn
	index = 1
	if (typlst(1) .eq. KEOL)  return
	goto 100

*.......Match input with ship name

 500	do 600 i = 1, KNPLAY
	  if (equal(tknlst(index), names(i,1)))  goto 700
 600	continue
	call out (unkshp,1)		!unknown ship name
	return

*.......Input his own ship name?

 700	if (i .ne. who)  goto 800
	if (oflg .eq. long)  call out (begyrp, 0)
	call out (energ7, 1)
	return

*.......Ship in game?

 800	if (alive(i))  goto 900
	call out (noship,1)		!ship not in game
	return

*.......Attempting to transfer energy to an enemy ship?

 900	dteam = 1  ;  if (i .gt. KNPLAY/2)  dteam = 2
	if (team .eq. dteam)  goto 1000
	call out (energ2,1)
	return

*.......Adjacent to destination ship?

1000	if (ldis(shpcon(who,KVPOS),shpcon(who,KHPOS),shpcon(i,KVPOS), 
     +	shpcon(i,KHPOS),1))  goto 1100
	call out (energ3,1)
	return

*.......Transferring more energy than you possess?

1100	ihita = vallst(index+1) * 10
	if (ihita .lt. shpcon(who,KSNRGY))  goto 1500
	if (oflg)  1200, 1200, 1300
1200	call out (ener4S, 1)  ;  goto 1400
1300	call out (ener4L, 1)
1400	return

*.......Energy transfer negative or equal to zero?

1500	if (ihita .gt. 0)  goto 1600
	if (oflg .eq. long)  call out (energ8, 0)
	call out (energ5,1)
	return

*.......Make energy transfer, inform players

1600	ihita = min0(int(ihita * 0.9), 50000 - shpcon(i,KSNRGY))
	shpcon(who,KSNRGY) = shpcon(who,KSNRGY) - (ihita + (ihita / 9))
	shpcon(i,KSNRGY) = shpcon(i,KSNRGY) + ihita
	call out (energ6,1)		!inform transferring ship
	dispto = i + (dteam * 100)  ;  dispfr = who + (team * 100)
	dbits = bits(i)  ;  iwhat = 12
	call makhit		!inform destination ship
	return

1700	call out ('Sorry, Captain, but the transfer has failed.', 1)
	return
	end
