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


C	This routine searches for and prints out messages received by
C	the ship's sub-space radio.

	subroutine OUTMSG
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /omlocl/ msg(16)

 100	dbits = 0  ;  dispfr = 0
	if (msgflg(who) .eq. 0)  return		!any more messages?

	call getmsg (who, msg)			!get another message
	if (dispfr .eq. 0)  goto 400		!message not from player
	if ((gagmsg .and. bits(mod(dispfr,100))) .ne. 0)  goto 100
	call out (mess01,0)			!message from ...
	call odisp (dispfr, 1)
	call out (mess02,0)

	k = 1
	do 300 i = 1, KNPLAY			!message to ...
	  if ((dbits .and. k) .eq. 0)  goto 200
	  call out2c (names(i,3))
 200	  k = k * 2
 300	continue

*.......Print out message

	call crlf
 400	call out (msg,1)
	goto 100

	end
