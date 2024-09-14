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


C	LSTFLG -- Set LIST flags
C	Set selection bits in SHPLST, BASLST, and PLNLST according
C	to the masks returned by LSTSCN for the LIST command.

	subroutine LSTFLG (*)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	include 'lstvar/nolist'

	gxf = IRNBIT					!"in range"
	if (range .gt. KGALV)  gxf = IGMBIT		!"in game"
	if ((imask .and. RNGBIT) .ne. 0)  gxf = ISRBIT	!"in specified range"

	grpbts = 0
	if ((smask .ne. sbits(team)) .and. (range .gt. KRANGE) .and. 
     +	(gxf .ne. IGMBIT))  grpbts = KNOBIT

	gxf = gxf .or. lmask

C	---------------------------------------------------------------
	if ((imask .and. CRDBIT) .eq. 0)  goto 1200

C	Specific coordinate was given ---------------------------------

 100	code = disp(Vpos,Hpos)		!display code of object
	object = code/100		!object code
	index = mod(code,100)		!object index
	side = 0			!in case empty, star, or black hole
	d = pdist (Vpos, Hpos, sVpos, sHpos) !distance from ship

	goto (600, 600, 700, 700, 500, 900, 900, 900)  object !E,B,[],(),~~,@,+@,-@
	if (d .gt. KRANGE)  goto 300
	if (cmd .ne. LSTCMD)  goto 1100
 200	call lstobj  ;  return
 300	call out (lstf01,0)	!"Sir, our sensors can't scan as far as"
	call prloc (Vpos, Hpos, 1, 0, KABS, SHORT)
	return

 500	side = 3					!Romulan
	scn = 0
	goto 1000
 600	side = object					!ship
	scn = 0
	goto 1000
 700	if ((omask .and. BASBIT) .eq. 0)  goto 1100
	side = object - 2				!base
	scn = base(index,4,side)
	goto 1000
 900	if ((omask .and. PLNBIT) .eq. 0)  goto 1100
	side = object - 6				!planet
	scn = locpln(index,4)

1000	ctr = 0
	call lstupd (dummy, ctr, scn, dummy)
	if (ctr .ne. 0)  200, 300

C	Specified object was not at coordinate (BASES, PLANETS, or
C	TARGETS command)
1100	if (cmd .eq. BASCMD)  call out (lstf02,0)	!"No base"
	if (cmd .eq. PLNCMD)  call out (lstf03,0)	!"No planet"
	if (cmd .eq. TARCMD)  call out (lstf04,0)	!"No target"
	call prloc (Vpos, Hpos, 1, 0, ocflg, LONG)
	return

C	---------------------------------------------------------------
C	---------------------------------------------------------------
1200	if ((imask .and. NAMBIT) .eq. 0)  goto 2300
	call crlf
	if ((imask .and. ROMBIT) .eq. 0)  goto 1700

C	ROMULAN -------------------------------------------------------

	if (ROMOPT)  goto 1300
	call out (type06,1)	!Romulans are NOT in this game
	goto 1700
1300	if (ROM)  goto 1400
	call out (lstf05,1)	!"The Romulan is dead"
	goto 1700
1400	side = 3  ;  code = 500  ;  object = 5
	Vpos = locr(KVPOS)  ;  Hpos = locr(KHPOS)
	call lstupd (dummy, dummy, -1, dummy)
	call lstobj

C	---------------------------------------------------------------
1700	if (ships .eq. 0)  goto 2200

C	Ship name -----------------------------------------------------

	do 2100 index = 1, KNPLAY
	  if ((ships .and. bits(index)) .eq. 0)  goto 2100	!ship not selected
	  side = 1  ;  if (index .gt. KNPLAY/2)  side = 2
	  object = side
	  code = object * 100 + index
	  if (.not. alive(index))  goto 1800		!ship not in game
	  Vpos = shpcon(index,KVPOS)  ;  Hpos = shpcon(index,KHPOS)
	  if (disp(Vpos,Hpos) .eq. 0)  goto 1800	!dead, but not gone yet
	  call lstupd (dummy, dummy, -1, dummy)
	  call lstobj
	  goto 2100
1800	  call odisp (code,0)
	  call out (' is not in the game',1)
2100	continue

2200	return

C	---------------------------------------------------------------
C	---------------------------------------------------------------
2300	clsest = MAXINT
	if ((omask .and. SHPBIT) .eq. 0)  goto 3000

C	SHIP ----------------------------------------------------------

	if ((smask .and. ROMBIT) .eq. 0)  goto 2600	!Rom not selected
	if (.not. ROM)  goto 2600			!Rom not in game
	Vpos = locr(1)  ;  Hpos = locr(2)  ;  side = 3
	scn = 0						!no scan if out of range enemy
	if ((gxf .and. IGMBIT) .ne. 0)   scn = -1	!unless asking for entire game
	if ((imask .and. CLSBIT) .ne. 0)  scn = 0	!no scan if asking for closest
	call lstupd (romlst, romctr, scn, rxf)

