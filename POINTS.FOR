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


C	This routine itemizes the current point totals.

	subroutine POINTS (DFLG)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /polocl/ total(4), fflg, eflg, rflg, iflg, owidth

	call blkset (total, 0, 4)
	if (DFLG)  goto 500
	fflg = .FALSE.  ;  eflg = .FALSE.
	rflg = .FALSE.  ;  iflg = .FALSE.
	if (ntok .gt. 1)  goto 50
	if (who .ne. 0)  iflg = .TRUE.		!No IFLG option in Pre-game
	if (iflg)  goto 900
	fflg = .TRUE.  ;  eflg = .TRUE.
	rflg = .TRUE.  ;  goto 700

*.......Identify input switches

  50	do 600 i = 2, KMAXTK
	  if (typlst(i) .ne. KALF)  goto 700
	  if (.not. (equal(tknlst(i), 'ME') .or. 
     +	  equal(tknlst(i), 'I')))  goto 100
	  if (who .eq. 0)  goto 100		!No IFLG option in Pre-game
	  iflg = .TRUE.  ;  goto 600
 100	  if (.not. (equal(tknlst(i), federa) .or. 
     +	  equal(tknlst(i), 'HUMANS')))  goto 200
	  fflg = .TRUE.  ;  goto 600
 200	  if (.not. (equal(tknlst(i), 'EMPIRE') .or. 
     +	  equal(tknlst(i), 'KLINGONS')))  goto 300
	  eflg = .TRUE.  ;  goto 600
 300	  if (.not. equal(tknlst(i), 'ROMULANS'))  goto 400
	  rflg = .TRUE.  ;  goto 600
 400	  if (equal (tknlst(i), 'ALL'))  goto 500
	  goto 800
 500	  fflg = .TRUE. ; eflg = .TRUE. ; rflg = .TRUE. ; iflg = .TRUE.
	  if (who .eq. 0)  iflg = .FALSE.	!No IFLG option in Pre-game
 600	continue

 700	if (.not. ROMOPT)  rflg = .FALSE.
	if (fflg .or. eflg .or. rflg .or. iflg)  goto 900

*.......Incorrect input, POINTS aborted

 800	call out (poin04,1)
	return

*.......Print out header for POINTS

 900	call crlf
	if (oflg)  1000, 1100, 1200
C	drforbin mod following lines
1000	call tab (14)  ;  goto 1300		!plus 3
1100	call tab (24)  ;  goto 1300		!plus 1
1200	call tab (31)				!plus 2
1300	if (.not. iflg)  goto 1400
	call space
	call out2w (names(who,1), names(who,2))
	if (oflg .ne. short)  call out2c ('  ')
1400	if (.not. fflg)  goto 1500
	call out (federa,0)
	call space
	if (oflg .ne. short)  call out2c ('  ')
1500	if (.not. eflg)  goto 1600
	call out (empire,0)
	call space
	if (oflg .ne. short)  call out2c ('  ')
1600	if (rflg)  call out (romula,0)
	call crlf

*.......Print out itemized scoring information

	do 3000 i = 1, KNPOIN
	  if (.not. ((iflg .and. (score(i, who) .ne. 0)) .or. (fflg .and. 
     +	  (tmscor(1,i) .ne. 0)) .or. (eflg .and. (tmscor(2,i) .ne. 0))
     +	  .or. (rflg .and. (rsr(i) .ne. 0))))  goto 3000

*       Output the proper title for score breakdown

	  goto (1700,1800,1900,2000,2100,2200,2300,2400) i
1700	  if (oflg .eq. short)  call out (poi11S, 0)
	  if (oflg .ne. short)  call out (poi11L, 0)
	  if (oflg .eq. long)  call tab (26)
	  goto 2500
1800	  if (oflg .eq. short)  call out (poi12S, 0)
	  if (oflg .ne. short)  call out (poi12L, 0)
	  if (oflg .eq. long)  call out (poin22, 0)
	  goto 2500
