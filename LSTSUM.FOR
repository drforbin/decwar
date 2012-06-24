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


C	LSTSUM -- List summary line

	subroutine LSTSUM (n, str, f)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	integer str(1)

	if (n .eq. 0)  return
	call odec (n,3)
	if ((f .and. KNOBIT) .ne. 0)  call out (known,0)  !" known"
	call space
	call out (str,0)  ;  if (n .ne. 1)  call outc('s')
	if (oflg .eq. SHORT)  goto 100
	msg = locf(inrang)				!" in range"
	if ((f .and. ISRBIT) .ne. 0)  msg = locf(inspra)  !" in specified range"
	if ((f .and. IGMBIT) .ne. 0)  msg = locf(ingame)  !" in game"
	call out (msg,0)
  100	call crlf
	n = 0
	return

	end
