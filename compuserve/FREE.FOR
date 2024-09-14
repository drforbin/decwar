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


C	This routine is called whenever a player dies, quits the game,
C	or temporarily CTL-C's out.  The appropriate parts of the high
C	segment are saved in the low segment, and zeroed out for use by
C	others.  If a restart is made after a ^C, the information is
C	passed back up into the high segment, and the player is again
C	active.  Any hit or radio messages present before the ^C
C	will be lost.

	subroutine FREE (snum)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	common /frlocl/ tship, tshpco(10), tshpda(KNDEV), tjob(KNJBST), 
     +	dum(16)

	if (alive(snum) .gt. 0)  return

11	call lock (frelok)
	if (lkfail) goto 11		! we gotta lock it up!
	call setdsp (shpcon(snum,KVPOS), shpcon(snum,KHPOS), 0)
	tteam = 1  ;  if (snum .gt. (KNPLAY / 2))  tteam = 2
	tship = (tteam * 100) + snum
	numply = numply - 1
	if ((numply .eq. 0) .and. .not. ENDFLG)  hitime = 
     +	daytim(d) + 300000		!preserve high segment for 5 minutes
	numsid(tteam) = numsid(tteam) - 1
	if (trstat(snum) .ne. 0)  call trcoff (snum)

C.......Record the player in the killed player queue, along with the
C.......time when he will again be eligible to play.

	call kqsrch (job(snum,KTTYN), job(snum,KJOB), job(snum,KPPN), 
     +	kindex)
	if (kindex .ne. 0)  goto 100
	if (nkill .lt. KQLEN) nkill = nkill + 1
	kilndx = kilndx + 1
	if (kilndx .gt. KQLEN)   kilndx = 1
	kindex = kilndx
 100	kilque(kindex,1) = job(snum,KJOB)
	kilque(kindex,2) = job(snum,KPPN)
	kilque(kindex,3) = job(snum,KTTYN)
	kilque(kindex,4) = daytim(d)
	kilque(kindex,5) = tteam .or. snum*262144

*.......Move ship information into low segment arrays
*.......Clear out high segment

	do 200 i= 1, KNJBST
	  tjob(i) = job(snum,i)
	  job(snum,i) = 0
 200	continue

	do 300 i = 1, 10
	  tshpco(i) = shpcon(snum,i)
 300	continue
	shpcon(snum,KVPOS) = 0
	shpcon(snum,KHPOS) = 0
	shpcon(snum,KSNRGY) = 0

	do 400 i = 1, KNDEV
	  tshpda(i) = shpdam(snum,i)
 400	continue

 500	if (hitflg(snum) .le. 0)  goto 600	!clear out hit messages
	call gethit (snum)
	goto 500
 600	if (msgflg(snum) .le. 0)  goto 700	!clear out radio messages
	call getmsg (snum, dum)
	goto 600
 700	dbits = 0  ;  dispfr = 0
	call blkset (iwhat, 0, 17)
	alive(snum) = 1
	call unlock (frelok)
	return

*.......Continue game after ^C

	entry RSTART (snum)

 800	if (shpcon(snum,KVPOS) .ne. 0)  goto 1100	!tship in use
	if (disp(tshpco(KVPOS),tshpco(KHPOS)) .gt. 0) 
     +	goto 1200   !  spot on board is taken
801	call lock (frelok,'RSTART')
	if (lkfail) goto 801			! keep trying!
	alive(snum) = .TRUE.
	numply = numply + 1
	tteam = (snum - 1) / (KNPLAY / 2) + 1
	numsid(tteam) = numsid(tteam) + 1

*.......Move ship information back into high segment

	do 900 i = 1, 10
	  shpcon(snum,i) = tshpco(i)
 900	continue
	do 1000 i = 1, KNDEV
	  shpdam(snum,i) = tshpda(i)
1000	continue

	call jobsta ( 
     +		job(snum,KJOB),
     +		dummy,
     +		dummy,
     +		job(snum,KPPN),
     +		job(snum,KTTYN),
     +		job(snum,KTTYSP)
     +		    )
	job(snum,KNAM1) = tjob(KNAM1)
	job(snum,KNAM2) = tjob(KNAM2)
	job(snum,KTTYTP) = tjob(KTTYTP)
	job(snum,KJOBTM) = tjob(KJOBTM)
	job(snum,KRUNTM) = tjob(KRUNTM)
	call setdsp (tshpco(KVPOS), tshpco(KHPOS), tship)
	call unlock (frelok)
	return

*.......Error messages

1100	call out (free01,1)			!Ship in use
	call monit
	goto 800

1200	call out (free02,1)			!Spot on board taken
	call monit
	goto 800

	end
