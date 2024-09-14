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


C	This routine is used to fortify captured planets against enemy
C	assault, and eventually to transform them into fully operational
C	starbases.  Each build strengthens the planetary phaser banks,
C	with five accumulated 'builds' transforming the planet into a
C	starbase (if your team possesses less than the maximum number
C	of operational starbases at that time).

	subroutine BUILD (*)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	v = etim(tim0) + (slwest * 1000) + 4000
	tem = locate(2)
 100	if (tem .lt. 0)  return 1		!abort 'build'
	if (tem .ne. 0)  goto 200
	tem = reloc(2)
	goto 100

 200	Vloc = vallst(1)  ;  Hloc = vallst(2)
	if (.not. ldis(shpcon(who,KVPOS), shpcon(who,KHPOS), Vloc, 
     +	Hloc, 1))  goto 900			!adjacent to sector given?
	c = dispc (Vloc,Hloc)
	if ((c .lt. DXNPLN) .or. (c .gt. DXEPLN))  goto 800	!is it a planet?
	if ((team + DXNPLN) .ne. c)  goto 600	!not yet captured!

*	5th build, but already KNBASE active bases

	i = dispx (Vloc,Hloc)
	if ((locpln(i,3) .eq. 4) .and. (nbase(team) .eq. KNBASE)) goto 700
	locpln(i,3) = locpln(i,3) + 1
	if (locpln(i,3) .eq. 5)  goto 250
	call odec (locpln(i,3),0)		!inform player of number of builds
	call out (build3,0)
	if (locpln(i,3) .gt. 1)  call outc ('s')
	call crlf
 250	tpoint(KPBBAS) = tpoint(KPBBAS) + (500 * locpln(i,3))
	if (locpln(i,3) .ne. 5)  goto 500	!building complete?
	call lock (plnlok,'BUILD')		!lock LOCPLN array
	if (.not. lkfail) goto 251
	call out ('Sorry, Captain, but the construction crew is', 1)
	call out ('busy with repairs at the moment.', 1)
	return	1

251	do 300 j = 1, KNBASE			!search for empty base slot
	  if (base(j,3,team) .le. 0)  goto 400
 300	continue
	locpln(i,3) = locpln(i,3) - 1
	call unlock (plnlok)
	goto 700

*.......Update starbase information

 400	tpoint(KPBBAS) = tpoint(KPBBAS) + 2500
	nbase(team) = nbase(team) + 1
	base(j,4,team) = locpln(i,4)		!transfer LIST information
	call plnrmv (i,team)			!update planet information
	call unlock (plnlok)			!unlock LOCPLN array
	base(j,KVPOS,team) = Vloc
	base(j,KHPOS,team) = Hloc
	base(j,3,team) = 1000
	call setdsp (Vloc, Hloc, ((DXFBAS + (team - 1)) * 100) + j)

*.......Send player message ...

	call crlf
	call odisp (disp (shpcon(who,KVPOS),shpcon(who,KHPOS)), 1)
	call out (build1,0)
	call prloc (Vloc, Hloc, 0, 0, ocflg, oflg)
	call out (build2,0)
	call odisp (disp (Vloc, Hloc), 0)
	call crlf
 500	ptime = v - etim(tim0)
	return

*.......Error messages

 600	call out (build7,0)			!Planet not yet captured
	return 1

 700	call out (build4,0)			!already KNBASE bases
	call odisp ((team+2) * 100, 0)
	call out (build5,1)
	return 1

 800	call out (noplnt,1)			!no planet here!
	return 1

 900	call odisp (disp(shpcon(who,KVPOS),shpcon(who,KHPOS)), 1)  !not adjacent to sector given!
	call out (captu5,1)
	return 1

	end
