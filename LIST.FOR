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


C	LIST -- List various info (location, shield percent, number of
C	builds) on ships, bases, and planets.

	subroutine LIST
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	include 'lstvar'

	cmd = LSTCMD			!command is LIST
	goto 100

	entry SUMMAR			!command is SUMMARY
	cmd = SUMCMD
	goto 100

	entry BASES
	cmd = BASCMD			!command is BASES
	goto 100

	entry PLANET
	cmd = PLNCMD			!command is PLANET
	goto 100

	entry TARGET
	cmd = TARCMD			!command is TARGET

 100	call blkset (lstfz, 0, locf(lstlz)-locf(lstfz)+1)
	svpos = shpcon(who,KVPOS)  ;  shpos = shpcon(who,KHPOS)

	call crlf

	p = 1  ;  n = 0
 200	if (p .gt. KMAXTK) return
	if (typlst(p) .eq. KEOL)  goto 300
	call lstscn ($400)		!scan group from input line
	call lstflg ($200)		!set list flags according to group bits
	n = n + 1
	goto 200

 300	if (n .ne. 0)  call lstout	!output flagged items
 400	return

	end
