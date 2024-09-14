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


C	This routine is used to send messages between ships using the

C	sub-space radio.

	subroutine TELL
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	dimension local (17)

	sntrom = .false.			! .true. if "tel rom; xxx"
	if (.not. player) goto 1150		! is the Romulan speaking?
	rmspk = .false.				! no.

*.......Radio operational?

	if (shpdam(who,KDRAD) .lt. KCRIT)  goto 200
	call out (tell01,1)
	return

*.......Destination ship or group already specified?

 200	nomsg = nomsg .and. (.not. bits(who))	!turn radio on
	p = 2
	if (ntok .gt. 1)  goto 300

*.......Get destination ship or group name

	call out (tell02,0)
	call gtkn
	p = 1
	if (typlst(1) .eq. KEOL)  return

*.......Analyze input string

 300	dbits = 0
	do 1100 i = p, ntok
	  if (equal (tknlst (i), 'ROMULAN')) goto 950
*.......Trying to send junk messages using ALTMODE?

		if (.not. RPTFLG)  goto 100
		call out (tell09,1)
		return

100	  do 400 j = 1, KNPLAY			!valid ship name?
	    if (equal (tknlst(i), names(j,1)))  goto 1000
 400	  continue
	  gm = .false.
	  do 500 j = 1, KNGRP			!valid group name?
	    if (group(j,1) .eq. 0)  goto 500
	    if (.not. equal(tknlst(i), group(j,1)))  goto 500
	    if (gm) goto 800
	    gm = .true.  ;  gbits = group(j,2)
 500	  continue

	  if (.not. gm)  goto 700		!unrecognized ship or group name?
	  do 600 j = 1, KNPLAY			!player in game?
	    if (.not. alive(j))  gbits = gbits .and. -(bits(j) + 1)
 600	  continue
	  dbits = dbits .or. gbits		!save valid ships
	  goto 1100
 700	  call out (tell03,0)			!unrecognized player or name
	  goto 900
 800	  call out (tell04,0)			!ambiguous group name
 900	  call outw (tknlst(i))  ;  call crlf
	  goto 1100

950	  if (.not. rom) goto 955		! is the Romulan dead?
	  svdb = dbits				! preserve destination bits
	  call romspk (local)			! speak to the player
	  call makmsg (local)
	  sntrom = .true.
	  dbits = svdb
	  if (iran (4) .gt. 1) goto 1100	! 25% chance Romulan comes to him
		ph = shpcon (who, khpos)	! find vacant spot neareby
		pv = shpcon (who, kvpos)
		ix = iran(10) - 5
		do 951 ir = ix, 10
		  do 951 jr = ix, 10
			if (.not. ingal (pv+jr, ph+ir)) goto 951
			if (disp (pv+jr, ph+ir) .ne. 0) goto 951
			call setdsp (locr(kvpos), locr(khpos), 0)
			locr(khpos) = ph+ir
			locr(kvpos) = pv+jr
			call setdsp (locr(kvpos), locr(khpos), dxrom*100)
			goto 1100
951		continue
		goto 1100			! no empty space????

955		call out (tell07, 0)		! "can't raise the "
		call out ('Romulan', 1)
		goto 1100


1000	  dbits = dbits .or. bits(j)		!add player to message list
	  if (j .eq. who)  call out (tell05,1)	!self excluded!!
1100	continue
	goto 1190

1150	rmspk = .true.			! the Romulan speaks!
	call romspk(local)		! set up target population & msg


*.......Search message list for problems ....

1190	mask = 1
	do 1500 i = 1, KNPLAY
	  iship = DXFSHP * 100 + i
	  if ((dbits .and. mask) .eq. 0)  goto 1400	!player on message list?
	  if (shpdam(i,KDRAD) .ge. KCRIT)  goto 1300	!player's radio broken?
	  if (alive(i))  goto 1200
	  if (rmspk) goto 1191
		call out (tell06, 0)
		call odisp (iship, 0)
		call crlf
1191	  dbits = dbits .and. (.not. mask)
	  goto 1400
1200	  if ((nomsg .and. mask) .eq. 0)  goto 1400	!radio off?
1300	  if (rmspk) goto 1301
		call out (tell07, 0)
		call odisp (iship,0)  ;  call crlf
1301	  dbits = dbits .and. (.not. mask)
1400	  mask = mask * 2				!update mask
1500	continue

	if (player) 
     +	dbits = dbits .and. (.not. bits(who))		!remove self
	gagmsg = gagmsg .and. (.not. dbits)		!update individual gag
	if (dbits .ne. 0)  goto 1600			!anyone to send to?
	if (.not. rmspk .and. .not. sntrom) call out (tell08, 1)
	return

*.......Send message to designated players

1600	if (rmspk) goto 1650
	dispfr = who + (team * 100)
	call makmsg
	call crlf
	return

1650	call makmsg (local)		! store the Romulan's message
	return

	end
