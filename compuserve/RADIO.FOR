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


C	This routine enables the user to stop (or restore) the ability
C	to receive messages from other ships using the sub-space radio.
C	Messages from individual ships may also be gagged.

	subroutine RADIO
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

*.......Get commmand (on, off, gag, or ungag)

	call crlf
	index = 2
	if (typlst(2) .eq. KALF)  goto 200
 100	index = 1
	call out (radio0, 0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	call crlf
 200	if (equal (tknlst(index), 'ON'))   goto 1000
	if (equal (tknlst(index), 'OFF'))  goto 900
	if (.not. (equal(tknlst(index), 'GAG') .or. 
     +	equal(tknlst(index), 'UNGAG')))  goto 100
	gagtyp = 0
	if (equal (tknlst(index), 'UNGAG'))  gagtyp = 1

*.......Gag and Ungag against messages from individual ships

 300	if (typlst(index+1) .eq. KALF)  goto 400!get desired ship name
	call out (radio2,0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	index = 0
	goto 300

 400	do 500 i = 1, KNPLAY			!match input with ship names
	  if (equal (tknlst(index+1), names(i,1)))  goto 600
 500	continue
	call out (unkshp,1)			!unknown ship name
	return

 600	if (i .eq. who)  return			!entered own ship name?
	if (gagtyp .ne. 0)  goto 700		!GAG or UNGAG command?
	gagmsg = gagmsg .or. bits(i)		!GAG command
	call out (radgag, 0)
	goto 800
 700	gagmsg = gagmsg .and. -(bits(i)+1)	!UNGAG command
	call out (radung, 0)
 800	iteam = 1  ;  if (i .gt. KNPLAY/2)  iteam = 2
	call odisp ((iteam * 100) + i, 0)
	call crlf
	return

*.......Turn off radio

 900	nomsg = nomsg .or. bits(who)
	call out (radoff, 1)
	return

*.......Turn on radio

1000	nomsg = nomsg .and. -(bits(who)+1)
	call out (radon0, 1)
	return

	end
