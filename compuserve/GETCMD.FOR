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


C	This routine processes command strings, and also monitors the
C	hit and message queues between commands.

	subroutine GETCMD (cmd)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /local/ dummy(locsiz)
	common /polocl/ total(4)
	external monit

	call ttyon
	if (hitflg(who) .ne. 0)  call outhit
	call ttyon
	if (msgflg(who) .ne. 0)  call outmsg

	call prgnam ('DECWSL')
	call dmpbuf			!dump output buffer
	call CCTRAP
	if (.not. PASFLG)
     +    call pause (ptime)		!pause (mark) after previous command
	ptime = 0			!assume no pause for next cmd.

 100	call crlf
	call chkseq			! check for active jobs
	if (shpcon(who,KSDAM) .ge. KENDAM)  goto 1100	!ship dead?
	if (shpcon(who,KSNRGY) .le. 0)  goto 1200	!energy gone?
	if (shpcon(who,KSNRGY) .le. 10000)  shpcon(who,KSPCON) = YELLOW	!yellow alert?
	if (shpcon(who,KSPCON) .eq. YELLOW)  call out ("034160703400,0)	!if yellow alert, BEEP!
	call ttyon

	call endgam			!game over?
	CCFLG = .FALSE.
	call prompt  ;  call prgnam ('DECWTI')
	call dmpbuf			!dump output buffer
200	call zaplok			! remove any and all current locks
	if (ccflg .or. hungup) goto 210
	if (input(KCMDTM))  goto 400	!command input?
	if (hungup) goto 500
210	active(who) = 0
	comknt = comknt + 1
	if (comknt .lt. 30 * numply)  goto 300
	comknt = 0
c--	call dship
 300	if ((hitflg(who) .eq. 0) .and. (msgflg(who) .eq. 0))  goto 350
	call ttyon
	if (hitflg(who) .ne. 0)  call outhit
	call ttyon
	if (msgflg(who) .ne. 0)  call outmsg
	goto 100

 350	call endgam  ;  goto 200	!check for end of game

 400	active(who) = 0
	if (hungup) goto 500		! job hung up?
C	if (lofchk(0))	goto 500	! drforbin(merlyn) dump user whose time limit is over
	comknt = comknt + 1
	call gtkn
	if (.not. CCFLG) goto 600	!^C wasn't typed
	if (shpcon(who,KSPCON) .ne. RED) goto 500
	call out (noquit,1)
	call clear
	goto 100

500	tknlst(1) = 'QUIT'		! ^C and hangup forces job to quit
	typlst(1) = kalf
	goto 610

 600	if (typlst(1) .eq. KEOL)  goto 100
610	cmd = 0

	do 700 i = 1, KNCMD		!identify command
	  if (.not. (equal(tknlst(1), isaydo(1,i))))  goto 700
	  if (cmd .ne. 0)  goto 800
	  cmd = i
 700	continue
	if (cmd)  800,900,1300 !will never take the neg branch

 800	call out (ambcom, 0)		!input is ambiguous
	goto 1000

 900	call out (unkcom, 0)		!input is trash!
1000	if (oflg .ne. short)  call out (forhlp, 0)
	call crlf
	goto 100

1100	continue
	txppn = job(who, kppn)
	txnm1 = job(who, knam1)
	txnm2 = job(who, knam2)
	txsh1 = names (who, 1)
	txsh2 = names (who, 2)
	txtim = etim(job(who, KJOBTM))
	txwhy = 0
	txtem = team - 1
	call points (.TRUE.)
	txtot = total (1)
	call updsta (txppn,txnm1,txnm2,txsh1,txsh2,txtot,txtim,txwhy, 
     +	txtem, who)
	call free (who)			!player is dead
c--	call	shosta(0)
	who = 0			! return to DECWAR
	return

1200	call odisp (team*100 + who, 1)	!ship is out of energy
	call out (main02,1)
	goto 1100

1300	call prgnam ('DECWRN')
	return

	end
