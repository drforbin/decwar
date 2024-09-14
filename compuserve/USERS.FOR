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


C	This routine prints out information about the currently active
C	captains.  The information includes their ship name and their
C	own name; plus their PPN, TTY number, and TTY speed.  If the
C	password is set, one also gets their present location.

	subroutine USERS
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /local/ line(90)

*.......Set up output table format

	call crlf
	if (oflg .ne. long)  goto 100
	call out (users1,0)
	if (PASFLG) call out (users2,0)
	call crlf

*.......Print out player information

 100	do 700 i = 1, KNPLAY
	  if (i .eq. (KNPLAY/2)+1)  call out (users5,1)
	  if (.not. alive(i))  goto 700
c--	  if (oflg)  200, 300, 400
c-- 200	  num = 2  ;  goto 500
c-- 300	  num = 4  ;  goto 500
 400	  num = 6
 500	  call stat (num, i+0)
	  if (.not. PASFLG) goto 600
	  call spaces (3)
	  call prloc(shpcon(i,KVPOS), shpcon(i,KHPOS), 0, 2, ocflg, SHORT)
 600	  call crlf
 700	continue
	return

	end