1900	  if (oflg .eq. short)  call out (poi13S, 0)
	  if (oflg .ne. short)  call out (poi13L, 0)
	  if (oflg .eq. long)  call tab (26)
	  goto 2500
2000	  if (oflg .eq. short)  call out (poi14S, 0)
	  if (oflg .ne. short)  call out (poi14L, 0)
	  if (oflg .eq. long)  call out (poin21, 0)
	  goto 2500
2100	  if (oflg .eq. short)  call out (poi15S, 0)
	  if (oflg .ne. short)  call out (poi15L, 0)
	  if (oflg .eq. long)  call out (poin23, 0)
	  goto 2500
2200	  if (oflg .eq. short)  call out (poi16S, 0)
	  if (oflg .ne. short)  call out (poi16L, 0)
	  if (oflg .eq. long)  call out (poin22, 0)
	  goto 2500
2300	  if (oflg .eq. short)  call out (poi17S, 0)
	  if (oflg .ne. short)  call out (poi17L, 0)
	  if (oflg .eq. long)  call out (poin20, 0)
	  goto 2500
2400	  if (oflg .eq. short)  call out (poi18S, 0)
	  if (oflg .ne. short)  call out (poi18L, 0)
	  if (oflg .eq. long)  call out (poin19, 0)

*.........Print out scores

2500	  if (.not. iflg)  goto 2600
	  call oflt (score(i, who), 11)
	  total(1) = total(1) + score(i, who)
2600	  if (.not. fflg)  goto 2700
	  call oflt (tmscor(1,i), 11)
	  total(2) = total(2) + tmscor(1,i)
2700	  if (.not. eflg)  goto 2800
	  call oflt (tmscor(2,i), 11)
	  total(3) = total(3) + tmscor(2,i)
2800	  if (.not. rflg)  goto 2900
	  call oflt (rsr(i), 11)  ;  total(4) = total(4) + rsr(i)
2900	  call crlf
3000	continue

*.......Print out the total points scored

	if (oflg)  3100, 3200, 3200
3100	call out (poi03S, 0)  ;  goto 3300
3200	call out (poi03L, 0)
	if (oflg .eq. long)  call tab (26)
3300	if (iflg)  call oflt (total(1), 11)
	if (fflg)  call oflt (total(2), 11)
	if (eflg)  call oflt (total(3), 11)
	if (rflg)  call oflt (total(4), 11)
	call crlf

*.......Print out the total number of ships commissioned

	if (.not. (fflg .or. eflg .or. rflg))  goto 4000
	if (oflg)  3400, 3500, 3500
3400	call out (poi07S, 0)  ;  goto 3600
3500	call out (poi07L, 0)
	if (oflg .eq. long)  call tab (24)
3600	owidth = 13  ;  if (oflg .eq. short)  owidth = 11
	if (iflg)  call spaces (owidth)
	if (fflg)  call odec (numshp(1), owidth)
	if (eflg)  call odec (numshp(2), owidth)
	if (rflg)  call odec (numrom, owidth)

*.......Print out the total score / number of players

	if (oflg)  3700, 3800, 3800
3700	call out (poi05S, 0)  ;  goto 3900
3800	call out (poi05L, 0)
	if (oflg .eq. long)  call tab (26)
3900	if (iflg)  call spaces (owidth)
	if (fflg)  call oflt (total(2) / numshp(1), 11)
	if (eflg)  call oflt (total(3) / numshp(2), 11)
	if (rflg)  call oflt (total(4) / numrom, 11)

*.......Print out the total score / number of turns used

4000	if (oflg)  4100, 4200, 4200
4100	call out (poi06S, 0)  ;  goto 4300
4200	call out (poi06L, 0)
	if (oflg .eq. long)  call tab (26)
4300	if (iflg)  call oflt (total(1) / shpcon(who,KNTURN), 11)
	if (fflg)  call oflt (total(2) / tmturn(1), 11)
	if (eflg)  call oflt (total(3) / tmturn(2), 11)
	if (rflg)  call oflt (total(4) / tmturn(3), 11)
	call crlf
	return

	end
