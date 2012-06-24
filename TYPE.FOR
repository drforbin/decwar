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


C	This routine informs the player of either the current OUTPUT
C	or OPTION switches.  The OUTPUT switches are:
C		SHORT, MEDIUM, or LONG output,
C		NORMAL or INFORMATIVE command prompt,
C		SHORT or LONG scan format,
C		ABSOLUTE or RELATIVE default for coordinate input,
C		ABSOLUTE, RELATIVE or BOTH for coordinate output,
C	    and	the current TTYTYPE.
C	The OPTION switches are:
C		The current version number and date of implementation,
C		Whether there are Romulans in the game,
C	    and	whether there are Black Holes in the game.

	subroutine TYPE(kind)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	p = 2
	if (kind .eq. 1) goto 400		! show his params
	if (kind .eq. 2) goto 2300
 100	if (typlst(p) .ne. KALF)  goto 300
	if (equal (tknlst(p), 'O') .ne. -2)  goto 200
	call out (ambswi, 1)		!ambiguous switch
	goto 300

 200	if (equal (tknlst(p), 'OUTPUT'))  goto 400
	if (equal (tknlst(p), 'OPTION'))  goto 2300

 300	call out (type01, 0)		!get the switch
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	p = 1  ;  goto 100

*.......TYPE OUTPUT switches

 400	call out (type02, 2)		!Short, Medium or Long output
	if (oflg)  500, 600, 700
 500	call out (shtfrm, 0)  ;  goto 800
 600	call out (medfrm, 0)  ;  goto 800
 700	call out (lngfrm, 0)
 800	call out (type03, 1)

	if (prtype)  900, 1000		!Normal or Informative prompt
 900	call out (inform, 0)  ;  goto 1100
1000	call out (normal, 0)
1100	call out (type04, 1)

	if (scnflg)  1200, 1300		!Short or Long scans
1200	call out (shtfrm, 0)  ;  goto 1400
1300	call out (lngfrm, 0)
1400	call out (type05, 1)

	if (icflg)  1500, 1600, 1700	!Abs. or Rel. coordinate input
1500	call out (relfrm, 0)  ;  goto 1800
1600	call out (bthfrm, 0)  ;  goto 1800
1700	call out (absfrm, 0)
1800	call out (type08, 1)

	if (ocflg)  1900, 2000, 2100	!Abs., Rel. or Both for coord. output
1900	call out (relfrm, 0)  ;  goto 2200
2000	call out (bthfrm, 0)  ;  goto 2200
2100	call out (absfrm, 0)
2200	call out (type09, 1)

	call out (set008, 0)		!Terminal type
	call out2w (ttydat(1,ttytyp), ttydat(2,ttytyp))
	call crlf
	goto 2400

*.......TYPE OPTION switches

2300	call crlf
	call out (decver, 1)
	if (ROMOPT)  call out (setu06, 1)
	if (.not. ROMOPT)  call out (type06, 1)
	if (BLHOPT)  call out (setu07, 1)
	if (.not. BLHOPT)  call out (type07, 1)

2400	return

	end
