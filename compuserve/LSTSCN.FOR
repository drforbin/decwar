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


C	LSTSCN -- Scan input group for LIST, SUMMARY, TARGETS, BASES,
C	and PLANETS commands.

	subroutine LSTSCN (*)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	include 'lstvar/nolist'

	goto (50, 100, 200, 300)  cmd

C	LIST command
	omask = SHPBIT .or. BASBIT .or. PLNBIT
	smask = FEDBIT .or. EMPBIT .or. NEUBIT .or. ROMBIT
	lmask = LSTBIT
	range = MAXINT
	goto 400

C	SUMMARY command
  50	omask = SHPBIT .or. BASBIT .or. PLNBIT
	smask = FEDBIT .or. EMPBIT .or. NEUBIT .or. ROMBIT
	lmask = SUMBIT
	range = MAXINT
	goto 400

C	BASES command
 100	omask = BASBIT
	smask = sbits(team)
	lmask = LSTBIT .or. SUMBIT
	range = MAXINT
	goto 400

C	PLANETS command
 200	omask = PLNBIT
	smask = FEDBIT .or. EMPBIT .or. NEUBIT
	lmask = LSTBIT
	range = KRANGE
	goto 400

C	TARGETS command
 300	omask = SHPBIT .or. BASBIT .or. PLNBIT
	smask = sbits(3-team) .or. ROMBIT
	lmask = LSTBIT
	range = KRANGE

 400	imask = 0		!nothing scanned yet
	ships = 0		!no ships yet
	vpos = 0  ;  hpos = 0	!no coordinate scanned

	op = p			!remember where we started the scan
 500	p = p + 1
	if (p .gt. KMAXTK) return 1	! prevent "Data out of bounds"

C.......Check for end of group
	if (typlst(p) .eq. KEOL)  goto 600
	token = tknlst(p)
	if (equal(token, '&'))  goto 600
	if (.not. equal(token, 'AND'))  goto 800

C.......End of group; check for any last minute syntax errors
 600	if (p .ne. op+1)  return
	if (op .eq. 1)  goto 700
	call out (lsts01,1)		!"Null group illegal"
	return 1

C.......Lone command (no modifiers).  In this case, automatically
C	include a summary, unless the command was LIST.
 700	continue
*	if (cmd .ne. LSTCMD)  lmask = lmask .or. SUMBIT
	return

C.......Check for coordinate and range
 800	if ((typlst(p) .eq. KINT) .and. (typlst(p+1) .eq. KINT)) 
     +	goto 2200
						!coordinate
	if (typlst(p) .eq. KINT)  goto 2900	!range
	if (typlst(p) .ne. KALF)  goto 1400

C.......Check for ship name (Romulan counts as ship name)
	if ((cmd .ne. LSTCMD) .and. (cmd .ne. TARCMD))  goto 1000
	do 900 i = 1, KNPLAY
	  if (equal(token, names(i,1)))  goto 1800 !ship name
 900	continue
	if (equal(token, 'ROMULAN'))  goto 1700

C.......Check for other keywords
1000	if ((cmd .ne. LSTCMD) .and. (cmd .ne. SUMCMD) .and. 
     +	(cmd .ne. TARCMD))  goto 1100
	if (equal(token, 'SHIPS'))    goto 1900
	if (equal(token, 'BASES'))    goto 2000
	if (equal(token, 'PLANETS'))  goto 2100
	if (equal(token, 'PORTS'))    goto 2150

1100	if (cmd .eq. TARCMD)  goto 1200
	if (equal(token, 'FRIENDLY'))    goto 2300
	if (equal(token, 'ENEMY'))       goto 2400
	if (equal(token, 'TARGETS'))     goto 2400
	if (equal(token, 'FEDERATION'))  goto 2500
	if (equal(token, 'HUMAN'))       goto 2500
	if (equal(token, 'EMPIRE'))      goto 2600
	if (equal(token, 'KLINGON'))     goto 2600

1200	if ((cmd .eq. BASCMD) .or. (cmd .eq. TARCMD))  goto 1300
	if (equal(token, 'NEUTRAL'))   goto 2700
	if (equal(token, 'CAPTURED'))  goto 2800

1300	if (equal(token, 'ALL'))  goto 2850	!legal for any command

	if ((cmd .ne. SUMCMD) .and. equal(token, 'CLOSEST'))  goto 3000

	if ((cmd .ne. LSTCMD) .and. (cmd .ne. SUMCMD) .and. 
     +	equal(token, 'LIST'))  goto 3100
	if ((cmd .ne. SUMCMD) .and. (equal(token, 'SUMMARY')))  goto 3200

1400	call out (lsts02,0)  ;  goto 1600	!"Illegal keyword"
1500	call out (lsts03,0)			!"Syntax error near keyword "
1600	call outw (token)  ;  call crlf
	return 1

C----------------------------------------------------------------------
C		Object selection
C----------------------------------------------------------------------

C.......Romulan
1700	if ((imask .and. ROMBIT) .ne. 0)  goto 1500	!Romulan already given
	imask = imask .or. ROMBIT .or. NAMBIT
	omask = SHPBIT
	goto 500

C.......ship name
1800	if ((imask .and. .not. (NAMBIT .or. ROMBIT)) .ne. 0)  goto 1500
	imask = imask .or. NAMBIT
	if ((ship .and. bits(i)) .ne. 0)  goto 1500	!name already given
	ships = ships .or. bits(i)
	omask = SHPBIT
	goto 500

C.......SHIP
1900	if ((imask .and. (OBJMSK .or. NEUBIT .or. CAPBIT)) .ne. 0) 
     +	goto 1500
	imask = imask .or. SHPBIT
	omask = SHPBIT
	smask = smask .and. (FEDBIT .or. EMPBIT .or. ROMBIT)
	goto 500

