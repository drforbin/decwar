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


C	This routine prints out useful information concerning the
C	elapsed time and run time of the game, job, and ship involved.

	subroutine TIME
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	call out (time01,0)		!total elapsed time of game
	call otim (etim(tim0))

	if (who .eq. 0)  goto 100	!in Pre-game section?
	call out (time02,0)		!elapsed time of ship
	call otim (etim(job(who,KJOBTM)))

	call out (time03,0)		!run time for this ship
	call otim (runtim(d) - job(who,KRUNTM))

 100	call out (time04,0)		!total run time for this job
	call otim (runtim(d))

	call out (time05,0)		!present time of day
	call otim (daytim(d))
	call crlf
	return

	end
