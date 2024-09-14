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


C	This routine controls the Romulans.  If no Romulan presently
C	exists, one may be created and randomly placed in the universe.
C	If a Romulan already exists, DIST is used to locate the nearest
C	attackable object (ship or starbase), the Romulan then moves in
C	that direction if he isn't yet at point-blank range, and finally
C	if he is in range of his target, he either fires phasers or
C	photon torpedos at it.  The entry points PHAROM and TOROM are
C	used to hit a Romulan with either phasers or torpedos.  The
C	entry point DEADRO is used to remove a dead romulan from the
C	game.

	subroutine ROMDRV (phit, id)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /chkout/ V1, H1, V2, H2, lsym, disV, disH
	real disV, disH

d	call timin ('ROMDRV')
	romcnt = romcnt + 1
	if (romcnt * 2 .lt. numply)  goto 9999	!time to move?
	PLAYER = .FALSE.			!Romulan moving ...
	tmturn(3) = tmturn(3) + 1
	if (ROM)  goto 1100			!Romulan already alive?

*.......Make a Romulan miraculously appear...

	if ((romcnt .lt. numply * 3) .or. (iran(5) .eq. 5))  goto 9999
	romcnt = 0
	call place (DXROM * 100 + 1, 1, locr(KVPOS), locr(KHPOS))
	ROM = .TRUE.
	erom = iran(200) + 200
	numrom = numrom + 1

*.......Inform nearby players of Romulan's appearance

	iwhat = 11  ;  dispfr = DXROM * 100
	Vfrom = locr(KVPOS)  ;  Hfrom = locr(KHPOS)
	call pridis (locr(KVPOS), locr(KHPOS), KRANGE, 0, 0)
	if (PASFLG)  dbits = dbits .or. bits(who)
	call makhit

151	if (iran (10) .eq. 1) call tell		! let the Romulan speak!

*.......Romulan searches for a target in range

 100	call dist (iplace, nplc, numsec)
	if (numsec .gt. KRANGE)  goto 9999		!in range?

*.......Romulan attacks something

 200	goto (400,400,300,300) nplc
 300	i = base(iplace,KVPOS,nplc-2)
	j = base(iplace,KHPOS,nplc-2)
	goto 500
 400	i = shpcon(iplace,KVPOS)
	j = shpcon(iplace,KHPOS)
 500	ctime = etim (tim0)			!Romulan weapon pauses
	if (min0 (rtpaus, rppaus) .gt. ctime)  goto 9999
	romcnt = 0
	if (max0 (rtpaus, rppaus) .lt. ctime)  goto (600, 700)  iran(2)
	if (rppaus .lt. ctime)  goto 700

*.......Romulan uses photon torpedos

 600	call romstr (i, j)			!star adjacent to target?
	V1 = i - locr(KVPOS)
	H1 = j - locr(KHPOS)
	call romtor (V1, H1)			!fire torps!!
	goto 1000

*.......Romulan uses phasers

 700	if (nplc .lt. DXFBAS)  goto 800		!base calls for help?
	if (base(iplace,3,nplc-2) .ne. 1000)  goto 800
	Vto = i  ;  Hto = j  ;  iwhat = 9  ;  dispto = disp(i,j)
	dispfr = DXROM * 100
	call pridis (30, 30, 100, nplc-2, 0)
	dbits = dbits .and. .not. nomsg
	call makhit

800 	Vfrom = locr(KVPOS)  ;  Hfrom = locr(KHPOS)
	Vto = i  ;  Hto = j  ;  shjump = 0
	shstfr = erom  ;  shcnfr = 1
	id = pdist (Vfrom, Hfrom, Vto, Hto)
	call phadam (nplc, iplace, id, 200, .TRUE.)
	iwhat = 1
	call pridis (i, j, KRANGE, 0, 0)
	dispfr = DXROM * 100  ;  dispto = (nplc * 100) + iplace
	call makhit		!send hit message
	rppaus = etim (tim0) + (slwest + 1) * 750	!update phaser bank condition

	if ((nplc .lt. DXFBAS) .or. (disp(i,j) .ne. 0))  goto 1000	!base destroyed?
	iwhat = 10  ;  dispto = (nplc * 100) + iplace
	Vto = i  ;  Hto = j
	call pridis (30, 30, 100, nplc-2, 0)
	dbits = dbits .and. .not. nomsg
	call makhit

*.......Activate bases and planets, rebuild bases a little

