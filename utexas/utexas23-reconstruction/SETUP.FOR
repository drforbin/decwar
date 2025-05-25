C	This routine is called by SETUP if a player types CTL-C before
C	he has been completely 'created'.  This prevents the player
C	from attempting a 'continue' using the existing code.
C	CC2 is called instead if he has already chosen a side.

	subroutine CC1
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	numply = numply - 1
	call unlock (frelok)		! make sure we release the database
	call exit

	end
C	This routine is called by SETUP if a player types CTL-C before
C	he has been completely 'created'.  This prevents the player
C	from attempting a 'continue' using the existing code.
C	CC1 is called instead if he hasnt already chosen a side.


	subroutine CC2
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	numply = numply - 1
	numsid(team) = numsid(team) - 1
	call unlock (frelok)		! make sure we release the database
	call exit

	end
C	This routine checks all incoming players to see if they have
C	previously died in the present game.  If so, they are only
C	allowed to start the game if they have waited the prescribed
C	time, or are implementors of the game and know the password.

	subroutine KILCHK
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	include 'setext/nolist'
	external cc1
	common /local/ jobnum, nam1, nam2, ppn, ttynum, ttyspd

	PASFLG = .FALSE.
	call kqsrch (ttynum, jobnum, ppn, kindex)
	if (kindex .eq. 0)  return		!This player hasn't been killed

	timlft = KWAIT - etim(kilque(kindex,4))
	if (timlft .le. 0)  return		!he has been dead long enough

*.......Inform player of remaining time to wait

	call out (kilch4, 0)
	timlft = KWAIT - etim(kilque(kindex,4))
	if (timlft .lt. 1000)  timlft = 1000
	timlft = timlft / 1000
	minute = timlft / 60  ;  second = mod(timlft,60)
	call odec (minute,0)  ;  call out (kilch5, 0)
	call odec (second,0)  ;  call out (kilch6, 1)

*.......Countdown to restart, check for password input

	call cctrap(cc1)
	call out (kilch8, 0)
	call dmpbuf
	call echoff
	call otim (KWAIT - etim(kilque(kindex,4)))
 100	if (input (min0(5000, timlft)))  goto 300
	if (ENDFLG)  call endgam
	timlft = KWAIT - etim(kilque(kindex,4))
	if (timlft .le. 0)  goto 200
	call out (backup,0)
	call otim (timlft)
	call dmpbuf
	goto 100
 200	call crlf
	call echon
	return

 300	call gtkn
	call echon
	if (equal(tknlst(1),KPASS) .eq. -2)  return
C	if (lofchk(0)) call monit drforbin(merlyn)
	call cc1

	end
	subroutine PREGAM
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	include 'setext/nolist'
	common /local/ jobnum, nam1, nam2, ppn, ttynum, ttyspd

	call jobsta (jobnum, nam1, nam2, ppn, ttynum, ttyspd)
	if(ccflg) call monit		!added by drforbin for ctrl-C bug

  10	call ttyon
	call out (strtup, 0)		!PREGAME or <CR>
	call gtkn
	if (CCFLG .or. hungup)  call monit 
C	if (lofchk(0)) call monit drforbin(merlyn)-watch above line
	if (ntok .eq. 0)  return

	if (.not. equal (tknlst(1), 'HONORROLL')) goto 25
		call shosta (.true.)
		goto 10

25	if (.not. equal(tknlst(1), 'HELP'))  goto 20
	call hlpxtr
	call hlpall
	call ttyon  ;  goto 10

  20	if (.not. equal(tknlst(1), 'PREGAME'))  goto 10
	
	call out (pgame1, 1)		!inform player he is in Pre-game
					!tell him of ACTIVATE command
	call out ('Use the HO command to view the honor roll.', 1)
