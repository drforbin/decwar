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


C	This routine is called whenever a base or planet is destroyed
C	to see if the game is over. (all the planets gone, and one
C	side's bases).  If so, the appropriate message is printed out
C	and the job is returned to monitor level.

	subroutine ENDGAM
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /local/ dummy(locsiz)
	common /polocl/ total(4)
	external monit

	if (ENDFLG)  goto 100			!game already over?
	if (nplnet .gt. 0)  return		!any planets left?
	if (min0 (nbase(1), nbase(2)) .gt. 0)  return	!any bases left?

*.......The game is over!!

	call kilhgh
	endflg = .true.

 100	call out (endgm0,1)
	if (max0 (nplnet, nbase(1), nbase(2)) .ne. 0) goto 300
		call out (endgm1, 1)
		endflg = -2			! -2 implies total destruction
300	if (nbase(1) .eq. 0)  call out (endgm3,1)
	if (nbase(2) .eq. 0)  call out (endgm4,1)
	if ((team .eq. 1) .and. (nbase(1) .eq. 0))  call out (endgm5,1)
	if ((team .eq. 1) .and. (nbase(2) .eq. 0))  call out (endgm6,1)
	if ((team .eq. 2) .and. (nbase(1) .eq. 0))  call out (endgm7,1)
	if ((team .eq. 2) .and. (nbase(2) .eq. 0))  call out (endgm8,1)
	if (who .eq. 0)  goto 400	!'player' from restart loop.
	txppn = job(who, kppn)
	txnm1 = job(who, knam1)
	txnm2 = job(who, knam2)
	txsh1 = names (who, 1)
	txsh2 = names (who, 2)
	whowon = 1
	if (nbase(1) .lt. nbase(2)) whowon = 2
	txwhy  = 1			! assume this player won
	if (team .ne. whowon) txwhy = 0	! not same team, so lost!
	if (endflg .eq. -2) txwhy = 0	! or everyone loses!
	txtim = etim(job(who, KJOBTM))
	txtem = team - 1
	call points (.TRUE.)
	txtot = total (1)
	call updsta (txppn,txnm1,txnm2,txsh1,txsh2,txtot,txtim,txwhy, 
     +		txtem, who)
	call free (who)
	who = 0
c--	call shosta(0)			! show current standings
 400	call exit

	end
