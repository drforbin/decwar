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


C	This routine drives the WARP and IMPULSE engine movement.
C	The desired destination coordinates are processed, the path
C	searched for collisions, and the energy consumption computed.

	subroutine MOVE (*)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /chkout/ V1, H1, V2, H2, dcode, disV, disH
	real d, disV, disH

	iflg = 0					!warp engines
	if (shpdam(who,KDWARP) .lt. KCRIT)  goto 100	!warp engines kaput?
	call out (wrpdam,1)
	return 1

	entry IMPULS (*)
	iflg = 1					!impulse engines
	if (shpdam(who,KDIMP) .lt. KCRIT)  goto 100	!impulse engines kaput?
	call out (impdam,1)
	return 1

 100	v = etim(tim0) + (slwest * 1000) + 1000
	d = 0.0    					!initialize random movement
	randam = iran (4000)				!penalty for going too fast
	time = randam / 30

*.......Get proposed movement

	tem = locate(2)
 200	if (tem .lt. 0)  return 1
	if (tem .ne. 0)  goto 300
	tem = reloc(2)
	goto 200

*.......Convert to relative coordinates

 300	iV = vallst(1) - shpcon(who,KVPOS)
	iH = vallst(2) - shpcon(who,KHPOS)
	if (.not. ((iV .eq. 0) .and. (iH .eq. 0)))  goto 700
	if (oflg)  400, 400, 500
 400	call out (error2,1)  ;  goto 600
 500	call out (error1,1)
 600	if (reloc(2) .lt. 0)  return 1			!aborted move
	goto 300   					!try again

 700	shpcon(who,KSPCON) = GREEN			!condition green
	docked(who) = .FALSE.
	ia = max0 (iabs(iV), iabs(iH))			!how far to go?
	if (shpdam(who,KDCOMP) .ge. KCRIT)  d = (ran(0) - 0.5) / 2.0	!add deflection if computer damaged
	if (iflg .eq. 1)  goto 800			!impulse
	if (ia .gt. 6)  goto 1300			!TOO fast!
	if ((shpdam(who,KDWARP) .gt. 0) .and. (ia .gt. 3))  goto 900
	if (ia .gt. 4)  goto 1700
	goto 1900

*.......Impulse movement

 800	if (ia .eq. 1)  goto 1900			!going only 1 sector?
	if (oflg .eq. long)  call out (move1A,0)
	call out (move1B,1)
	return 1

 900	if (oflg)  1000, 1000, 1100			!warp engines damaged
1000	call out (move2S,1)  ;  goto 1200
1100	call out (move2L,1)
1200	return 1

1300	if (oflg)  1400, 1400, 1500			!trying to move > 6 sectors
1400	call out (move3S, 0)  ;  goto 1600
1500	call out (move3L,0)
1600	if (shpdam(who,KDWARP) .gt. 0)  call out2c ('3.')
	if (shpdam(who,KDWARP) .eq. 0)  call out2c ('6.')
	return 1

*.......warp 5 or 6 -- might work

1700	if (oflg .eq. long)   call out (engoff,0)	!warning of warp factor
	if (oflg .ne. short)  call out (move5L,1)
	if (oflg .eq. short)  call out (move5S,1)
	tran = iran (100)
	if (.not. (((tran .gt. 80) .and. (ia .ge. 6)) .or. 
     +	((tran .gt. 90) .and. (ia .eq. 5))))  goto 1900	!engines blown?

*.......Warp engines damaged by overheating (ie speeding)

	call out (move06,0)
	call oflt (randam, 3)
	call out (move08,1)
	if (oflg .eq. short)  goto 1800
	call out (move09,0)
	call oflt (time, 2)
	call out (strdat,1)
1800	shpdam(who,KDWARP) = shpdam(who,KDWARP) + randam

*.......Check path for obstacles, move to last empty sector

1900	call check (shpcon(who,KVPOS), shpcon(who,KHPOS), iV, iH, ia, d)
	ied = 40 * ia * ia				!compute energy consumption
	if (shpcon(who,KSHCON) .gt. 0)  ied = 2 * ied
	if (trstat(who) .ne. 0)  ied = 3 * ied
	shpcon(who,KSNRGY) = shpcon(who,KSNRGY) - ied

*	move ship

	if ((V1 .eq. shpcon(who,KVPOS)) .and. 
     +	(H1 .eq. shpcon(who,KHPOS)))  goto 2000
	indxto = (v1-1)*25 + (h1 - 1)/3 + 1
	indxfm = (shpcon(who, kvpos) - 1)*25 + (shpcon(who, khpos) - 1)/3 + 1
	call lock (board(indxto))
	if (lkfail) return 1
	if (indxto .eq. indxfm) goto 333
	call lock (board(indxfm))
	if (.not. lkfail) goto 333
		call unlock (board(indxto))
		return 1		! failed to move
333	call setdsp (shpcon(who,KVPOS), shpcon(who,KHPOS), 0)
	call setdsp (V1, H1, (team * 100) + who)
	shpcon(who,KVPOS) = V1
	shpcon(who,KHPOS) = H1
	if (indxto .ne. indxfm) call unlock (board(indxfm))
	call unlock (board(indxto))
	if (trstat(who) .eq. 0)  goto 2000
	tl = disp(shpcon(trstat(who),KVPOS),shpcon(trstat(who),KHPOS))
	call setdsp (V1-int(disV), H1-int(disH), tl)
	call setdsp (shpcon(trstat(who),KVPOS), 
     +	shpcon(trstat(who),KHPOS), 0)
	shpcon(trstat(who),KVPOS) = V1 - disV
	shpcon(trstat(who),KHPOS) = H1 - disH

2000	if (dcode .ne. 0)  call out (move10,1)		!run into anything?

*.......Compute pause time for move

	ptime = v - etim(tim0)
	return

	end
