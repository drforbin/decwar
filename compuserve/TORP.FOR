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


C	This routine controls torpedo fires by players.  The desired
C	burst is read in, checked for syntax errors, and executed.

	subroutine TORP (*)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /chkout/ V1, H1, iVc, iHc, dcode, idisV, idisH
	real d, idisV, idisH
	common /tolocl/ torpl(3,2), tpaus

*.......Torpedo tubes critically damaged?

	if (shpdam(who,KDTORP) .lt. KCRIT)  goto 100
	call out (torp00,1)
	return 1

 100	call blkset (torpl, 0, 7)
	iflg = 1
	i = 2
	if (shpcon(who,KNTORP) .gt. 0)  goto 200	!any torps left?
	if (oflg .eq. short)  goto 2600
	call out (torp01,1)
	return 1

*.......Read number of torps in burst, target locations

 200	tem = locate(-7)
	if (tem .lt. 0)  return 1			!abort torpedo burst
	if (tem .gt. 0)  goto 400
 300	call out (torp02,0)
	tem = reloc (-7)
	if (tem .lt. 0)  return 1
	if ((tem .eq. 0) .or. (mod(tem,2) .eq. 0))  goto 300
 400	if (vallst(1) .le. 0)  return 1			!negative # of torps aborts burst
	ntorp = vallst(1)
	if (ntorp .gt. shpcon(who,KNTORP))  call out (torp03,1)
	if ((ntorp .gt. shpcon(who,KNTORP)) .or. (ntorp .gt. 3) .or. 
     +	(ntorp .lt. 1))  goto 2600
	if (tem .ne. 1)  goto 600			!target locations already given?
 500	tem = reloc(-ntorp * 2)
	if (tem .lt. 0)  return 1
	if (mod(tem,2) .ne. 0)  goto 500
	i = 1

*	Analyse and store target location information

 600	torpl(1,1) = vallst(i)
	torpl(1,2) = vallst(i+1)
	if (ntorp .eq. 1)  goto 700
	if (tem .ge. i+2)  i = i + 2
	torpl(2,1) = vallst(i)
	torpl(2,2) = vallst(i+1)
	if (ntorp .eq. 2)  goto 700
	if (tem .ge. i+2)  i = i + 2
	torpl(3,1) = vallst(i)
	torpl(3,2) = vallst(i+1)

*	Input own location or out-of-range location?

 700	do 800 i = 1, ntorp
	  if ((torpl(i,1) .eq. shpcon(who,KVPOS)) .and. 
     +	  (torpl(i,2) .eq. shpcon(who,KHPOS)))  goto 2100
	  if (.not. ldis(shpcon(who,KVPOS), shpcon(who,KHPOS), 
     +	  torpl(i,1), torpl(i,2), KRANGE))  goto 2700
 800	continue

*.......Start torpedo loop

	call pause (tobank - etim(tim0))		!load torpedo tubes
	tpaus = 0
	shpcon(who,KSPCON) = RED
	do 2000 id = 1, ntorp
	  dispfr = who + (team * 100)
	  shstfr = shpcon(who,KSSHPC)  ;  shcnfr = shpcon(who,KSHCON)
	  Vfrom  = shpcon(who,KVPOS)   ;  Hfrom = shpcon(who,KHPOS)
	  if (iflg .lt. 0)  goto 2400

*.........Calculate deflection--normal, shields, damage to tubes or computer?

	  d = (ran(0) - 0.5) / 5.0
	  if ((shpdam(who,KDTORP) .gt. 0) .or. (shpdam(who,KDCOMP) 
     +	  .gt. 0))  d = d + (ran(0) - 0.5) / 10.0
	  if (shpcon(who,KSHCON) .gt. 0)  d = d + 
     +	  (float(shpcon(who,KSSHPC)) * (ran(0) - 0.5)) / 10000.
	  iV = torpl(id,1) - shpcon(who,KVPOS)
	  iH = torpl(id,2) - shpcon(who,KHPOS)
	  if ((iV .eq. 0) .and. (iH .eq. 0))  goto 2100
	  if (.not. docked(who)) shpcon(who,KNTORP) = shpcon(who,KNTORP)-1
	  if (iran(100) .gt. 96)  goto 2500	!torpedo misfire?

*.........See if anything hit

 900	  idis = KRANGE - 2 + int((ran(0) - 0.5) * 4.0 + 0.5)
	  tpaus = tpaus + (slwest + 1) * 1000 + shpdam(who,KDTORP)
	  call check (shpcon(who,KVPOS), shpcon(who,KHPOS), iV, iH, 
     +    idis, d)
	  if (dcode .eq. 0)  goto 1600
	  aran = iran(100)
	  if (dcode .ne. DXSTAR*100)  goto 1100
	  if (aran .le. 80)  goto 1000
	  dbits = bits (who)
	  Vfrom = iVc            ;  Hfrom = iHc
	  dispfr = DXSTAR * 100  ;  iwhat = 6
	  call makhit
1000	  if (aran .gt. 80)  goto 2000

*.........If star affected, check vicinity for target to damage

	  dispfr = DXSTAR * 100
	  iwhat = 7  ;  Vfrom = iVc  ;  Hfrom = iHc
	  call pridis (iVc, iHc, KRANGE, 0, 0)
	  call makhit
	  tpoint(KNSDES) = tpoint(KNSDES) - 500
	  call snova
	  goto 2000

*.........If target hit by torpedo, damage it

