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


C	This function is used to obtain location information from the
C	player.  The parameter n if positive specifies the EXACT number
C	of separate items of information needed by the calling routine.
C	If n is negative, then it indicates the maximum number of
C	OPTIONAL pieces of information the routine will accept, although
C	no modifiers are actually required.  This routine will process
C	coordinates given in ABSOLUTE, RELATIVE, or COMPUTED form.
C	The value of LOCATE when returned to the calling routine equals
C	the number of 'tokens' actually processed.  If LOCATE returns
C	with a negative value, this indicates an error condition and
C	the calling routine should therefore abort.  The entry point
C	RELOC is used when a command has already been entered, and the
C	first token is now a modifier, rather than the command itself.

	function LOCATE (n)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	real dV, dH

	p = 2
	goto 100

	entry RELOC (n)
	call out (coord1,0)	!coordinates?
	call gtkn
	p = 1

 100	sign = isign(1,n)
	max = iabs(n)

	if (.not. (typlst(1) .eq. KEOL))  goto 300
 200	locate = -1
	reloc  = locate
	return			!abort

*.......Check ICFLG for default location specification type

 300	dV = 0.0  ;  dH = 0.0  ;  if (icflg .eq. KABS)  goto 400
	dV = float (shpcon(who,KVPOS))
	dH = float (shpcon(who,KHPOS))

 400	if (.not. equal(tknlst(p), absfrm))  goto 500
	p = p + 1
	if (icflg .eq. KABS)  goto 1400
	dV = 0.0  ;  dH = 0.0
	goto 1400

 500	if (.not. equal(tknlst(p), relfrm))  goto 600
	p = p + 1
	if (icflg .eq. KREL)  goto 1400
	dV = float(shpcon(who,KVPOS))
	dH = float(shpcon(who,KHPOS))
	goto 1400

 600	if (.not. equal(tknlst(p), 'COMPUTED'))  goto 1400
	if (shpdam(who,KDCOMP) .lt. KCRIT)  goto 700
	call out (damcom,1)
	goto 200
 700	if (PASFLG .or. (job(who,KTTYSP) .le. 300))  goto 800
c--	call out (nocomp,1)
c--	goto 200
		call pause (job(who, KTTYSP) * 2)	! slow down hi-bauders

 800	k = ntok - p
	do 900 i = 1, k
	  tknlst(i) = tknlst(i+p)
	  typlst(i) = typlst(i+p) ; vallst(i) = vallst(i+p)
 900	continue
	locate = k * 2
	p = 1
	if (.not. (typlst(1) .eq. KINT))  goto 1000
	locate = locate - 1
	k = k - 1
	p = 2
1000	ntok = locate
	reloc  = locate
	if (locate .eq. 0)  return
	if ((sign .gt. 0) .and. (locate .ne. max))  goto 2000
	if ((sign .lt. 0) .and. (locate .gt. max))  goto 2100

	do 1300 i = k+p-1, p, -1
	  do 1100 j = 1, KNPLAY
	    if (.not. (typlst(i) .eq. KALF))  goto 2200
	    if (equal(tknlst(i), names(j,1)))  goto 1200
1100	  continue
	  if (.not. equal(tknlst(i), 'ROMULAN'))  goto 2300
	  if (.not. ROM)  goto 2400
	  vallst(2*i - p) = locr (KVPOS)  ;  typlst(2*i - p) = KINT
	  vallst(2*i - p + 1) = locr (KHPOS) ; typlst(2*i - p + 1) = KINT
	  goto 1300
1200	  if (.not. alive(j))  goto 2400
	  if (disp(shpcon(j,KVPOS),shpcon(j,KHPOS)) .le. 0)  goto 2400
	  vallst(2*i-p) = shpcon(j,KVPOS) ; typlst(2*i-p) = KINT
	  vallst(2*i-p+1) = shpcon(j,KHPOS) ; typlst(2*i-p+1) = KINT
1300	continue
	return

1400	locate = ntok - p + 1 	!number of tokens that follow
	reloc  = locate
	if (locate .eq. 0)  return
	if ((sign .gt. 0) .and. (locate .ne. max))  goto 2000
	if ((sign .lt. 0) .and. (locate .gt. max))  goto 2100

	do 1500 i = p, ntok
	  if (.not. (typlst(i) .eq. KINT))  goto 2500
1500	continue

	index = 1
	if (mod(locate,2) .eq. 0)  goto 1700	!even # of items
	vallst(index) = vallst(p)	!don't check for range error or relative

1600	p = p + 1
	index = index + 1
1700	if (p .eq. ntok+1)  return

	vallst(index) = vallst(p) + dV
	if (.not. ingal (vallst(index), 5))  goto 2600

	p = p + 1
	index = index + 1
	if (p .eq. ntok+1)  return

	vallst(index) = vallst(p) + dH
	if (.not. ingal (5, vallst(index)))  goto 2700
	goto 1600


C.......Error messages

2000	call out (erloc1,1)	!wrong number of coordinates specified
	goto 200
2100	call out (erloc2,1)	!too many coordinates specified
	goto 200
2200	call out (erloc3,1)	!non-alpha ship name
	goto 200
2300	call out (erloc4,1)	!unrecognized ship name
	goto 200
2400	call out (noship,1)	!player not in game
	goto 200
2500	call out (erloc7,1)	!non-numeric coordinate
	goto 200
2600	call out (erloc8,1)	!V coordinate lies outside universe
	goto 200
2700	call out (erloc9,1)	!H coordinate lies outside universe
	goto 200

	end