C	if (.not. chkpay(0)) goto 50 drforbin(merlyn)
	call out('Use the DO command to purchase', 1)
	call out('documentation for DECWAR.', 1)

  50	call xgtcmd (n)          	!get next command to execute

	goto (100,305,200,300,310,400,500,600,710,700,800,810,900, 
     +		1000,1100,1200), n


 100	call prgnam ('DECWAR')		!activate
	return
 200	call gripe			!gripe
	goto 50
 300	call help			!help
	goto 50
C	305	call pdwdoc		!drforbin edit
305	call out ('This is where CompuServe rips you off for 
     + Documentation!',1)
C	305	if (chkpay(0)) call pdwdoc drforbin(merlyn)		! print DECWAR.DOC
	goto 50				! purchase DECWAR documentation
 310	call shosta (.true.)		! Honor Roll
	goto 50
 400	call news			!news
	goto 50
 500	call points (.FALSE.)		!points
	goto 50
 600	call monit			!quit
	goto 50
 710	call set			! set
	goto 50
 700	call summar			!summary
	goto 50
 800	call time			!time
	goto 50
 810	call type			! type
	goto 50
 900	call users			!users
	goto 50
1000	call debug			!*debug
	goto 50
1100	call paswrd			!*password
	goto 50

1200	if (pasflg) call stazap
	goto 50
	end
C	This routine is called whenever a new player enters the game.
C	If he is the first player, the Romulan and black hole options
C	are discussed, and the Universe and other high-segment variables
C	are initialized.  Later players are told whether the Romulan or
C	black holes are present in the game, and their high-segment
C	areas are setup for play.  It is not possible to continue a
C	game which was CTL-C while still in SETUP.

	subroutine SETUP
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	include 'setext/nolist'
	external cc1			!^C trap routine to prevent continuing
	external cc2			!^C trap routine during ship selection
	external trap			!^C trap routine to allow continuing
	external clrbuf			!^C trap routine to clear input buffer
	common /local/ jobnum, nam1, nam2, ppn, ttynum, ttyspd
	data numply /0/			!these aren't constants!
	data numsid(1), numsid(2) /0, 0/
	data tim0 /-1/

	who = 0
	call	frcchk			! force scan of jobsequence numbers
	call crlf
	call jobsta (jobnum, nam1, nam2, ppn, ttynum, ttyspd)
	if (numply .ne. KNPLAY)  goto 100
	call out (setu01, 1)		!all ships in use
	call kilhgh			! remove high seg from swapper
	call start			! try a run to new segment
	call exit


 100	call cctrap			!turn off ^C
101	call lock (frelok)		! lock out other users
	if (hungup .or. ccflg) call exit	! get out if ^C or hung up
	if (lkfail) goto 101		! we must lock others out!
	numply = numply + 1		!number of players
	if (CCFLG .or. hungup)  call cc1
	call cctrap(cc1)

	call setran (daytim (d))
	if (tim0 .lt. 0)  goto 200
	if ((numply .ne. 1) .or. ((hitime-daytim(d)) .gt. 0))  goto 1200	!universe already set up?
 200	call blkset (hfz, 0, locf(hlz) - locf(hfz) + 1)
	tim0 = daytim (d)		!get initial start time

*.......Regular or Tournament game?

	call setqh  ;  call setqm	!set up the hit and message queues
C	goto 600			!set to enable choice (drforbin)
 300	call out (setu02, 0)
	call gtkn
	if (CCFLG) goto 700	!in case the user typed ^C
	if (hungup) call cc1
C	if (lofchk(0)) call cc1 drforbin(merlyn)
	if (typlst(1) .eq. KEOL)  goto 600
	if (equal (tknlst(1), 'TOURNAMENT'))  goto 400
	if (equal (tknlst(1), 'REGULAR'))  600, 300
 400	i = 2
	if (typlst(2) .ne. KEOL)  goto 500
	i = 1
	call out (setu03, 0)
	call gtkn
	if (CCFLG)  goto 700
	if (hungup) call cc1
C	if (lofchk(0)) call cc1 drforbin(merlyn)
 500	call setran (iabs(tknlst(i)))

*.......Romulan option?

600	ROMOPT = .TRUE.		
C	601	call out (setu06, 1)	!added drforbin
C	goto 700			!added by drforbin
	call out (setu04, 0)
	call gtkn
	if (CCFLG)  goto 700
	if (hungup) call cc1
C	if (lofchk(0)) call cc1 drforbin(merlyn)
	if (typlst(1) .eq. KEOL)  goto 700
	if ((.not. equal(tknlst(1), 'YES')) .and. 
     +	(.not. equal(tknlst(1), 'NO')))  goto 600
	if (equal (tknlst(1), 'NO'))  ROMOPT = .FALSE.

*.......Initialize universe

 700	ROM = .FALSE.
	do 800 j = 1 , 2
	do 800 i = 1 , KNBASE
	  base(i,3,j) = 1000
	  base(i,4,j) = j
 800	continue
	nbase(1) = 10
	nbase(2) = 10
	call blkset (alive, 1, KNPLAY)

*.......Determine number of stars and insert bases and planets.

	nstar  = int(51 * ran(0)) * 5 + 100
	nhole  = int(41.0 * ran(0) + 10)
c--	nplnet = int(20.0 + ran(0) * 61.0)
	nplnet = 60			! ALWAYS insert max. # of planets
	do 900 i = 1 , KNBASE
	  call place (((DXFBAS*100) + i), 1, base(i,KVPOS,1), 
     +	  base(i,KHPOS,1))
	  call place (((DXEBAS*100) + i), 1, base(i,KVPOS,2), 
     +	  base(i,KHPOS, 2))
 900	continue
	do 1000 i = 1 , nplnet
	  call place (((DXNPLN*100) + i), 1, locpln(i,KVPOS), 
     +	  locpln(i,KHPOS))
1000	continue
	call place (dxstar*100, nstar, dm1, dm2)
	if (CCFLG .or. hungup)  goto 1400

*.......Black hole option?
C	all comments below inserted by drforbin
C	BLHOPT = .FALSE.
C	if (ran(0) .lt. 0.75) goto 1400
C	blhopt = .true.
C	call out (setu07, 1)
C	goto 1400

1100	call out (setu05, 0)
	call gtkn
	if (CCFLG .or. hungup)  goto 1400
C	if (lofchk(0)) goto 1400 drforbin(merlyn)
	if (typlst(1) .eq. KEOL)  goto 1400
	if (.not. (equal(tknlst(1), 'YES') .or. 
     +	equal(tknlst(1), 'NO')))  goto 1100
	if (equal (tknlst(1), 'YES'))  BLHOPT = .TRUE.
	if (BLHOPT)  call place ((DXBHOL*100), nhole, i, j)
	goto 1400

*.......Inform later players of type of game set up

1200	if (.not. ENDFLG)  goto 1300
	call kilhgh
	call out (nogal1,1)
	call exit

1300	continue
	if (ROMOPT)  call out (setu06,1)
	if (BLHOPT)  call out (setu07,1)

*.......Set up individual player

1400	if (CCFLG .or. hungup) call cc1	!let him out if he typed ^C already
	call cctrap (CC1)	!exit on ^C, but zero the guy out first

*.......Determine which side he will go on.

	ttytyp = 8
	call kqsrch (ttynum, jobnum, ppn, kindex)
	if (kindex .eq. 0)  goto 1600
	team = kilque(kindex,5) .and. "777777
	who  = kilque(kindex,5)/"1000000
	if (numsid(team) .lt. knplay/2) goto 1410
	if(team.eq.1)call out('Sorry, Captain, but the Federation', 1)
	if(team .eq. 2) call out ('Sorry, Captain, but the Empire', 1)
	call out ('fleet is at capacity.', 1)
	call out ('Do you wish to defect? ',0)
	call gtkn
	if (ccflg .or. hungup) call cc1
C	if (lofchk(0)) call cc1 drforbin(merlyn)
	if (typlst(1) .eq. keol) call cc1
	if (equal (tknlst(1), 'YES')) goto 1401
		call cc1
1401	team = team + 1
	if (team .eq. 3) team = 1
	goto	1900			! he has defected

1410	if (alive(who) .gt. 0) goto 1420	! keep same ship if possible
	call out ('Sorry, Captain, but the', 0)
	call out2w (names(who, 1), names(who, 2))
	call crlf
	call out ('has been reassigned.', 1)
	call out ('Do you wish to choose another ship? ', 0)
	call gtkn
	if (ccflg .or. hungup) call cc1
C	if (lofchk(0)) call cc1 drforbin(merlyn)
	if (typlst(1) .eq. keol) call cc1
	if (equal (tknlst(1), 'YES')) goto 1900
		call cc1

1420	call cctrap(0)			! clear ^C trap
	numsid(team) = numsid(team) + 1
	numshp(team) = numshp(team) + 1
	call cctrap (cc2)
	if (ccflg .or. hungup) call cc2	! get out
	goto 2500

1600	call out (setu16,0)
	call odec (numsid(1),0)
	call out (setu17,0)
	call odec (numsid(2),0)
	call out (stu17a, 0)
	if (iabs (numsid(1) - numsid(2)) .lt. 2)  goto 1700
	team = 1
	if (numsid(1) .gt. numsid(2))  team = 2
	goto 1900
1700	call out (setu18,0)
	call gtkn
	if (CCFLG .or. hungup)  call cc1
C	if (lofchk(0)) call cc1 drforbin(merlyn)
	if (.not. (typlst(1) .eq. KEOL))  goto 1800
	team = 1
	if (numsid(1) .gt. numsid(2))  team = 2
	goto 1900
1800	if (.not. (equal(tknlst(1), 'FEDERATION') .or. 
     +	equal(tknlst(1), 'EMPIRE')))  goto 1700
	team = 1
	if (equal (tknlst(1), 'EMPIRE'))  team = 2
1900	call cctrap(0)		! kill ^C trap
	numsid(team) = numsid(team) + 1
	numshp(team) = numshp(team) + 1
	call cctrap (CC2)
	if (ccflg .or. hungup) call cc2
	if (team .eq. 2)  goto 2000
	call out (setu11,1)
	ibeg = 1
	iend = KNPLAY / 2
	goto 2100
2000	call out (setu12,1)
	ibeg = (KNPLAY / 2) + 1
	iend = KNPLAY
2100	call out (setu13,2)
	do 2200 i = ibeg , iend
	  if (alive(i) .le. 0)  goto 2200
	  call out2w (names(i,1), names(i,2))
	  call crlf
2200	continue
	call out (setu14,0)
	call gtkn
	if (CCFLG .or. hungup)  call cc2
C	if (lofchk(0)) call cc2 drforbin(merlyn)
	do 2300 who = 1, KNPLAY
	  if (equal (tknlst(1), names(who,1)))  goto 2400
2300	continue
	goto 2100
2400	if ((who .lt. ibeg) .or. (who .gt. iend))  goto 2100
	if (alive(who) .gt. 0)  goto 2500
	call out (setu15,1)
	goto 2100

*.......Initialize player's high and low-segments

2500	call unlock(frelok)		! release the interlock
	call	updcap (who)		! update mission #
	do 2501 i = 1, knpoin		! zap his score
2501		score(i, who) = 0
	alive(who) = .TRUE.	!reserve his chosen ship

	group (1,1) = 'ALL'         ;  group (1,2) = "1777
	group (2,1) = 'KLINGON'     ;  group (2,2) = "1740
	group (3,1) = 'EMPIRE'      ;  group (3,2) = "1740
	group (4,1) = 'HUMAN'       ;  group (4,2) = "000037
	group (5,1) = 'FEDERATION'  ;  group (5,2) = "000037
	group (6,1) = 'FRIENDLY'    ;  group (6,2) = group (5-team,2)
	group (7,1) = 'ENEMY'       ;  group (7,2) = group (2+team,2)

	call cctrap (clrbuf)		 !clear input buffer on ^C
	call jobsta ( 
     +		job(who,KJOB),
     +		job(who,KNAM1),
     +		job(who,KNAM2),
     +		job(who,KPPN),
     +		job(who,KTTYN),
     +		job(who,KTTYSP)
     +		    )
	job(who,KTTYTP) = ttytyp
	job(who,KJOBTM) = daytim (d)
	job(who,KRUNTM) = runtim (d)
	do 2600 i = 1, 10
	  shpcon(who,i) = 0
2600	continue
	do 2700 i = 1, KNDEV
	  shpdam(who,i) = 0
2700	continue
	ttyspd = 9600
	do 2800 i = 1 , KNPLAY
	  if (.not. alive(who))  goto 2800
	  if (job (i,KTTYSP) .lt. ttyspd)  ttyspd = job(i,KTTYSP)
2800	continue
	if (ttyspd .le. 1200)  slwest = 3
	if (ttyspd .eq. 1200)  slwest = 2
	if (ttyspd .gt. 1200)  slwest = 1
	if (ttyspd .eq. 0)     slwest = 1
	shpcon(who,KSPCON) = GREEN
	shpcon(who,KNTORP) = 10
	shpcon(who,KSHCON) = 1
	shpcon(who,KLFSUP) = 5
	shpcon(who,KSNRGY) = 50000
	shpcon(who,KSSHPC) = 1000

	return

	end
C	This routine processes command strings during the pre-game
C	(before a side and ship have been chosen).

	subroutine XGTCMD (cmd)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	include 'setext/nolist'
	dimension precmd(2,KNPCMD)
	data ((precmd(i,j), i = 1, 2), j = 1, KNPCMD)/ 
     +	  'Activ', 'ate  ',
     +    'DOcum', 'ent  ',
     +	  'Gripe', '     ',
     +	  'Help ', '     ',
     +    'HOnor', 'roll ',
     +	  'News ', '     ',
     +	  'Point', 's    ',
     +	  'Quit ', '     ',
     +	  'Set  ', '     ',
     +	  'Summa', 'ry   ',
     +	  'TIme ', '     ',
     +    'TYpe ', '     ',
     +	  'Users', '     ',
     +	  '*Debu', 'g    ',
     +	  '*Pass', 'word ',
     +    '*Zap ', '     '/

 100	call crlf
	CCFLG = .FALSE.
	call out2c ( 'PG' )  ;  call out2c ( '> ' )
	call dmpbuf			!dump output buffer
 200	if (input(10000))  goto 400	!command input?
	goto 200

 400	call gtkn
	if (CCFLG .or. hungup)  call monit		!^C was typed
C	if (lofchk(0)) call monit drforbin(merlyn)			! time is up!
	if (typlst(1) .eq. KEOL)  goto 100
	cmd = 0

	do 700 i = 1, KNPCMD		!identify command
	  if (.not. (equal(tknlst(1), precmd(1,i))))  goto 700
	  if (cmd .ne. 0)  goto 800
	  cmd = i
 700	continue
	if (cmd)  800,900,1300 !will never take the neg branch

 800	call out (ambcom, 0)		!input is ambiguous
	goto 1200

 900	do 1000 i = 1, KNCMD		!a 'main-game command only?
	  if (equal(tknlst(1), isaydo(1,i)))  goto 1100
1000	continue
	call out (unkcom, 0)		!input is trash!
	goto 1200

1100	call out (maicom, 0)		!input not valid in pre-game
1200	call out (forhlp, 1)
	goto 100

1300	return

	end
C	When DECWAR is STARTed, the startup routine will ensure that
C	all code through Z is present, else DECWAR will be run over
C	again.

	subroutine Z
	end