C.......BASE
2000	if ((imask .and. (OBJMSK .or. NEUBIT .or. CAPBIT)) .ne. 0) 
     +	goto 1500
	imask = imask .or. BASBIT
	omask = BASBIT
	smask = smask .and. (FEDBIT .or. EMPBIT)
	goto 500

C.......PLANET
2100	if ((imask .and. OBJMSK) .ne. 0)  goto 1500
	imask = imask .or. PLNBIT
	omask = PLNBIT
	smask = smask .and. (FEDBIT .or. EMPBIT .or. NEUBIT)
	goto 500

C.......PORT
2150	if (who .eq. 0)  goto 1500		!Pre-game?
	if ((imask .and. OBJMSK) .ne. 0)  goto 1500
	imask = imask .or. PRTBIT
	if ((imask .and. NEUBIT) .eq. 0)  omask = BASBIT .or. PLNBIT
	if ((imask .and. SIDMSK) .eq. 0)  smask = sbits(team) .or. NEUBIT
	smask = smask .and. .not. ROMBIT
	goto 500

C.......Coordinate
2200	if (cmd .eq. SUMCMD)  goto 1500
	if ((imask .and. (OBJMSK .or. SIDMSK .or. ALLBIT .or. RNGBIT .or. 
     +	CLSBIT .or. OUTMSK)) .ne. 0)  goto 1500
	imask = imask .or. CRDBIT
	Vpos = vallst(p)  ;  Hpos = vallst(p+1)
	p = p + 1
	if (p .gt. KMAXTK) return  1
	if (ingal(Vpos,Hpos))  goto 500
	call out (lsts04,0)			!"Illegal coordinate"
	call prloc (Vpos, Hpos, 1, 0, KABS, SHORT)
	return 1

C----------------------------------------------------------------------
C		Side and range selection
C----------------------------------------------------------------------

C.......Friendly
2300	if (who .eq. 0)  goto 1500		!Pre-game?
	smask = smask .and. .not. ROMBIT
	if (team .eq. 1)  2500, 2600

C.......Enemy
2400	if (who .eq. 0)  goto 1500		!Pre-game?
	smask = smask .or. ROMBIT
	if (team .eq. 1)  2600, 2500

C.......Federation, Human
2500	if ((imask .and. (SIDMSK .or. CRDBIT)) .ne. 0)  goto 1500
	imask = imask .or. FEDBIT
	smask = (smask .and. ROMBIT) .or. FEDBIT
	goto 500

C.......Empire, Klingon
2600	if ((imask .and. (SIDMSK .or. CRDBIT)) .ne. 0)  goto 1500
	imask = imask .or. EMPBIT
	smask = (smask .and. ROMBIT) .or. EMPBIT
	goto 500

C.......Neutral
2700	if ((imask .and. (SIDMSK .or. (OBJMSK .and. .not. PLNBIT))) 
     +	.ne. 0)  goto 1500
	imask = imask .or. NEUBIT
	smask = NEUBIT
	omask = PLNBIT
	goto 500

C.......Captured
2800	if ((imask .and. (SIDMSK .or. (OBJMSK .and. .not. PLNBIT))) 
     +	.ne. 0)  goto 1500
	imask = imask .or. CAPBIT
	smask = FEDBIT .or. EMPBIT
	omask = PLNBIT
	goto 500

C.......ALL
2850	if ((imask .and. (ALLBIT .or. CRDBIT)) .ne. 0)  goto 1500
	imask = imask .or. ALLBIT
	if (((imask .and. SIDMSK) .eq. 0) .and. (cmd .ne. TARCMD)) 
     +	smask = FEDBIT .or. EMPBIT .or. NEUBIT .or. ROMBIT
	if ((imask .and. RNGBIT) .eq. 0)  range = MAXINT
	goto 500

C.......Range
2900	if (who .eq. 0)  goto 1500		!Pre-game?
	if ((imask .and. (RNGBIT .or. CRDBIT)) .ne. 0)  goto 1500
	imask = imask .or. RNGBIT
	range = vallst(p)
	if (range .lt. 1)  goto 1500
	goto 500

C.......Closest
3000	if (who .eq. 0)  goto 1500		!Pre-game?
	if ((imask .and. (CLSBIT .or. CRDBIT .or. OUTMSK)) .ne. 0) 
     +	goto 1500
	imask = imask .or. CLSBIT
	lmask = LSTBIT
	if ((imask .and. RNGBIT) .eq. 0)  range = MAXINT
	goto 500

C----------------------------------------------------------------------
C		List and summary selection
C----------------------------------------------------------------------

C.......LIST
3100	if ((imask .and. (OUTMSK .or. CRDBIT .or. CLSBIT .or. NAMBIT)) 
     +	.ne. 0)  goto 1500
	imask = imask .or. LSTBIT
	lmask = lmask .or. LSTBIT
	if ((cmd .ne. SUMCMD) .and. ((imask .and. SUMBIT) .eq. 0)) 
     +	lmask = LSTBIT
	goto 500

C.......SUMMARY
3200	if ((imask .and. (OUTMSK .or. CRDBIT .or. CLSBIT .or. NAMBIT)) 
     +	.ne. 0)  goto 1500
	imask = imask .or. SUMBIT
	if ((imask .and. RNGBIT) .eq. 0)  range = MAXINT
	lmask = lmask .or. SUMBIT
	if ((cmd .ne. LSTCMD) .and. ((imask .and. LSTBIT) .eq. 0)) 
     +	lmask = SUMBIT
	goto 500

	end
