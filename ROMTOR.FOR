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


C	This routine controls the Romulan's torpedo firing procedure.
C	The initial target is fired upon, and later torpedos are
C	retargeted as the situation requires.

	subroutine ROMTOR (iV1, iH1)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /chkout/ V1, H1, iVc, iHc, l, disV, disH
	real d, disV, disH

	misfir = 0  ;  tpaus = 0
	do 800 id = 1, 3			!start torp firing loop
	  d = (ran(0) - 0.5) / 2.5		!set torp deflection
	  if (misfir .lt. 0)  goto 900		!an earlier misfire?
	  if (iran(100) .gt. 96)  misfir = -1	!he suffers a misfire?
	  if (misfir .lt. 0)  d = d + (ran(0) - 0.5) / 5.0	!increase torp deflection if misfire

*.........See if anything hit

	  idis = KRANGE - 2 + int((ran(0) - 0.5) * 4.0 + 0.5)
	  tpaus = tpaus + (slwest + 1) * 1000
	  call check (locr(KVPOS), locr(KHPOS), iV1, iH1, idis, d)
	  if (l .eq. 0)  goto 800
	  aran = iran (100)

*.........If star affected, check vicinity for target to damage

	  if (l .ne. DXSTAR*100)  goto 100
	  if (aran .gt. 80)  goto 300
	  iwhat = 7  ;  dispfr = DXSTAR * 100
	  Vfrom = iVc  ;  Hfrom = iHc
	  call pridis (iVc, iHc, KRANGE, 0, 0)
	  call makhit
	  rsr(KNSDES) = rsr(KNSDES) - 500
	  call snova
	  if (.not. ROM)  return		!romulan blew himself up?
	  goto 300

*.........If target hit by torpedo, damage it

100	  nplc = l / 100  ;  j = mod (l, 100)
	  if ((nplc .ge. DXNPLN) .and. (nplc .le. DXEPLN))  goto 600  !planet?
	  if (nplc .eq. DXBHOL)  goto 300		!black hole?
	  if (nplc .lt. DXFBAS)  goto 200		!ship?

*	  Base calls for help

	  if (base(j,3,nplc-2) .ne. 1000)  goto 200
	  iwhat = 9  ;  dispto = l
	  Vto = base(j,KVPOS,nplc-2)  ;  Hto = base(j,KHPOS,nplc-2)
	  call pridis (30, 30, 100, nplc-2, 0)
	  dbits = dbits .and. .not. nomsg
	  call makhit

*	  Hit ship or base

 200	  Vto = iVc  ;  Hto = iHc
	  call tordam (nplc, j, idum, idum, .TRUE.)
	  Vfrom = locr(KVPOS)  ;  Hfrom = locr(KHPOS)
	  shstfr = erom  ;  shcnfr = 1
	  dispto = l  ;  dispfr = DXROM * 100  ;  iwhat = 2
	  call pridis (iVc, iHc, KRANGE, 0, 0)
	  call makhit				!send hit message
	  if ((nplc .lt. DXFBAS) .and. (trstat(j) .ne. 0)) 
     +	  call trcoff (j)				!break tractor beam?

*	  Base destroyed?

	  if ((nplc .lt. DXFBAS) .or. (disp(iVc,iHc) .ne. 0))  goto 300
	  dispto = l  ;  iwhat = 10
	  call pridis (30, 30, 100, nplc-2, 0)
	  dbits = dbits .and. .not. nomsg
	  Vto = iVc  ;  Hto = iHc
	  call makhit

*.........Retarget for next torpedo

 300	  call dist (iob, nplc, num99)
	  if (num99 .gt. KRANGE)  goto 900	!in range?
	  if (nplc .lt. DXFBAS)  goto 400
	  iV2 = base(iob,KVPOS,nplc-2)
	  iH2 = base(iob,KHPOS,nplc-2)
	  goto 500
 400	  iV2 = shpcon(iob,KVPOS)
	  iH2 = shpcon(iob,KHPOS)
 500	  call romstr (iV2, iH2)
	  iV1 = iV2 - locr(KVPOS)
	  iH1 = iH2 - locr(KHPOS)
	  goto 800

*.........Planet attacked by accident

600 	  dispto = l  ;  iwhat = 2  ;  dispfr = DXROM * 100
	  Vfrom = locr(KVPOS)  ;  Hfrom = locr(KHPOS)
	  Vto = iVc  ;  Hto = iHc  ;  shjump = 0
	  shstfr = erom  ;  shcnfr = 1
	  call lock (plnlok, 'ROMTOR')		!lock LOCPLN array
	  if (lkfail) goto 800
	  i = mod (l, 100)
	  if (aran .ge. 75)  locpln(i,3) = locpln(i,3) - 1
	  shstto = max0 (locpln(i,3), 0)
	  if (locpln(i,3) .lt. 0)  klflg = 2		!planet destroyed?
	  if (klflg .eq. 0)  goto 700
	  pteam = l/100 - DXNPLN
	  call setdsp (iVc, iHc, 0)
	  rsr(KNPDES) = rsr(KNPDES) - 1000
	  call plnrmv (i,pteam)
 700	  call unlock (plnlok)				!unlock LOCPLN array
	  call pridis (iVc, iHc, KRANGE, 0, 0)
	  call makhit				!send hit message
	  goto 300

 800	continue
 900	rtpaus = etim (tim0) + tpaus
	return

	end