1100	  nplc = dcode / 100
	  if ((nplc .ge. DXNPLN) .and. (nplc .le. DXEPLN))  goto 1800	!planet?
	  if (nplc .ne. DXBHOL)  goto 1200				!black hole?
	  iwhat = 5  ;  Vto = iVc  ;  Hto = iHc  ;  critdv = id
	  dbits = bits (who)
	  call makhit
	  goto 2000

*	  Damage ships or starbases

1200	  if (nplc .eq. DXROM)  goto 1700		!romulan?

*.........Torpedo hits a friendly base or ship?

	  if ((nplc .ne. team) .and. (nplc .ne. team+2))  goto 1400
1300	  iwhat = 15  ;  Vto = iVc  ;  Hto = iHc  ;  critdv = id
	  dbits = bits (who)
	  call makhit
	  goto 2000

1400	  j = mod (dcode, 100)
	  if (nplc .lt. DXFBAS)  goto 1500

*	  Base calls for help?

	  if (base(j,3,nplc-2) .ne. 1000)  goto 1500
	  Vto   = base(j,KVPOS,nplc-2)  ;  Hto   = base(j,KHPOS,nplc-2)
	  iwhat  = 9  ;  dispto = dcode  ;  dbits = 0
	  call pridis (30, 30, 100, nplc-2, 0)
	  dbits = dbits .and. .not. nomsg
	  call makhit
	  iwhat  = 2  ;  dispfr = who + (team * 100)
	  Vfrom  = shpcon(who,KVPOS)   ;  Hfrom  = shpcon(who,KHPOS)
	  shstfr = shpcon(who,KSSHPC)  ;  shcnfr = shpcon(who,KSHCON)

1500	  Vto = iVc  ;  Hto = iHc
	  call tordam (nplc, j, idum, idum, .TRUE.)
	  dispto = dcode
	  call pridis (iVc, iHc, KRANGE, 0, 0)
	  call makhit				!send hit message
	  if ((nplc .lt. DXFBAS) .and. (trstat(j) .ne. 0)) 
     +	  call trcoff (j)

*	  Base destroyed?

	  if ((nplc .lt. DXFBAS) .or. (disp(iVc,iHc) .ne. 0))  goto 2000
	  dispto = j + (nplc * 100)  ;  iwhat = 10
	  call pridis (30, 30, 100, nplc-2, 0)
	  dbits = dbits .and. .not. nomsg
	  Vto = iVc  ;  Hto = iHc
	  call makhit
	  goto 2000

*.........Torpedo misses

1600	  iwhat = 4  ;  Vto = iVc  ;  Hto = iHc  ;  critdv = id
	  dbits = bits (who)
	  call makhit
	  goto 2000

*.........Hit Romulan with torpedo

1700	  call torom (d1, d2)
	  if (ROM .and. iran(10) .gt. 7)  call jump (DXROM,1)
	  tpoint(KPRKIL) = tpoint(KPRKIL) + ihita
	  if (.not. ROM)  tpoint(KPRKIL) = tpoint(KPRKIL) + 5000
	  shstto = erom  ;  shcnto = 1  ;  dispto = DXROM * 100
	  Vto = locr(KVPOS)  ;  Hto = locr(KHPOS)
	  call pridis (iVc, iHc, KRANGE, 0, 0)
	  call makhit
	  goto 2000

*.........Hit planet with torpedo

1800	  if (nplc .eq. team+DXNPLN)  goto 1300	!friendly planet?
	  dispto = dcode  ;  i = mod (dcode, 100)
	  iwhat = 2
	  call lock (plnlok,'TORP')		!lock LOCPLN array
	  if (lkfail) goto 2800			! if can't get plnlok, miss
	  Vto = locpln(i,KVPOS)  ;  Hto = locpln(i,KHPOS)
	  if (iran(4) .eq. 4)  locpln(i,3) = locpln(i,3) - 1
	  shstto = max0 (locpln(i,3), 0)
	  if (locpln(i,3) .lt. 0)  klflg = 2	!planet killed?
	  if (klflg .eq. 0)  goto 1900
	  tpoint(KNPDES) = tpoint(KNPDES) - 1000
	  call setdsp (iVc, iHc, 0)
	  call plnrmv (i, nplc-DXNPLN)
1900	  call unlock (plnlok)			!unlock LOCPLN array
	  call pridis (iVc, iHc, KRANGE, 0, 0)
	  call makhit
2000	continue
	goto 2400

2100	if (oflg)  2200, 2200, 2300		!attempting to hit own location
2200	call out (error2,1)  ;  goto 2400
2300	call out (error1,1)
2400	tobank = etim(tim0) + tpaus		!set minimum pause before next burst
	return

*.......Check for torpedo misfire and photon tube damage

2500	call out (torp04,0)
	call odec (id,0)
	call out (torp05,1)
	d = d + (ran(0) - 0.5) / 5.0		!recompute torpedo deflection
	iflg = -1
	if (iran(5) .ne. 5)  goto 900		!tubes damaged?
	shpdam(who,KDTORP) = shpdam(who,KDTORP) + 500 + iran(3000)
	call out (torp06,1)
	goto 900

*.......Error messages

2600	call crlf				!insufficient torps for burst
	call odec (shpcon(who,KNTORP),0)
	call out (torp07,1)
	return 1

2700	call out (phacn1,1)			!target out of range
	return 1

2800	call out ('Sorry, Captain, but the torpedo tubes are empty!', 1)
	return 1
	end
