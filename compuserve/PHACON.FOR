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


C	This routine controls the phaser banks of an individual ship.
C	The target coordinates are read in, verified as being valid,
C	the hit is made, and the appropriate messages are printed.

	subroutine PHACON (*)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

*.......Phasers critically damaged?

	if (shpdam(who,KDPHAS) .lt. KCRIT)  goto 100
	call out (phacn0,1)
	return 1

*.......Target location read in

 100	tem = locate(-3)
 200	if (tem .eq. 1)  call out (erloc1,1)
	if ((tem .lt. 0) .or. (tem .eq. 1))  return 1	!abort phasers?
	if (tem .ne. 0)  goto 300
	tem = reloc(-3)
	goto 200

 300	bank = 1  ;  if (phbank(2) .lt. phbank(1))  bank = 2
	iV = vallst(tem-1)  ;  iH = vallst(tem)	!identify type of target
	nplc = dispc (iV,iH)
	ip   = dispx (iV,iH)
	if ((nplc .lt. DXFSHP) .or. (nplc .gt. DXEPLN))  goto 1600
	if ((nplc .lt. DXFBAS) .and. (.not. alive(ip)))  goto 1600

*	determine distance to target, abort if 0 or > KRANGE

	id = pdist (iV, iH, shpcon(who,KVPOS), shpcon(who,KHPOS))
	if (id .ne. 0)  goto 600
	if (oflg)  400, 400, 500
 400	call out (error2,1)  ;  return 1
 500	call out (error1,1)  ;  return 1

 600	if ((nplc .eq. team) .or. (nplc .eq. team+2) .or. 
     +	(nplc .eq. team+DXNPLN))  goto 1800
	if (id .le. KRANGE)  goto 700
	call out (phacn1,1)  ;  return 1

*	Determine size of phaser hit

700 	call pause (phbank(bank) - etim(tim0))
	phit = 200
	if (tem .eq. 2)  goto 800	!phaser hit specified?
	if ((vallst(1) .gt. 500) .or. (vallst(1) .lt. 50))  goto 1700
	phit = vallst(1)

 800	if (shpcon(who,KSHCON) .lt. 0)  goto 900		!high speed shield control
	if (oflg .ne. short)  call out (phacn2, 1)
	shpcon(who,KSNRGY) = shpcon(who,KSNRGY) - 2000
 900	if ((iran(100) * phit) .le. 18900)  goto 1000		!phasers overheat?
	call out (phacn4,1)
	if (oflg .eq. long)  call out (phacn5,1)
	shpdam(who,KDPHAS) = shpdam(who,KDPHAS) + 750 + 
     +	(iran(100) * phit * 7.5) / 100

*.......Check target, hit and damage

1000	if ((nplc .lt. DXNPLN) .or. (nplc .gt. DXEPLN))  goto 1100

*	damage planet

	Vfrom = shpcon(who,KVPOS)    ;  Hfrom = shpcon(who,KHPOS)
	shstfr = shpcon(who,KSSHPC)  ;  shcnfr = shpcon(who,KSHCON)
	Vto = iV  ;  Hto = iH  ;  shjump = 0
	dispfr = who + (team * 100)
	dispto = disp(iV,iH)  ;  iwhat = 1
	call pridis (iV, iH, KRANGE, 0, 0)
	if ((iran(100) * phit) / (25 * id) .gt. 150)  locpln(ip,3) = 
     +	max0 (locpln(ip,3) - 1, 0)
	shstto = locpln(ip,3)
	call makhit
	goto 1500

*	damage Romulan

1100	if (nplc .ne. DXROM)  goto 1200
	Vfrom = shpcon(who,KVPOS)  ;  Hfrom = shpcon(who,KHPOS)
	Vto = locr(KVPOS)  ;  Hto = locr(KHPOS)  ;  shjump = 0
	call pharom (phit, id)
	tpoint(KPRKIL) = tpoint(KPRKIL) + ihita
	if (.not. ROM)  tpoint(KPRKIL) = tpoint(KPRKIL) + 5000
	shstfr = shpcon(who,KSSHPC)  ;  shcnfr = shpcon(who,KSHCON)
	shstto = erom  ;  shcnto = 1
	dispfr = who + (team * 100)
	dispto = DXROM * 100  ;  iwhat = 1
	call pridis (iV, iH, KRANGE, 0, 0)
	call makhit
	goto 1500

*	damage ships and bases

1200	if (nplc .lt. DXFBAS)  goto 1300
	if (base(ip,3,nplc-2) .ne. 1000)  goto 1300
	Vto = iV   ;   Hto = iH
	iwhat = 9  ;  dispto = disp(iV,iH)
	dispfr = who + (team * 100)
	call pridis (30, 30, 100, nplc-2, 0)
	dbits = dbits .and. .not. nomsg
	call makhit
1300	call phadam (nplc, ip, id, phit, .TRUE.)	!hit him!

*	set up parameters for MAKHIT

	shstfr = shpcon(who,KSSHPC)  ;  shcnfr = shpcon(who,KSHCON)
	Vfrom = shpcon(who,KVPOS)    ;  Hfrom = shpcon(who,KHPOS)
	Vto = iV   ;   Hto = iH   ;   shjump = 0
	dispfr = who + (team * 100)
	dispto = (nplc * 100) + ip  ;  iwhat = 1
	if (nplc .ge. DXFBAS)  call pridis (iV, iH, KRANGE, nplc-2, 0)
	if (nplc .lt. DXFBAS)  call pridis (iV, iH, KRANGE, nplc, 0)
	call pridis (iV, iH, 4, 0, 1)
	dbits = dbits .or. bits(who)
	call makhit
1400	if ((nplc .lt. DXFBAS) .or. (disp(iV,iH) .ne. 0))  goto 1500	!base destroyed?
	iwhat = 10  ;  dispto = (nplc * 100) + ip
	dispfr = who + (team * 100)
	Vto = iV   ;   Hto = iH
	call pridis (30, 30, 100, nplc-2, 0)
	dbits = dbits .and. .not. nomsg
	call makhit

*	pay energy for firing, update phaser bank condition

1500	shpcon(who,KSNRGY) = shpcon(who,KSNRGY) - (phit * 10)
	shpcon(who,KSPCON) = RED
	phbank(bank) = etim (tim0) + (slwest + 1) * 1500 + 
     +	shpdam(who,KDPHAS)
	return

1600	call out (phacn7,1)		!no target at that location
	return 1

1700	call out (phacn8,1)		!Improper size for phaser hit
	return 1

1800	call out (phacn9,1)		!Trying to damage an ally
	return 1

	end