2600	first = 1  ;  last = KNPLAY
	if ((smask .and. FEDBIT) .eq. 0)  first = KNPLAY/2+1	!Fed not selected
	if ((smask .and. EMPBIT) .eq. 0)  last = KNPLAY/2	!Emp not selected
	if (first .gt. last)  goto 3000				!neither; was Rom
	do 2900 i = first, last
	  if (.not. alive(i))  goto 2900			!ship not in game
	  Vpos = shpcon(i,KVPOS)  ;  Hpos = shpcon(i,KHPOS)
	  if (disp(Vpos,Hpos) .eq. 0)  goto 2900		!dead, but not gone yet
	  side = 1  ;  if (i .gt. KNPLAY/2)  side = 2
	  scn = 0				!no scan if out of range enemy
	  if ((imask .and. CLSBIT) .eq. 0)  goto 2700 !~ looking for closest
	  if (i .ne. who)  2800, 2900		!don't include self as closest
2700	  if ((gxf .and. IGMBIT) .ne. 0)  scn = -1	!scan if asking for entire game
2800	  call lstupd (shplst(i), shpctr(side), scn, sxf(side))
2900	continue

C	---------------------------------------------------------------
3000	if ((omask .and. BASBIT) .eq. 0)  goto 3500

C	BASE ----------------------------------------------------------

	first = 1  ;  last = 2
	if ((smask .and. FEDBIT) .eq. 0)  first = 2	!Fed not selected
	if ((smask .and. EMPBIT) .eq. 0)  last = 1	!Emp not selected
	do 3400 side = first, last
	  do 3300 i = 1, KNBASE
	    if (base(i,3,side) .le. 0)  goto 3300	!base is dead
	    Vpos = base(i,KVPOS,side)  ;  Hpos = base(i,KHPOS,side)
	    call lstupd (baslst(i,side), basctr(side), base(i,4,side), 
     +	                bxf(side))
3300	  continue
3400	continue

C	---------------------------------------------------------------
3500	if ((omask .and. PLNBIT) .eq. 0)  goto 3800

C	PLANET --------------------------------------------------------

	if (nplnet .eq. 0)  goto 3800			!no planets left
	do 3700 i = 1, nplnet
	  Vpos = locpln(i,KVPOS)  ;  Hpos = locpln(i,KHPOS)
	  side = dispc(vpos,hpos) - 6
	  if ((smask .and. sbits(side)) .eq. 0)  goto 3700	!wrong side
	  call lstupd (plnlst(i), plnctr, locpln(i,4), pxf(side))
3700	continue

C	---------------------------------------------------------------
3800	if ((imask .and. CLSBIT) .eq. 0)  goto 3900

	Vpos = Vposc  ;  Hpos = Hposc
	imask = imask .and. .not. CLSBIT
	if (clsest .eq. MAXINT)  4000, 100

3900	if ((grpbts .and. (LSTBIT .or. SUMBIT)) .ne. 0)  return
4000	msg = locf(lstf06)				!"Sir, there are no"
	if (oflg .ne. LONG)  msg = locf(lstf07)		!"No"
	call out (msg,0)

	if ((grpbts .and. KNOBIT) .ne. 0)  call out (known,0)	!" known"

	msg = 0
	if (smask .eq. NEUBIT)  msg = locf(lstf08)	!" neutral"
	if (smask .eq. FEDBIT)  msg = locf(lstf09)	!" Federation"
	if (smask .eq. EMPBIT)  msg = locf(lstf10)	!" Empire"
	if ((smask .eq. (FEDBIT .or. EMPBIT)) .and. (omask .eq. PLNBIT)) 
     +	msg = locf(lstf11)				!" captured"
	if (((smask .and. ROMBIT) .ne. 0) .and. (smask .and. NEUBIT) 
     +	.eq. 0)  msg = locf(lstf12)			!" enemy"
	call out (msg,0)

	if (omask .eq. PLNBIT)  msg = locf(lstf13)	!" planets"
	if (omask .eq. BASBIT)  msg = locf(lstf14)	!" bases"
	if (omask .eq. SHPBIT)  msg = locf(lstf15)	!" ships"
	if (omask .eq. (BASBIT .or. PLNBIT))  msg = locf(lstf16) !" ports"
	if (omask .eq. (PLNBIT .or. BASBIT .or. SHPBIT)) 
     +	msg = locf(lstf17)				!" forces"
	call out (msg,0)

	if (oflg .eq. SHORT)  goto 4100
	msg = locf(ingame)					!" in game"
	if ((grpbts .and. IRNBIT) .ne. 0)  msg = locf(inrang)	!" in range"
	if ((grpbts .and. ISRBIT) .ne. 0)  msg = locf(inspra)	!" in specified range"
	if ((grpbts .and. IGMBIT) .ne. 0)  msg = locf(ingame)	!" in game"
	call out (msg,0)
4100	call crlf

	return 1

	end
