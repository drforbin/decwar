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


C	This routine prints out useful information on the status of an
C	individual ship.  It may be used to print out all the information
C	available, or just particular items.  It can also be called using
C	a switch on the DOCK command.  STOKEN = 2 if this routine is
C	called by a STATUS command, STOKEN = 3 if this routine is
C	called from a STATUS string appended to DOCK.

	subroutine STATUS (stoken)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	call crlf
	obit = 4  ;  if (oflg .eq. short)  obit = 0
	if (typlst(stoken) .ne. KEOL)  goto 900	!specific information requested?
	if (oflg)  100, 200, 300
 100	call out2c ('SD')    ;  goto 400
 200	call out (stat2M,0)  ;  goto 400
 300	call out (stat2L,0)
 400	call odec (shpcon(who,KNTURN),obit)
	if (oflg)  500, 600, 600
 500	call space  ;  goto 700
 600	call crlf

*.......Set up dummy TYPLST and TKNLST strings for printing full report

 700	typlst(stoken+7) = KEOL
	tknlst(stoken)   = 1hC
	tknlst(stoken+1) = 1hL
	tknlst(stoken+2) = 1hT
	tknlst(stoken+3) = 1hE
	tknlst(stoken+4) = 1hD
	tknlst(stoken+5) = 1hS
	tknlst(stoken+6) = 1hR
	do 800 i = stoken, stoken + 6
	  typlst(i) = KALF
 800	continue

*.......Identify and report on specified items

 900	do 5700 i = stoken, KMAXTK
	  if ((typlst(i) .ne. KALF) .and. (oflg .eq. short)) 
     +	  call crlf
	  if (typlst(i) .ne. KALF)  return
	  if (equal (tknlst(i), 'SHIELDS'))  goto 1000
	  if (equal (tknlst(i), 'LOCATION'))  goto 1500
	  if (equal (tknlst(i), 'CONDITION'))  goto 2100
	  if (equal (tknlst(i), 'TORPEDO'))  goto 2700
	  if (equal (tknlst(i), 'ENERGY'))  goto 3400
	  if (equal (tknlst(i), 'DAMAGE'))  goto 4100
	  if (equal (tknlst(i), RADIO3))  goto 4800
	  call out (syntax, 1)			!unknown switch
	  goto 5700

*	  Shield up/down, energy, and percentage of maximum possible

1000	  if (oflg)  1100, 1200, 1300
1100	  call out2c ('SH')     ;  goto 1400
1200	  call out (stat3M, 0)  ;  goto 1400
1300	  call out (stat3L, 0)
1400	  call osflt (shpcon(who,KSHCON)*shpcon(who,KSSHPC), obit)
	  if (oflg .ne. short)  call outc ('%')
	  call space
	  if (oflg .eq. short)  goto 5700
	  call oflt (shpcon(who,KSSHPC) * 25, obit)
	  call out (stat05,0)
	  if (oflg .ne. short)  call crlf
	  goto 5700

*	  Present ship location

1500	  if (oflg)  1800, 1600, 1700
1600	  call out (stat6M, 0)  ;  goto 1800
1700	  call out (stat6L, 0)
1800	  call prloc(shpcon(who,KVPOS), shpcon(who,KHPOS), 0, 0, 
     +	  KABS, SHORT)
	  if (oflg)  1900, 2000, 2000
1900	  call space  ;  goto 5700
2000	  call crlf        ;  goto 5700

*	  Present ship condition (green, yellow or red + docked)

2100	  if (oflg)  2400, 2200, 2300
2200	  call out (stat7M, 0)  ;  goto 2400
2300	  call out (stat7L, 0)
2400	  call ocond (shpcon(who,KSPCON))
	  if (oflg)  2500, 2600, 2600
2500	  call space  ;  goto 5700
2600	  call crlf        ;  goto 5700

*	  Number of photon torpedos left

2700	  if (oflg)  2800, 2900, 3000
2800	  call outc ('T')       ;  goto 3100
2900	  call out (stat8M, 0)  ;  goto 3100
3000	  call out (stat8L, 0)
3100	  call odec (shpcon(who,KNTORP), obit)
	  if (oflg)  3200, 3300, 3300
3200	  call space  ;  goto 5700
3300	  call crlf        ;  goto 5700

*	  Ship energy remaining

3400	  if (oflg)  3500, 3600, 3700
3500	  call outc ('E')       ;  goto 3800
3600	  call out (stat9M, 0)  ;  goto 3800
3700	  call out (stat9L, 0)
3800	  call oflt (shpcon(who,KSNRGY), obit)
	  if (oflg)  3900, 4000, 4000
3900	  call space  ;  goto 5700
4000	  call crlf        ;  goto 5700

*	  Present ship damage

4100	  if (oflg)  4200, 4300, 4400
4200	  call outc ('D')       ;  goto 4500
4300	  call out (sta10M, 0)  ;  goto 4500
4400	  call out (sta10L, 0)
4500	  call oflt (shpcon(who,KSDAM), obit)
	  if (oflg)  4600, 4700, 4700
4600	  call space  ;  goto 5700
4700	  call crlf        ;  goto 5700

*	  Present Sub-Space Radio status

4800	  if (oflg)  4900, 5000, 5100
4900	  call outc ('R')       ;  goto 5200
5000	  call out (radio3, 0)  ;  goto 5200
5100	  call out (radio1, 0)
5200	  if (shpdam(who,KDRAD) .lt. KCRIT)  goto 5300
	  call out (stat11, 0)  ;  goto 5400

5300	  if ((bits(who) .and. nomsg) .ne. 0)  call out2c ('Of')
	  if ((bits(who) .and. nomsg) .ne. 0)  call outc ('f')
	  if ((bits(who) .and. nomsg) .eq. 0)  call out2c ('On')
5400	  if (oflg)  5500, 5600, 5600
5500	  call space  ;  goto 5700
5600	  call crlf

5700	continue
	return

	end
