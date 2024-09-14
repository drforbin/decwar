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


C	This routine processes the information stored in the hit queue,
C	printing out the text produced during battles, primarily.
C	This information is stored in the hit queue using MAKHIT, and
C	is retrieved by OUTHIT using GETHIT.  The 'type' of message is
C	coded into the variable IWHAT:  1=phaser hit, 2=torpedo hit,
C	3=torpedo deflection, 4=torpedo miss, 5=tordedo into black hole,
C	6=star unaffected by torpedo, 7=star goes nova, 8=star damages
C	someone, 9=galaxy-wide base request for assistance, 10=galaxy-
C	wide report of base destroyed, 11=romulan detected message,
C	12=ship-to-ship energy transfer, 13=Tractor beam activated,
C	14=Tractor beam broken, 15=torpedo neutralized.

	subroutine OUTHIT
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

 100	call blkset (iwhat, 0, 17) 			!zero out hit info
	if (hitflg(who) .eq. 0)  return			!any(more) hit messages?
	if (oflg .eq. long)  call crlf
	call gethit (who)				!get next message off hit queue

*.......Go to proper section of code depending on type of message

	goto (200,200,200,4600,4600,200,200,200,6000,6000,6800,6900, 
     +	7300,7600,4600)  iwhat
	goto 100

*.......Phaser, Photon, and Star hits

 200	call odisp (dispfr, 0)				!display hitter
	nplcf = dispfr / 100  ;  nplct = dispto / 100
	if ((nplcf .lt. DXNPLN) .or. (nplcf .gt. DXEPLN))  goto 300
	if (shstfr .eq. 0)  goto 300
	if (oflg .eq. LONG)  call outc ('(')
	call odec (shstfr, 0)
	if (oflg .eq. LONG)  call outc (')')

 300	call space
	call prloc (Vfrom, Hfrom, 0, 0, ocflg, oflg)	!display hitter's location
	if ((oflg .ne. short) .and. (nplcf .lt. DXROM))  call outc (',')

*	Display hitter's shield strength (if ship or base)

	if (nplcf .gt. DXROM)  goto 400			!if hitter romulan or star, jump
	call space
	call osflt (shcnfr*shstfr , 0)			!hitter's shield %
	if (oflg .ne. short)  call outc ('%')

 400	call space
	if (iwhat .ne. 7)  goto 800			!star goes nova?

*	Star goes nova message.  (IWHAT = 7)

	if (oflg)  500, 500, 600
 500	call outc ('N')  ;  goto 700
 600	call out (outh01 , 0)
 700	call crlf
	goto 100

 800	if (iwhat .ne. 6)  goto 1200			!star unaffected?

*	Star unaffected by torpedo message.  (IWHAT = 6)

	if (oflg)  900, 900, 1000
 900	call outc ('U')  ;  goto 1100
1000	call out (star02 , 0)
1100	call crlf
	goto 100

1200	if (iwhat .ne. 3)  goto 1500			!torpedo deflection?

*	Torpedo deflected by shields.  (IWHAT = 3)

	if (oflg)  1500, 1300, 1400
1300	call out (outh29, 0)  ;  goto 2500
1400	call out (outh30, 0)  ;  goto 2500

*	Someone is getting damaged.

1500	if (oflg .eq. long)  call out (outh02 , 0)	!'makes'
	call space
	if ((nplct .gt. DXROM) .and. (iwhat .ne. 8))  goto 1900	!romulan or planet hit by star?
	if (nplct .gt. DXROM)  goto 1600		!hittee a romulan or planet?
	call oflt (ihita , 0)				!size of hit
	if (oflg .ne. short)  call out (outh03 , 0)	!' unit '
	if (iwhat .ne. 8)  goto 1900			!not a nova?

*	Star damages someone.  (IWHAT = 8)

1600	if (oflg)  1700, 1700, 1800
1700	call outc ('N')        ;  goto 2500
1800	call out (outh04 , 0)  ;  goto 2500

1900	if (iwhat .eq. 1)  goto 2200			!phasers or torpedoes?

*	Torpedo hit.  (IWHAT = 2)

	if (oflg)  2000, 2000, 2100
2000	call outc ('T')        ;  goto 2500
2100	call out (outh05 , 0)  ;  goto 2500

*	Phaser hit.  (IWHAT = 1)

2200	if (oflg)  2300, 2300, 2400
2300	call outc ('P')  ;  goto 2500
2400	call out (outh06 , 0)

*	Begin printing information on Hittee.

2500	if (oflg)  2600, 2600, 2700
2600	call out2c ('  ')  ;  goto 2800
2700	if ((nplct .lt. DXROM) .and. (hcpos .gt. 40))  call crlf

2800	call odisp (dispto, 0)				!Display hittee
	if ((nplct .lt. DXNPLN) .or. (nplct .gt. DXEPLN))  goto 2900
	if (shstto .eq. 0)  goto 2900
	if (oflg .eq. LONG)  call outc ('(')
	call odec (shstto, 0)
	if (oflg .eq. LONG)  call outc (')')

2900	call space
	if (shjump .eq. 0)  goto 3300			!Displacement?

*	Hittee displaced by blast.

	if (oflg)  3200, 3000, 3100
3000	call out2c ('--')    ;  goto 3200
3100	call out (displc,0)  ;  goto 3400
3200	call outc ('>')      ;  goto 3400