1000	if (iran (50) .le. 1) call tell		! let the Romulan speak!
d	call timout ('ROMDRV')
d	call timin  ('BASPHA')
	call baspha
d	call timout ('BASPHA')
d	call timin  ('PLNATK')
	call plnatk
d	call timout ('PLNATK')
d	call timin  ('BASBLD')
	call basbld
d	call timout ('BASBLD')
	return

9999	continue
d	call timout ('ROMDRV')
	return

*.......Move Romulan a maximum of 4 sectors toward the
*.......nearest attackable object.

1100	call dist (iplace, nplc, numsec)	!find object
	if (numsec .le. 1)  goto 200		!already point-blank range?
	goto (1300, 1300, 1200, 1200)  nplc
1200	i = base(iplace,KVPOS,nplc-2)  ;  j = base(iplace,KHPOS,nplc-2)
	goto 1400
1300	i = shpcon(iplace,KVPOS)       ;  j = shpcon(iplace,KHPOS)

*	Compute desired new location

1400	if ((i-locr(KVPOS)) .lt. 0)  i = locr(KVPOS) - 
     +	(iabs(i - locr(KVPOS)) - 1)
	if ((i-locr(KVPOS)) .gt. 0)  i = locr(KVPOS) + 
     +	(iabs(i - locr(KVPOS)) - 1)
	if ((i-locr(KVPOS)) .eq. 0)  i = locr(KVPOS)
	if ((j-locr(KHPOS)) .lt. 0)  j = locr(KHPOS) - 
     +	(iabs(j - locr(KHPOS)) - 1)
	if ((j-locr(KHPOS)) .gt. 0)  j = locr(KHPOS) + 
     +	(iabs(j - locr(KHPOS)) - 1)
	if ((j-locr(KHPOS)) .eq. 0)  j = locr(KHPOS)
	l = 4				!Maximum speed warp 4
	if (numsec .lt. 4)  l = numsec

*	Express desired location in relative coordinates

	Vt = i - locr(KVPOS)
	Ht = j - locr(KHPOS)
	call check (locr(KVPOS), locr(KHPOS), Vt, Ht, l, 0.0)
	i = V1
	j = H1
	if (lsym .ne. 0)  goto 1500	!ran into something?
	call setdsp (locr(KVPOS), locr(KHPOS), 0)
	call setdsp (i, j, DXROM*100)
	locr(KVPOS) = i
	locr(KHPOS) = j
	goto 1800

*	If object in way of move, displace final resting place to
*	facilitate getting around it next move.

1500	do 1700 i1 = 1, l
	  if (.not. ingal(i-i1,5))  goto 1600
	  if (disp(i-i1,j) .gt. 0)  goto 1600
	  call setdsp (locr(KVPOS), locr(KHPOS), 0)
	  call setdsp (i-i1, j, DXROM*100)
	  locr(KVPOS) = i - i1
	  locr(KHPOS) = j
	  goto 1800
1600	  if (.not. ingal(5,j-i1))  goto 1700
	  if (disp(i,j-i1) .gt. 0)  goto 1700
	  call setdsp (locr(KVPOS), locr(KHPOS), 0)
	  call setdsp (i, j-i1, DXROM*100)
	  locr(KVPOS) = i
	  locr(KHPOS) = j - i1
	  goto 1800
1700	continue

*	Check target's relative location after move

1800	call dist (iplace, nplc, numsec)
	if (.not. PASFLG)  goto 1900		!inform system player of new location
	call odisp (DXROM*100, 1)
	call out (romadv,0)
	call prloc (locr(KVPOS), locr(KHPOS), 1, 0, ocflg, SHORT)
1900	if (numsec .le. KRANGE)  goto 200	!if in range, attack!
	romcnt = 0
	goto 9999

*.......Romulan gets phasered

	entry PHAROM (phit, id)

	iwhat = 1  ;  ihita = ((100 + iran(100)) * phit) / (10 * id)
	erom = erom - (ihita / 10)
	if (erom .gt. 0)  return

*.......Requiem for a dead romulan (sigh!)

	entry DEADRO (phit, id)

2000	klflg = 2
	ROM = .FALSE.  ;  call setdsp (locr(KVPOS), locr(KHPOS), 0)
	return

*.......Romulan gets hit by a torpedo

	entry TOROM (phit, id)

	iwhat = 2  ;  ihita = min0 (iran(4000), 2000)
	erom = erom - (ihita / 10)
	if (erom .le. 0)  goto 2000
	return

	end