3300	if (oflg .ne. short)  call outc ('@')		!print hittee's location
3400	call prloc (Vto, Hto, 0, 0, ocflg, SHORT)
	if ((nplct .gt. DXROM) .or. (klflg .ne. 0))  goto 3900	!no hittee shield info or hittee dead?
	if (oflg .ne. short)  call outc (',')
	call space
	call osflt (shcnto*shstto , 0)			!print hittee shield information
	if (oflg .ne. short)  call outc ('%')

*	Show any critical device damage, if you are the hittee!

	if (dispto .ne. (who + (team * 100)))  goto 3900
	if (critdv .eq. 0)  goto 4100			!anything damaged?
	call out2c ('; ')
	call odev (critdv)				!print device name
	if (oflg)  3500, 3600, 3700
3500	call space        ;  goto 3800
3600	call out (outh08 , 0)  ;  goto 3800
3700	call out (outh07 , 0)
3800	call oflt (critdm , 0)				!device damage
	if (oflg .eq. long)  call out (units1 , 0)	!' units'

*	Critical hit on base?

3900	if ((oflg .ne. LONG) .or. ((nplct .ne. DXFBAS) .and. 
     +	(nplct .ne. DXEBAS)))  goto 4100
	if ((klflg .eq. 0) .and. (critdm .eq. 0))  goto 4500
	call out2c ('  ')
	if (klflg .ne. 0)  call crlf
	call out (outh31, 1)
	if (oflg .ne. LONG)  goto 4100
	call out (outh32, 1)
	if (klflg .ne. 0)  goto 4000
	call out (outh33, 1)
	goto 4500
4000	call out (outh34, 0)


*	Hittee destroyed by hit?

4100	if (klflg .eq. 0)  goto 4500
	call space
	if (oflg .eq. long)  call crlf
	if (klflg .eq. 2)  goto 4400			!ship simply dead, or > black hole?
	call odisp (dispto, 0)				!ship > black hole!!
	if (oflg)  4200, 4200, 4300
4200	call out (outh10 , 1)  ;  goto 4400
4300	call out (outh09 , 1)
4400	call odisp (dispto, 1)				!'ship destroyed' message
	call out (destry , 1)
4500	call crlf
	goto 100					!get next hit message

*.......Torpedo missed, torpedo into black hole, torpedo neutralized

4600	if (oflg)  4700, 4700, 4800
4700	call outc ('T')  ;  goto 4900
4800	call out (tormis , 0)
4900	call odec (critdv,0)				!torpedo number
	if (iwhat - 5)  5000, 5400, 5700

*	Torpedo miss.  (IWHAT = 4)

5000	if (oflg)  5100, 5100, 5200
5100	call out (outh13 , 0)  ;  goto 5300
5200	call out (outh12 , 0)

5300	call prloc (Vto, Hto, 1, 0, ocflg, oflg)	!print location
	goto 100					!get next hit message
*	Torpedo into black hole.  (IWHAT = 5)

5400	if (oflg)  5500, 5500, 5600
5500	call out (outh15 , 0)  ;  goto 5300
5600	call out (outh14 , 0)  ;  goto 5300

*	Torpedo neutralized by friendly object.  (IWHAT = 15)

5700	if (oflg)  5800, 5800, 5900
5800	call out (outh28 , 0)  ;  goto 5300
5900	call out (outh27 , 0)  ;  goto 5300

*.......Base under attack, base destroyed

6000	if (shpdam(who,KDRAD) .gt. KCRIT)  goto 100	!if radio damaged, don't output
	if ((nomsg .and. bits(who)) .ne. 0)  goto 100	!if radio off, don't output
	call odisp (dispto, 1)				!output base 'name'
	call prloc (Vto, Hto, 0, 0, ocflg, oflg)
	if (iwhat .eq. 10)  goto 6400

*	Galaxy-wide request for assistance.  (IWHAT = 9)

	if (oflg)  6100, 6200, 6300
6100	call out2c (' A')  ;  call crlf  ;  goto 100
6200	call out (outh17 , 1)  ;  goto 100
6300	call out (outh16 , 1)  ;  goto 100

*	Galaxy-wide report of base destroyed.  (IWHAT = 10)

6400	if (oflg)  6500, 6600, 6700
6500	call out2c (' D')  ;  call crlf  ;  goto 100
6600	call out (outh19 , 1)  ;  goto 100
6700	call out (outh18 , 1)  ;  goto 100

*.......Romulan detected at ...  (IWHAT = 11)

6800	call odisp (dispfr, 1)
	if (oflg .eq. long)  call out (outh20 , 0)
	call space
	call prloc (Vfrom, Hfrom, 1, 0, ocflg, oflg)
	goto 100

*.......Ship-to-ship energy transfer.  (IWHAT = 12)

6900	call odisp (dispfr, 1)				!display sender's ship name
	if (oflg .eq. long)  call out (outh21 , 0)
	call oflt (ihita , 0)				!print size of energy transfer
	if (oflg)  7000, 7000, 7100
7000	call out2c (' >')  ;  goto 7200
7100	call out (outh22 , 0)
7200	call space
	call odisp (dispto, 1)				!display receiver's ship name
	call crlf
	goto 100					!get next hit message

*.......Tractor beam activated.  (IWHAT = 13)

7300	if (oflg)  7400, 7400, 7500
7400	call out (outh24 , 1)  ;  goto 100
7500	call out (outh23 , 1)  ;  goto 100

*.......Tractor beam broken.  (IWHAT = 14)

7600	if (oflg)  7700, 7700, 7800
7700	call out (outh26 , 1)  ;  goto 100
7800	call out (outh25 , 1)  ;  goto 100

	end
