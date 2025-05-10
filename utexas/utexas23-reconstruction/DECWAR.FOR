	program decwar
	include 'param'
	include 'hiseg'
	include 'lowseg'
	include 'extern'
	common /local/ dummy(locsiz)
	common /polocl/ total(9)
	external monit
	call blkset (lfz, 0, locf(llz) - locf(lfz) + 1)	!zero out low segment
	versio = 24					!version number
*	call royaln('CSIS86') drforbin(merlyn)
	oflg   = medium
	call out (decver, 1)
	call out ('Are you: ', 1)
	call out ('1 Beginner', 1)
	call out ('2 Intermediate', 1)
	call out ('3 Expert', 1)
	call out (' ', 1)
	call out ('Which? ', 0)
	call gtkn
	if(vallst(1).ne.1.and.(equal(tknlst(1),'BEGINNER').eq.0)) goto 2
		scnflg = long
		oflg   = medium
		prtype = 0
		icflg  = kabs
		goto 4
2	if(vallst(1).ne.2.and.(equal(tknlst(1),'INTERMEDIATE').eq.0)) 
     +		goto 3
		scnflg = long
		prtype = -1
		icflg  = krel
		oflg   = medium
		goto 4
3	if(vallst(1).ne.3.and.(equal(tknlst(1),'EXPERT').eq.0)) goto 4
		scnflg = short
		prtype = -1
		icflg  = krel
		oflg   = short
4	continue
	call type (1)
	call type (2)
	call summar
1	continue
	call pregam			!enter Pre-game stage
	call ttyon
	call setup			!start up player in game
	call aprset($9999)		! set up trap for data out of bounds
	call place ((100 * team) + who, 1, shpcon(who,KVPOS), 
     +	shpcon(who,KHPOS))
49	continue
  50	PLAYER = .TRUE.			!regular player, not a Romulan
d	call timin ('GETCMD')
	call getcmd (n)          	!get next command to execute
d	call timout('GETCMD')
	if (who .eq. 0) goto 1		! hmmm....he died, so reincarnate him!
	goto (100,200,300,400,500,600,700,800,900,1000,1100,1200, 
     +	1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,
     +	2400,2500,2600,2700,2800,2900,3000,3100,3200,3300) n
100	continue
d	call timin ('CMDBA ')
	call bases			! bases
d	call timout('CMDBA ')
	goto 50
200	continue
d	call timin ('CMDBU ')
	call build ($49)		! build
d	call timout('CMDBU ')
	goto 3400
300	continue
d	call timin ('CMDCA ')
	call captur ($49)
d	call timout('CMDCA ')
	goto 3400
400	continue
d	call timin ('CMDDA ')
 	call damage(2)          	!damages
d	call timout('CMDDA ')
	goto 50
500	continue
d	call timin ('CMDDO ')
	call dock ($49)
d	call timout('CMDDO ')
	goto 3400
600	continue
d	call timin ('CMDEN ')
	call energy
d	call timout('CMDEN ')
	goto 50
700	continue
d	call timin ('CMDGR ')
 	call gripe			!gripe
d	call timout('CMDGR ')
	goto 50
800	continue
d	call timin ('CMDHEL')
 	call help        		!help
d	call timout('CMDHEL')
	goto 50
900	continue
d	call timin ('CMDIMP')
	call impuls ($49)
d	call timout('CMDIMP')
	if (.not. alive(who))  3810, 3400
1000	continue
d	call timin ('CMDLIS')
	call list			!list
d	call timout('CMDLIS')
	goto 50
1100	continue
d	call timin ('CMDMOV')
	call move ($49)
d	call timout('CMDMOV')
	if (.not. alive(who))  3810, 3400
1200	continue
d	call timin ('CMDNEW')
	call news			!news
d	call timout('CMDNEW')
	goto 50
1300	continue
d	call timin ('CMDPHA')
	call phacon ($49)
d	call timout('CMDPHA')
	goto 3500
1400	continue
d	call timin ('CMDPLA')
	call planet             	!planets
d	call timout('CMDPLA')
	goto 50
1500	continue
d	call timin ('CMDPOI')
	call points (.FALSE.)		!points
d	call timout('CMDPOI')
	goto 50
1600	if (hungup) goto 3800	! don't ask if job is hungup
*	if (lofchk(0)) goto 3800 drforbin (merlyn)	! also if his time is up
	call out (sure00,0)		!quit
	ccflg = .false.
	call clear			! zap input buffer
	call gtkn
	if (equal(tknlst(1), 'YES'))  3800, 50
1700	continue
d	call timin ('CMDRAD')
	call radio			!radio
d	call timout('CMDRAD')
	goto 50
1800	continue
d	call timin ('CMDREP')
	call repair (1, $49)
d	call timout('CMDREP')
	goto 3400
1900	continue
d	call timin ('CMDSCA')
	call scan       		!scan
d	call timout('CMDSCA')
	goto 50
2000	continue
d	call timin ('CMDSET')
	call set			!set
d	call timout('CMDSET')
	goto 50
2100	continue
d	call timin ('CMDSHI')
	call shield			!shields
d	call timout('CMDSHI')
	goto 50
2200	continue
d	call timin ('CMDSRS')
	call srscan              	!srscan
d	call timout('CMDSRS')
	goto 50
2300	continue
d	call timin ('CMDSTA')
	call status (2)             	!status
d	call timout('CMDSTA')
	goto 50
2400	continue
d	call timin ('CMDSUM')
	call summar			!summary
d	call timout('CMDSUM')
	goto 50
2500	continue
d	call timin ('CMDTAR')
	call target             	!targets
d	call timout('CMDTAR')
	goto 50
2600	continue
d	call timin ('CMDTEL')
	call tell
d	call timout('CMDTEL')
	goto 49
2700	continue
d	call timin ('CMDTIM')
	call time			!time
d	call timout('CMDTIM')
	goto 50
2800	continue
d	call timin ('CMDTOR')
	call torp ($49)
d	call timout('CMDTOR')
	goto 3500
2900	continue
d	call timin ('CMDTRA')
	call tractr
d	call timout('CMDTRA')
	goto 49
3000	continue
d	call timin ('CMDTYP')
	call type(0)			!type
d	call timout('CMDTYP')
	goto 50
3100	continue
d	call timin ('CMDUSE')
	call users			!users
d	call timout('CMDUSE')
	goto 50
3200	continue
	call debug			!*debug
	goto 50
3300	call paswrd			!*password
	goto 50
*.......A time-consuming move has occurred ....
3400	call repair (3, $3500)
3500	continue
	dotime = dotime + 1
	if (dotime .lt. numply) goto 3501	! if time to do rebuilding etc
	dotime = 0
d	call timin ('BASPHA')
	call baspha			! activate enemy starbase defense
d	call timout('BASPHA')
d	call timin ('PLNATK')
	call plnatk			!activate neutral and enemy planets
d	call timout('PLNATK')
d	call timin ('BASBLD')
	call basbld			!partially rebuild enemy bases
d	call timout('BASBLD')
	if (ROMOPT)  call romdrv(d1,d2)	!activate Romulan?
3501	shpcon(who,KNTURN) = shpcon(who,KNTURN) + 1	!update stardate
	tmturn(team) = tmturn(team) + 1
*	Critical life-support damage warning
	if (shpdam(who,KDLIFE) .lt. KCRIT)  goto 3600
	if (.not. docked(who)) shpcon(who,KLFSUP) = shpcon(who,KLFSUP) - 1	!reduce life-support reserves
	if (shpcon(who,KLFSUP) .lt. 0)  shpcon(who,KSDAM) = KENDAM	!life-support gone?
	if (prtype)  goto 3600
	call out (lifdam,0)
	call odec (shpcon(who,KLFSUP),0)
	call out (strdat,1)
*	Update scoring information
3600	do 3700 i = 1, KNPOIN
	  score(i, who) = score(i, who) + tpoint(i)
	  tmscor(team,i) = tmscor(team,i) + tpoint(i)
	  tpoint(i) = 0
3700	continue
	goto 49
9999	call crlf
	call crlf
	i = iran(5)		! five fatal messages
	goto (5001, 5002, 5003, 5004, 5005), i
5001	call out ('The Romulans have devised a fiendish new',1)
	call out ('weapon!  Your ship and crew have been',1)
	call out ('reduced to quarks and now reside in the',1)
	call out ('Romulan''s energy banks!',1)
	goto 3810
5002	call out ('Your Navigation officer contracted a strange', 1)
	call out ('virus during R&R on Zzarpion III.  The Medical', 1)
	call out ('officer has been uable to diagnose it or to', 1)
	call out ('devise a cure or vaccine for it.  Your entire', 1)
	call out ('crew became infected, and all have died, including', 1)
	call out ('you.', 1)
	goto 3810
5003	call out ('Due to a design error, the Doomsday Device aboard', 1)
	call out ('your vessel has detonated.  The error, a missing', 1)
	call out ('instruction in the built-in microprocessor, will', 1)
	call out ('remain undetected for several decades.', 1)
	goto 3810
5004	call out ('An ancient Romulan space mine has exploded,', 1)
	call out ('flooding your ship with deadly radiation.', 1)
	call out ('You are forgiven, Captain, for not noticing the',1)
	call out ('mine, since it was constructed of a special', 1)
	call out ('plastic which is nearly transparant to most', 1)
	call out ('forms of radiation.  Perhaps your crew also', 1)
	call out ('forgave you as they disintegrated in a blaze', 1)
	call out ('of glory!', 1)
	goto 3810
5005	call out ('I regret to report, Captain, that your', 1)
	call out ('ship''s computer became defective, and', 1)
	call out ('consequently you have flown into a', 1)
	call out ('massive star.  The star''s gravitation has', 1)
	call out ('torn your ship apart.', 1)
	goto 3810
*.......Player dead or quitting
3810	continue
3800	call cctrap			! disable ^C trapping, if any
	txppn = job(who, kppn)
	txnm1 = job(who, knam1)
	txnm2 = job(who, knam2)
	txsh1 = names (who, 1)
	txsh2 = names (who, 2)
	txtim = etim(job(who, KJOBTM))
	txwhy = -1
	if (addrck) txwhy = 0	! hmmmm....he seems to have died!
	txtem = team - 1
	call points (.TRUE.)		!show final point totals
	txtot = total (1)
	call updsta (txppn,txnm1,txnm2,txsh1,txsh2,txtot,txtim,txwhy, 
     +	txtem, who)
	call free (who)			! release the ship
	who = 0
	call exit
*	call onexit ;drforbin added
	end
C	This routine is activated whenever any player (or the Romulan)
C	makes a time-consuming move.  It's purpose is to strengthen
C	weakened starbases of the opposite team.  The Romulan rebuilds
C	both side's starbases.  The percentage gain in base energy per
C	BASBLD call is reduced as the number of players increase.
	subroutine BASBLD
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	ib = 1  ;  ie = 2  ;  n = 50 / (numply + 1)
	if (.not. PLAYER)  goto 100		!Romulan?
	if (team .eq. 1)  ib = 2  ;  ie = ib
	n = 25 / numsid(team)
 100	do 300 j = ib, ie
	  do 200 i = 1, KNBASE
	    if (base(i,3,j) .le. 0)  goto 200	!is base dead?
	    base(i,3,j) = min0 (base(i,3,j) + n, 1000)
 200	  continue
 300	continue
	return
	end
C	This routine is activated whenever a starbase or captured
C	planet is destroyed.  The purpose of the routine is to check
C	whether any adjacent ships were docked at this object at the
C	time of the attack, and reset their ship's condition to RED
C	if true.  ITYPE = team of destroyed port.
	subroutine BASKIL (itype)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	ib = 1  ;  ie = KNPLAY
	if (itype .eq. 1)  ie = KNPLAY / 2
	if (itype .eq. 2)  ib = (KNPLAY / 2) + 1
	do 400 i = ib, ie
	  if (.not. docked(i))  goto 400	!is he docked?
*.........Check for adjacent starbase
	  if (nbase(itype) .le. 0)  goto 200	!any bases alive?
	  do 100 j = 1, KNBASE
	    if (base(j,3,itype) .le. 0)  goto 100
	    if (ldis(shpcon(i,KVPOS), shpcon(i,KHPOS), 
     +	    base(j,KVPOS,itype), base(j,KHPOS,itype), 1))  goto 400
 100	  continue
*.........Check for adjacent friendly planet
 200	  if (numcap(itype) .le. 0)  goto 400	!any friendly planets?
	  do 300 j = 1, nplnet
	    if ((itype + DXNPLN) .ne. dispc(locpln(j,KVPOS), 
     +	    locpln(j,KHPOS)))  goto 300
	    if (ldis(shpcon(i,KVPOS), shpcon(i,KHPOS), locpln(j,KVPOS), 
     +	    locpln(j,KHPOS), 1))  goto 400
 300	  continue
*.........No adjacent friendly port, undock player.
	  shpcon(i,KSPCON) = RED
	  docked(i) = .FALSE.
 400	continue
	return
	end
C	This routine controls the phaser defenses of the starbases.
C	These defenses are activated whenever a player (or the Romulan)
C	performs a time-consuming move.  A player only activates the
C	opposite team's starbases, with the Romulan activating both
C	side's bases.
	subroutine BASPHA
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	jb = 1  ;  je = 2
	if (.not. PLAYER)  goto 100			!Romulan?
	jb = 3 - team  ;  je = jb
 100	do 500 i = jb, je
	  if (nbase(i) .le. 0)  goto 500		!active bases?
	  do 400 j = 1, KNBASE
	    if (base(j,3,i) .le. 0)  goto 400		!base alive?
*...........Attack the players
	    do 300 k = (KNPLAY/2) * (2 - i) + 1, (KNPLAY/2) * (3 - i)
	      if (.not. alive(k))  goto 300		!player dead?
	      if (disp(shpcon(k,KVPOS), shpcon(k,KHPOS)) .le. 0) 
     +	      goto 300					!player cloaked?
	      if (.not. ldis(shpcon(k,KVPOS), shpcon(k,KHPOS), 
     +	      base(j,KVPOS,i), base(j,KHPOS,i), 4))  goto 300	!player in range?
	      Vfrom = base(j,KVPOS,i)  ;  Hfrom = base(j,KHPOS,i)
	      Vto   = shpcon(k,KVPOS)  ;  Hto   = shpcon(k,KHPOS)
	      dispto = (DXFSHP + (2 - i)) * 100 + k  ;  iwhat = 1
	      dispfr = (DXFBAS + (i - 1)) * 100 + j  ;  shjump = 0
	      id = pdist (Vfrom, Hfrom, Vto, Hto)
	      call phadam (3-i, k, id, 200/numply, .FALSE.)	!hit him!
	      tmscor(i,KPEDAM) = tmscor(i,KPEDAM) + ihita
	      shstfr = base(j,3,i)       ;  shcnfr = 1
	      if (klflg .ne. 0) tmscor(i,KPEKIL) = tmscor(i,KPEKIL) + 5000
 200	      call pridis (shpcon(k,KVPOS), shpcon(k,KHPOS), KRANGE, 
     +        team, 0)
	      call pridis (shpcon(k,KVPOS), shpcon(k,KHPOS), 4, 0, 1)
	      dbits = dbits .or. bits(k)
	      call makhit				!send hit message
 300	    continue
*...........Attack the Romulan (if he's alive)
	    if (.not. ROM)  goto 400		!Romulan alive?
	    if (.not. ldis (locr(KVPOS), locr(KHPOS), base(j,KVPOS,i),
     +	    base(j,KHPOS,i), 4))  goto 400	!Romulan in range?
	    dispto = DXROM * 100  ;  shjump = 0
	    dispfr = (DXFBAS + (i - 1)) * 100 + j  ;  iwhat = 1
	    Vfrom = base(j,KVPOS,i)  ;  Hfrom = base(j,KHPOS,i)
	    Vto   = locr(KVPOS)      ;  Hto   = locr(KHPOS)
	    id = pdist (Vfrom, Hfrom, Vto, Hto)
	    call pharom (200/numply, id)		!hit Romulan!
	    shstfr = base(j,3,i)  ;  shcnfr = 1
	    shstto = erom         ;  shcnto = 1
	    call pridis (locr(KVPOS), locr(KHPOS), KRANGE, 0, 0)
	    tmscor(i,KPRKIL) = tmscor(i,KPRKIL) + ihita
	    if (.not. ROM)  tmscor(i,KPRKIL) = tmscor(i,KPRKIL) + 5000
	    call makhit				!send hit message
 400	  continue
 500	continue
	return
	end
C	block data code
	BLOCK DATA
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	data (device(i), i = 1, KNDEV)/ 
     +	  2HSH, 2HWA, 2HIM, 2HLS, 2HTO, 2HPH, 2HCO, 2HRA, 2HTR /
	data ((isaydo(i,j), i = 1, 2), j = 1, KNCMD)/ 
     +	  'BAses', '     ',
     +	  'BUild', '     ',
     +	  'Captu', 're   ',
     +	  'DAmag', 'es   ',
     +	  'DOck ', '     ',
     +	  'Energ', 'y    ',
     +	  'Gripe', '     ',
     +	  'Help ', '     ',
     +	  'Impul', 'se   ',
     +	  'List ', '     ',
     +	  'Move ', '     ',
     +	  'News ', '     ',
     +	  'PHase', 'rs   ',
     +	  'PLane', 'ts   ',
     +	  'POint', 's    ',
     +	  'Quit ', '     ',
     +	  'RAdio', '     ',
     +	  'REpai', 'r    ',
     +	  'SCan ', '     ',
     +	  'SEt  ', '     ',
     +	  'SHiel', 'ds   ',
     +	  'SRsca', 'n    ',
     +	  'STatu', 's    ',
     +	  'SUmma', 'ry   ',
     +	  'TArge', 'ts   ',
     +	  'TEll ', '     ',
     +	  'TIme ', '     ',
     +	  'TOrpe', 'dos  ',
     +	  'TRact', 'or   ',
     +	  'TYpe ', '     ',
     +	  'Users', '     ',
     +	  '*Debu' ,'g    ',
     +	  '*Pass' ,'word '/
	data ((xhelp(i,j), i = 1, 2), j = 1, KNXTR)/ 
     +	  'CTL-C', '     ',
     +	  '     ', '     ',
     +	  'INTRO', '     ',
     +	  'HInts', '     ',
     +	  'INput', '     ',
     +	  'Outpu', 't    ',
     +	  'PAuse', 's    ',
     +	  'PRega', 'me   '/
	data ((ttydat(i,j), i = 1, 2), j = 1, KNTTY)/ 
     +	  'ACT-I', 'V    ',
     +	  'ADM-2', '     ',
     +	  'ADM-3', 'A    ',
     +	  'DATAP', 'OINT ',
     +	  'ACT-V', '     ',
     +	  'SOROC', '     ',
     +	  'BEEHI', 'VE   ',
     +	  'CRT  ', '     '/
	data ((names(i,j), j = 1, 3), i = 1, KNPLAY)/ 
     +	  'Excal', 'ibur ', ' E',
     +	  'Farra', 'gut  ', ' F',
     +	  'Intre', 'pid  ', ' I',
     +	  'Lexin', 'gton ', ' L',
     +	  'Nimit', 'z    ', ' N',
     +	  'Savan', 'nah  ', ' S',
     +	  'Trent', 'on   ', ' T',
     +	  'Vulca', 'n    ', ' V',
     +	  'Yorkt', 'own  ', ' Y',
     +	  'Buzza', 'rd   ', ' B',
     +	  'Cobra', '     ', ' C',
     +	  'Demon', '     ', ' D',
     +	  'Gobli', 'n    ', ' G',
     +	  'Hawk ', '     ', ' H',
     +	  'Jacka', 'l    ', ' J',
     +	  'Manta', '     ', ' M',
     +	  'Panth', 'er   ', ' P',
     +	  'Wolf ', '     ', ' W'/
	data (bits(i), i = 1, 10)/ 
     +	"1, "2, "4, "10, "20, "40, "100, "200, "400, "1000/
	data (sbits(i), i = 0, 2)/ NEUBIT , FEDBIT , EMPBIT /
	data (cmdbts(i), i = 1, KNCMD)/ 
     +	  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     +	  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0/
	end
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
C	This routine is used to capture neutral or enemy planets.
C	Player must be adjacent to planet specified (in 'orbit').
C	If a planet has been fortified by the enemy (using the BUILD
C	command), the pause time is increased 1 second and the
C	attacking ship's energy is reduced 50 units for each BUILD.
	subroutine CAPTUR (*)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	v = etim (tim0) + 5000
	tem = locate(2)
 100	if (tem .lt. 0)  return 1		!abort 'capture'
	if (tem .ne. 0)  goto 200
	tem = reloc(2)
	goto 100
 200	Vloc = vallst(1)  ;  Hloc = vallst(2)
	if (.not. ldis(shpcon(who,KVPOS), shpcon(who,KHPOS), Vloc, 
     +	Hloc, 1))  goto 500			!adjacent to sector specified?
	c = dispc (Vloc, Hloc)
	if ((c .lt. DXNPLN) .or. (c .gt. DXEPLN))  goto 400	!is there a planet here?
	if (c .eq. (DXNPLN + team))  goto 600	!planet already captured?
*.......Capture planet for the good guys!
300	call lock (plnlok,'CAPTUR')		!lock LOCPLN array
	if (.not. lkfail) goto 301
	call out ('The planet''s government refuses to surrender.', 1)
	return	1
301	tcap = c - DXNPLN
	if (tcap .ne. 0)  call pridis (Vloc, Hloc, KRANGE, tcap, 0)
	call pridis (Vloc, Hloc, 4, 0, 1)
*.......Update planet information
	i = dispx (Vloc, Hloc)
	if (tcap .ne. 0)  call baskil (tcap)
	if (tcap .ne. 0)  numcap(tcap) = numcap(tcap) - 1
	numcap(team) = numcap(team) + 1
	phit = 50 + (30 * locpln(i,3))		!set planet's phaser strength
	shstfr = locpln(i,3)
	v = v + locpln(i,3) * 1000
	shpcon(who,KSNRGY) = shpcon(who,KSNRGY) - locpln(i,3) * 500
	locpln(i,3) = 0
	call unlock (plnlok)			!unlock LOCPLN array
	dispfr = disp (Vloc, Hloc)   ;  iwhat = 1
	call setdsp (Vloc, Hloc, ((team + DXNPLN) * 100) + i)
	dispto = who + (team * 100)  ;  shjump = 0
	Vfrom = Vloc  ;  Hfrom = Hloc
	Vto = shpcon(who,KVPOS)  ;  Hto = shpcon(who,KHPOS)
	id = pdist (Vfrom, Hfrom, Vto, Hto)
	call phadam (team, who, id, phit, .FALSE.) !planet defends itself!
	if (tcap .ne. 0) tmscor(tcap,KPEDAM) = tmscor(tcap,KPEDAM) + ihita
	if ((klflg .ne. 0) .and. (tcap .ne. 0)) 
     +	tmscor(tcap,KPEKIL) = tmscor(tcap,KPEKIL) + 5000
	call pridis (shpcon(who,KVPOS), shpcon(who,KHPOS), KRANGE, 
     +	team, 0)
	call pridis (shpcon(who,KVPOS), shpcon(who,KHPOS), 4, 0, 1)
*.......Inform player of hit
	call crlf
	call odisp (who + (team * 100), 1)
	call out (captu0,0)
	call odisp ((tcap + DXNPLN) * 100, 1)
	call prloc (Vloc, Hloc, 1, 0, ocflg, oflg)
	call makhit
	tpoint(KPPCAP) = tpoint(KPPCAP) + 1000	!get points
	ptime = v - etim(tim0)			!pause for capture
	if ((shpcon(who,KSDAM) .lt. KENDAM) .and. 
     +	(shpcon(who,KSNRGY) .gt. 0))  return	!if player alive, return
*.......Player dies!
	if (team .eq. 1)  call out (captu1,1)
	if (team .eq. 2)  call out (captu2,1)
	call odisp (who + (team * 100), 1)
	call out (captu4,1)
	return
*.......Error messages
 400	idsp = dispc (Vloc, Hloc)		!no planet at location
	if (idsp .le. 0)  call out (noplnt,1)
	if ((team .eq. idsp) .or. (team+2 .eq. idsp))  call out (nosur1,1)
	if ((3-team .eq. idsp) .or. (5-team .eq. idsp)) 
     +	call out (nosur2,1)
	if (idsp .eq. DXROM)  call out (nosur3,1)
	if (idsp .ge. DXSTAR)  call out (nosur4,1)
	return 1
 500	call crlf				!not adjacent to specified location
	call odisp (disp(shpcon(who,KVPOS),shpcon(who,KHPOS)), 1)
	call out (captu5,1)
	return 1
 600	if (oflg .eq. long)  goto 700		!planet already captured
	call out (captu7, 1)
	goto 800
 700	if (team .eq. 1)  call out (captu6,1)
	if (team .eq. 2)  call out (captu8,1)
 800	return 1
	end
C	This routine is used by MOVE, TORP, ROMDRV, and ROMTOR to
C	check the projected path of a ship or torpedo for objects
C	in the way.
C	INPUT
C	  H,V	  Initial coordinate
C	  DH,DV	  Relative V and H displacement (for direction only)
C	  Dist	  Maximum V or H displacement (distance to travel)
C	  Displ	  Displacement per sector (abs(Displ) < 0.50)
C	OUTPUT
C	  H1,V1	  Final location
C	  H2,V2	  Location of object that blocked path, else final location
C	  Dcode	  DISP code of object that blocked path, else 0
C	  DSH,DSV Delta H and Delta V to add to object to get displacement
	subroutine CHECK (H, V, dH, dV, dist, displ)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /chkout/ H1, V1, H2, V2, dcode, dHs, dVs
	real rH, rV, displ, dHs, dVs
	H1 = H  ;  V1 = V  ;  dcode = 0
	if (iabs(dV) .gt. iabs(dH))  goto 400
	inc = isign (1,dH)  ;  dHs = float (inc)
	dVs = float(dV) / float(iabs(dH)) + displ
	H2 = H  ;  rV = float(V)
	do 300 i = 1, dist
	  H2 = H2 + inc  ;  if (.not. ingal(5,H2))  goto 900
	  rV = rV + dVs
	  call chkpnt (rV, iV1, iV2)
	  if (.not. ingal(iV1,5))  goto 900
	  V2 = iV1
	  if (disp(H2,V2) .gt. 0) goto 800	!ran into something
	  if (iV2 .eq. 0) goto 100
	  if (.not. ingal(iV2,5))  goto 900
	  V2 = iV2
	  if (disp(H2,V2) .gt. 0) goto 800	!ran into something
	  V1 = int(rV + ran(0))
	  goto 200
  100	  V1 = int(rV + .5)
  200	  H1 = H2
  300	continue
	V2 = V1
	return					!made it to destination
  400	inc = isign (1, dV)  ;  dVs = float (inc)
	dHs = float(dH) / float(iabs(dV)) + displ
	V2 = V  ;  rH = float(H)
	do 700 i = 1, dist
	  V2 = V2 + inc  ;  if (.not. ingal(V2,5))  goto 900
	  rH = rH + dHs
	  call chkpnt (rH, iH1, iH2)
	  if (.not. ingal(5,iH1))  goto 900
	  H2 = iH1
	  if (disp(H2,V2) .gt. 0) goto 800	!ran into something
	  if (iH2 .eq. 0)  goto 500
	  if (.not. ingal(5,iH2))  goto 900
	  H2 = iH2
	  if (disp(H2,V2) .gt. 0) goto 800	!ran into something
	  H1 = int(rH + ran(0))
	  goto 600
  500	  H1 = int(rH + .5)
  600	  V1 = V2
  700	continue
	H2 = H1
	return					!made it to destination
  800	dcode = disp(H2,V2)			!ran into something
	return
  900	H2 = H1  ;  V2 = V1			!out of the galaxy
	return
	end
C	This routine is used by CHECK to determine the next position
C	on the display board to check for objects.
C	If the fractional part of C is greater than 0.60, return
C	INT(C)+1 in C1, and 0 in C2
C	If the fractional part of C is less than 0.40, return
C	INT(C) in C1, and 0 in C2
C	Otherwise, return INT(C) in C1 and INT(C)+1 in C2
	subroutine CHKPNT (c, c1, c2)
	include 'param/nolist'
	real c
	if (iabs (mod (int(c*100), 100) - 50) .lt. 10)  goto 100
	c1 = int(c + .5)
	c2 = 0
	return
  100	c1 = int(c)
	c2 = c1 + 1
	return
	end
C	When this routine is called because ^C is typed it clears the
C	player's input buffer.
	subroutine CLRBUF
	call out ("034160703400,0)	!4 bells
	call clear			!clear the input buffer
	return
	end
C	This routine reports on current ship device damages (if any).
C	STOKEN = 2 if this is a call from the DAMAGE command,
C	STOKEN = 3 if this is a call from the REPAIR routine.
	subroutine DAMAGE (stoken)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	call crlf
	do 100 i = 1, KNDEV		!anything damaged?
	  if (shpdam(who,i) .gt. 0)  goto 200
 100	continue
	call out (alldok,1)		!nope!
	goto 1800
*.......Specific device information requested?
 200	if (typlst(stoken) .ne. KALF)  goto 900
	do 800 i = stoken, KMAXTK
	  if (typlst(i) .ne. KALF)  goto 1800
	  do 700 j = 1, KNDEV
	    if (.not. (equal(tknlst(i), device(j))))  goto 700
	    call odev (j)
	    if (oflg)  300, 400, 500
 300	    call space  ;  goto 600
 400	    call tab (10)    ;  goto 600
 500	    call tab (19)
 600	    call oflt (shpdam(who,j), 4)
	    if (oflg .eq. long)  call out (units1,0)
	    call crlf
 700	  continue
 800	continue
	goto 1800
*.......General report on ALL damaged devices.
 900	if (oflg)  1200, 1100, 1000
1000	call out (damrep,0)
	call odisp(disp(shpcon(who,KVPOS),shpcon(who,KHPOS)), 0)
	call skip (2)
1100	call out (dmhdr1,0)
	if (oflg .eq. long)  call spaces (9)
	call out (dmhdr2,2)
1200	do 1700 i = 1, KNDEV			!scan the devices
	  if (shpdam(who,i) .le. 0)  goto 1700	!damaged?
	  call odev (i)
	  if (oflg)  1300, 1400, 1500
1300	  call space  ;  goto 1600
1400	  call tab (10)    ;  goto 1600
1500	  call tab (19)
1600	  call oflt (shpdam(who,i), 4)
	  if (oflg .eq. long)  call out (units1,0)
	  call crlf
1700	continue
1800	return
	end
C	This routine is used by the Romulan to find the nearest attackable
C	object (ship or base).
	subroutine DIST (ip, np, num)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /distlc/ V(4), H(4), iV(4), z(4)
	call blkset (z, (KGALV * KGALH + 1), 4)
	RV = locr(KVPOS)  ;  RH = locr(KHPOS)
*.......Find closest Federation ship
	do 100 j = 1, KNPLAY / 2
	  if (.not. alive(j))  goto 100
	  if (disp(shpcon(j,KVPOS),shpcon(j,KHPOS)) .le. 0)  goto 100
	  ztem = (RV - shpcon(j,KVPOS)) * (RV - shpcon(j,KVPOS)) + 
     +	  (RH - shpcon(j,KHPOS)) * (RH - shpcon(j,KHPOS))
	  if (ztem .ge. z(1))  goto 100
	  iV(1) = j  ;  z(1) = ztem
	  V(1) = shpcon(j,KVPOS)  ;  H(1) = shpcon(j,KHPOS)
 100	continue
*.......Find closest Klingon ship
	do 200 j = (KNPLAY / 2) + 1, KNPLAY
	  if (shpcon(j,KVPOS) .eq. 0)  goto 200
	  if (disp(shpcon(j,KVPOS),shpcon(j,KHPOS)) .le. 0)  goto 200
	  ztem = (RV - shpcon(j,KVPOS)) * (RV - shpcon(j,KVPOS)) + 
     +	  (RH - shpcon(j,KHPOS)) * (RH - shpcon(j,KHPOS))
	  if (ztem .ge. z(2))  goto 200
	  iV(2) = j  ;  z(2) = ztem
	  V(2) = shpcon(j,KVPOS)  ;  H(2) = shpcon(j,KHPOS)
 200	continue
*.......Find closest Federation and Klingon starbase
	do 400 k = 1, 2
	  if (nbase(k) .le. 0)  goto 400
	  do 300 j = 1, KNBASE
	    if (base(j,3,k) .le. 0)  goto 300
	    if (disp (base(j,KVPOS,k), base(j,KHPOS,k)) .eq. 0)  goto 300
	    ztem = (RV - base(j,KVPOS,k)) * (RV - base(j,KVPOS,k)) + 
     +	    (RH - base(j,KHPOS,k)) * (RH - base(j,KHPOS,k))
	    if (ztem .ge. z(2+k))  goto 300
	    iV(2+k) = j  ;  z(2+k) = ztem
	    V(2+k) = base(j,KVPOS,k)  ;  H(2+k) = base(j,KHPOS,k)
 300	  continue
 400	continue
*.......Figure out which of the above is closest of all
	np = 1
	if ((z(2) .lt. z(1))  .or. ((z(1) .eq. z(2))  .and. 
     +	(iran(2) .eq. 1)))  np = 2
	if ((z(3) .lt. z(np)) .or. ((z(3) .eq. z(np)) .and. 
     +	(iran(2) .eq. 1)))  np = 3
	if ((z(4) .lt. z(np)) .or. ((z(4) .eq. z(np)) .and. 
     +	(iran(2) .eq. 1)))  np = 4
	ip = iV(np)
	num = pdist (V(np), H(np), RV, RH)
	return
	end
C	This routine checks for an adjacent friendly starbase or planet,
C	and if either is found, the ship's energy and supplies are
C	fractionally increased (up to the maximum possible).  Bases
C	supply twice the energy and supplies per dock as do planets.
	subroutine DOCK (*)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
*.......Check for friendly base in range
	v = etim(tim0) + (slwest * 1000) + 1000
	ifract=0
	do 100 j = 1, KNBASE
	  if (base(j,3,team) .le. 0)  goto 100			!is base alive?
	  if (ldis (shpcon(who,KVPOS), shpcon(who,KHPOS), 
     +	  base(j,KVPOS,team), base(j,KHPOS,team), 1))
     +    ifract = ifract + 2	!is base within 1 sector?
 100	continue
*.......Check for friendly planet in range
	if (numcap(team) .le. 0)  goto 300
	do 200 i = 1, nplnet
	  if ((team + DXNPLN) .ne. dispc(locpln(i,KVPOS),locpln(i,KHPOS))) 
     +	  goto 200						!planet friendly?
	  if (.not. ldis(shpcon(who,KVPOS), shpcon(who,KHPOS), 
     +	  locpln(i,KVPOS), locpln(i,KHPOS), 1))  goto 200	!planet within 1 sector?
	  ifract=ifract + 1
 200	continue
*.......No adjacent bases or planets
 300    if (ifract .ne. 0) goto 400
    	call crlf
	call odisp (disp(shpcon(who,KVPOS),shpcon(who,KHPOS)), 1)
	call out (dock01,1)
	return 1
*.......Dock the ship  (R & R)!!
 400	if (.not. alive(who))  return 1		!ship already dead
	shpcon(who,KNTORP) = min0((shpcon(who,KNTORP) + (ifract*5)), 10)
	shpcon(who,KSNRGY) = min0((shpcon(who,KSNRGY) + (ifract*5000)), 
     +	50000)
	shpcon(who,KSSHPC) = min0((shpcon(who,KSSHPC) + (100*ifract)), 
     +	1000)
	shpcon(who,KSDAM) = max0 ((shpcon(who,KSDAM) - (ifract*500)), 0)
	if (docked(who))  shpcon(who,KSDAM) = max0((shpcon(who,KSDAM) - 
     +	(ifract*500)), 0)
	docked(who) = .TRUE.
	shpcon(who,KLFSUP) = 5  ;  shpcon(who,KSPCON) = GREEN
	call out (dockin,1)
	if (equal(tknlst(2), 'STATUS')) 
     +	call status (3)			!status report?
	ptime = v - etim(tim0)		!compute pause time for DOCK.
	return
	end
C	This routine is called periodically by GETCMD to check
C	for dead ships.
	subroutine DSHIP
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	do 100 i = 1, KNPLAY
	  if (.not. alive(i))  go to 100	!ship in use?
	  active(i) = active(i) + 1
	  if (active(i) .lt. 2)  go to 100	!inactive?
	  active(i) = 0
	  call free (i)				!remove dead ship
 100	continue
	return
	end
C	This routine is called whenever a base or planet is destroyed
C	to see if the game is over. (all the planets gone, and one
C	side's bases).  If so, the appropriate message is printed out
C	and the job is returned to monitor level.
	subroutine ENDGAM
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /local/ dummy(locsiz)
	common /polocl/ total(4)
	external monit
	if (ENDFLG)  goto 100			!game already over?
	if (nplnet .gt. 0)  return		!any planets left?
	if (min0 (nbase(1), nbase(2)) .gt. 0)  return	!any bases left?
*.......The game is over!!
	call kilhgh
	endflg = .true.
 100	call out (endgm0,1)
	if (max0 (nplnet, nbase(1), nbase(2)) .ne. 0) goto 300
		call out (endgm1, 1)
		endflg = -2			! -2 implies total destruction
300	if (nbase(1) .eq. 0)  call out (endgm3,1)
	if (nbase(2) .eq. 0)  call out (endgm4,1)
	if ((team .eq. 1) .and. (nbase(1) .eq. 0))  call out (endgm5,1)
	if ((team .eq. 1) .and. (nbase(2) .eq. 0))  call out (endgm6,1)
	if ((team .eq. 2) .and. (nbase(1) .eq. 0))  call out (endgm7,1)
	if ((team .eq. 2) .and. (nbase(2) .eq. 0))  call out (endgm8,1)
	if (who .eq. 0)  goto 400	!'player' from restart loop.
	txppn = job(who, kppn)
	txnm1 = job(who, knam1)
	txnm2 = job(who, knam2)
	txsh1 = names (who, 1)
	txsh2 = names (who, 2)
	whowon = 1
	if (nbase(1) .lt. nbase(2)) whowon = 2
	txwhy  = 1			! assume this player won
	if (team .ne. whowon) txwhy = 0	! not same team, so lost!
	if (endflg .eq. -2) txwhy = 0	! or everyone loses!
	txtim = etim(job(who, KJOBTM))
	txtem = team - 1
	call points (.TRUE.)
	txtot = total (1)
	call updsta (txppn,txnm1,txnm2,txsh1,txsh2,txtot,txtim,txwhy, 
     +		txtem, who)
	call free (who)
	who = 0
c--	call shosta(0)			! show current standings
 400	call exit
	end
C	This routine allows ship-to-ship transfer of energy between
C	friendly ships.  There is a 10% loss during the transfer.
	subroutine ENERGY
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	call crlf
	index = 2
*.......Input ship name and energy to transfer
 100	if ((typlst(index) .eq. KALF) .and. (typlst(index+1) .eq. KINT)) 
     +	goto 500
	if (oflg)  200, 200, 300
 200	call out (ener1S, 0)  ;  goto 400
 300	call out (ener1L, 0)
 400	call gtkn
	index = 1
	if (typlst(1) .eq. KEOL)  return
	goto 100
*.......Match input with ship name
 500	do 600 i = 1, KNPLAY
	  if (equal(tknlst(index), names(i,1)))  goto 700
 600	continue
	call out (unkshp,1)		!unknown ship name
	return
*.......Input his own ship name?
 700	if (i .ne. who)  goto 800
	if (oflg .eq. long)  call out (begyrp, 0)
	call out (energ7, 1)
	return
*.......Ship in game?
 800	if (alive(i))  goto 900
	call out (noship,1)		!ship not in game
	return
*.......Attempting to transfer energy to an enemy ship?
 900	dteam = 1  ;  if (i .gt. KNPLAY/2)  dteam = 2
	if (team .eq. dteam)  goto 1000
	call out (energ2,1)
	return
*.......Adjacent to destination ship?
1000	if (ldis(shpcon(who,KVPOS),shpcon(who,KHPOS),shpcon(i,KVPOS), 
     +	shpcon(i,KHPOS),1))  goto 1100
	call out (energ3,1)
	return
*.......Transferring more energy than you possess?
1100	ihita = vallst(index+1) * 10
	if (ihita .lt. shpcon(who,KSNRGY))  goto 1500
	if (oflg)  1200, 1200, 1300
1200	call out (ener4S, 1)  ;  goto 1400
1300	call out (ener4L, 1)
1400	return
*.......Energy transfer negative or equal to zero?
1500	if (ihita .gt. 0)  goto 1600
	if (oflg .eq. long)  call out (energ8, 0)
	call out (energ5,1)
	return
*.......Make energy transfer, inform players
1600	ihita = min0(int(ihita * 0.9), 50000 - shpcon(i,KSNRGY))
	shpcon(who,KSNRGY) = shpcon(who,KSNRGY) - (ihita + (ihita / 9))
	shpcon(i,KSNRGY) = shpcon(i,KSNRGY) + ihita
	call out (energ6,1)		!inform transferring ship
	dispto = i + (dteam * 100)  ;  dispfr = who + (team * 100)
	dbits = bits(i)  ;  iwhat = 12
	call makhit		!inform destination ship
	return
1700	call out ('Sorry, Captain, but the transfer has failed.', 1)
	return
	end
C	This routine is called whenever a player dies, quits the game,
C	or temporarily CTL-C's out.  The appropriate parts of the high
C	segment are saved in the low segment, and zeroed out for use by
C	others.  If a restart is made after a ^C, the information is
C	passed back up into the high segment, and the player is again
C	active.  Any hit or radio messages present before the ^C
C	will be lost.
	subroutine FREE (snum)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /frlocl/ tship, tshpco(10), tshpda(KNDEV), tjob(KNJBST), 
     +	dum(16)
	if (alive(snum) .gt. 0)  return
11	call lock (frelok)
	if (lkfail) goto 11		! we gotta lock it up!
	call setdsp (shpcon(snum,KVPOS), shpcon(snum,KHPOS), 0)
	tteam = 1  ;  if (snum .gt. (KNPLAY / 2))  tteam = 2
	tship = (tteam * 100) + snum
	numply = numply - 1
	if ((numply .eq. 0) .and. .not. ENDFLG)  hitime = 
     +	daytim(d) + 300000		!preserve high segment for 5 minutes
	numsid(tteam) = numsid(tteam) - 1
	if (trstat(snum) .ne. 0)  call trcoff (snum)
C.......Record the player in the killed player queue, along with the
C.......time when he will again be eligible to play.
	call kqsrch (job(snum,KTTYN), job(snum,KJOB), job(snum,KPPN), 
     +	kindex)
	if (kindex .ne. 0)  goto 100
	if (nkill .lt. KQLEN) nkill = nkill + 1
	kilndx = kilndx + 1
	if (kilndx .gt. KQLEN)   kilndx = 1
	kindex = kilndx
 100	kilque(kindex,1) = job(snum,KJOB)
	kilque(kindex,2) = job(snum,KPPN)
	kilque(kindex,3) = job(snum,KTTYN)
	kilque(kindex,4) = daytim(d)
	kilque(kindex,5) = tteam .or. snum*262144
*.......Move ship information into low segment arrays
*.......Clear out high segment
	do 200 i= 1, KNJBST
	  tjob(i) = job(snum,i)
	  job(snum,i) = 0
 200	continue
	do 300 i = 1, 10
	  tshpco(i) = shpcon(snum,i)
 300	continue
	shpcon(snum,KVPOS) = 0
	shpcon(snum,KHPOS) = 0
	shpcon(snum,KSNRGY) = 0
	do 400 i = 1, KNDEV
	  tshpda(i) = shpdam(snum,i)
 400	continue
 500	if (hitflg(snum) .le. 0)  goto 600	!clear out hit messages
	call gethit (snum)
	goto 500
 600	if (msgflg(snum) .le. 0)  goto 700	!clear out radio messages
	call getmsg (snum, dum)
	goto 600
 700	dbits = 0  ;  dispfr = 0
	call blkset (iwhat, 0, 17)
	alive(snum) = 1
	call unlock (frelok)
	return
*.......Continue game after ^C
	entry RSTART (snum)
 800	if (shpcon(snum,KVPOS) .ne. 0)  goto 1100	!tship in use
	if (disp(tshpco(KVPOS),tshpco(KHPOS)) .gt. 0) 
     +	goto 1200   !  spot on board is taken
801	call lock (frelok,'RSTART')
	if (lkfail) goto 801			! keep trying!
	alive(snum) = .TRUE.
	numply = numply + 1
	tteam = (snum - 1) / (KNPLAY / 2) + 1
	numsid(tteam) = numsid(tteam) + 1
*.......Move ship information back into high segment
	do 900 i = 1, 10
	  shpcon(snum,i) = tshpco(i)
 900	continue
	do 1000 i = 1, KNDEV
	  shpdam(snum,i) = tshpda(i)
1000	continue
	call jobsta ( 
     +		job(snum,KJOB),
     +		dummy,
     +		dummy,
     +		job(snum,KPPN),
     +		job(snum,KTTYN),
     +		job(snum,KTTYSP)
     +		    )
	job(snum,KNAM1) = tjob(KNAM1)
	job(snum,KNAM2) = tjob(KNAM2)
	job(snum,KTTYTP) = tjob(KTTYTP)
	job(snum,KJOBTM) = tjob(KJOBTM)
	job(snum,KRUNTM) = tjob(KRUNTM)
	call setdsp (tshpco(KVPOS), tshpco(KHPOS), tship)
	call unlock (frelok)
	return
*.......Error messages
1100	call out (free01,1)			!Ship in use
	call monit
	goto 800
1200	call out (free02,1)			!Spot on board taken
	call monit
	goto 800
	end
C	This routine processes command strings, and also monitors the
C	hit and message queues between commands.
	subroutine GETCMD (cmd)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /local/ dummy(locsiz)
	common /polocl/ total(4)
	external monit
	call ttyon
	if (hitflg(who) .ne. 0)  call outhit
	call ttyon
	if (msgflg(who) .ne. 0)  call outmsg
	call prgnam ('DECWSL')
	call dmpbuf			!dump output buffer
	call CCTRAP
	if (.not. PASFLG)
     +    call pause (ptime)		!pause (mark) after previous command
	ptime = 0			!assume no pause for next cmd.
 100	call crlf
	call chkseq			! check for active jobs
	if (shpcon(who,KSDAM) .ge. KENDAM)  goto 1100	!ship dead?
	if (shpcon(who,KSNRGY) .le. 0)  goto 1200	!energy gone?
	if (shpcon(who,KSNRGY) .le. 10000)  shpcon(who,KSPCON) = YELLOW	!yellow alert?
	if (shpcon(who,KSPCON) .eq. YELLOW)  call out ("034160703400,0)	!if yellow alert, BEEP!
	call ttyon
	call endgam			!game over?
	CCFLG = .FALSE.
	call prompt  ;  call prgnam ('DECWTI')
	call dmpbuf			!dump output buffer
200	call zaplok			! remove any and all current locks
	if (ccflg .or. hungup) goto 210
	if (input(KCMDTM))  goto 400	!command input?
	if (hungup) goto 500
210	active(who) = 0
	comknt = comknt + 1
	if (comknt .lt. 30 * numply)  goto 300
	comknt = 0
c--	call dship
 300	if ((hitflg(who) .eq. 0) .and. (msgflg(who) .eq. 0))  goto 350
	call ttyon
	if (hitflg(who) .ne. 0)  call outhit
	call ttyon
	if (msgflg(who) .ne. 0)  call outmsg
	goto 100
 350	call endgam  ;  goto 200	!check for end of game
 400	active(who) = 0
	if (hungup) goto 500		! job hung up?
C	if (lofchk(0))	goto 500	! drforbin(merlyn) dump user whose time limit is over
	comknt = comknt + 1
	call gtkn
	if (.not. CCFLG) goto 600	!^C wasn't typed
	if (shpcon(who,KSPCON) .ne. RED) goto 500
	call out (noquit,1)
	call clear
	goto 100
500	tknlst(1) = 'QUIT'		! ^C and hangup forces job to quit
	typlst(1) = kalf
	goto 610
 600	if (typlst(1) .eq. KEOL)  goto 100
610	cmd = 0
	do 700 i = 1, KNCMD		!identify command
	  if (.not. (equal(tknlst(1), isaydo(1,i))))  goto 700
	  if (cmd .ne. 0)  goto 800
	  cmd = i
 700	continue
	if (cmd)  800,900,1300 !will never take the neg branch
 800	call out (ambcom, 0)		!input is ambiguous
	goto 1000
 900	call out (unkcom, 0)		!input is trash!
1000	if (oflg .ne. short)  call out (forhlp, 0)
	call crlf
	goto 100
1100	continue
	txppn = job(who, kppn)
	txnm1 = job(who, knam1)
	txnm2 = job(who, knam2)
	txsh1 = names (who, 1)
	txsh2 = names (who, 2)
	txtim = etim(job(who, KJOBTM))
	txwhy = 0
	txtem = team - 1
	call points (.TRUE.)
	txtot = total (1)
	call updsta (txppn,txnm1,txnm2,txsh1,txsh2,txtot,txtim,txwhy, 
     +	txtem, who)
	call free (who)			!player is dead
c--	call	shosta(0)
	who = 0			! return to DECWAR
	return
1200	call odisp (team*100 + who, 1)	!ship is out of energy
	call out (main02,1)
	goto 1100
1300	call prgnam ('DECWRN')
	return
	end
C	This routine plots a possible new location for ships and bases
C	after novas or photon torpedo hits.  If the new location contains
C	a black hole, death!
	subroutine JUMP (nplc, j)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /chkout/ V1, H1, V2, H2, dcode, disV, disH
	real disV, disH
	shjump = 0
	if (nplc .gt. DXESHP)  goto 100			!ship?
	iloc1 = shpcon(j,KVPOS)  ;  jloc1 = shpcon(j,KHPOS)
	goto 300
 100	if (nplc .eq. DXROM)  goto 200			!base?
	iloc1 = base(j,KVPOS,nplc-2)  ;  jloc1 = base(j,KHPOS,nplc-2)
	goto 300
 200	iloc1 = locr(KVPOS)  ;  jloc1 = locr(KHPOS)	!romulan
*.......Determine direction of blast, possible new location
 300	iVV = iloc1 + disV
	iHH = jloc1 + disH
	if (.not. ingal (IVV, IHH))  return
	if (.not. (pdist (iloc1, jloc1, iVV, iHH) .eq. 1))  return
	l = dispc (iVV,iHH)
	if (l .eq. DXBHOL)  goto 600	!blown into black hole?
	if (l .ne. DXMPTY)  return	!new location already occupied?
*.......Displace to new location
	call setdsp (iloc1, jloc1, 0)
	call setdsp (iVV, iHH, (nplc * 100) + j)
	if (nplc .ne. DXROM)  goto 400
	locr(KVPOS) = iVV  ;  locr(KHPOS) = iHH  ;  goto 500
 400	if (nplc .lt. DXFBAS)  shpcon(j,KVPOS) = iVV
	if (nplc .lt. DXFBAS)  shpcon(j,KHPOS) = iHH
	if (nplc .ge. DXFBAS)  base(j,KVPOS,nplc-2) = iVV
	if (nplc .ge. DXFBAS)  base(j,KHPOS,nplc-2) = iHH
 500	Vto = iVV  ;  Hto = iHH
	shjump = 1
	if (nplc .ge. DXFBAS)  return
	shpcon(j,KSPCON) = RED  ;  docked(j) = .FALSE.
	return
*.......Displaced into black hole!
 600	call setdsp (iloc1, jloc1, 0)	!zero out object's old location
	shjump = 1
	klflg = 1  ;  Vto = iVV  ;  Hto = iHH
	if (nplc .ne. DXROM)  goto 700	!romulan?
	ROM = .FALSE.
	return
 700	if (nplc .lt. DXFBAS)  shpcon(j,KSDAM) = KENDAM
	if (nplc .lt. DXFBAS)  alive(j) = 0
	if (nplc .ge. DXFBAS)  base(j,3,nplc-2) = 0
	return
	end
C	This routine searches the KILQUE array for an entry matching
C	the argument list.  If a match is found, KINDEX contains the
C	the matching KILQUE row number, else it returns as zero.
	subroutine KQSRCH (ttynum, jobnum, ppn, kindex)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	kindex = 0
	if (nkill .eq. 0)  return	!no one has been killed yet
	do 100 ii = 1, nkill
	    i = ii
	  if ((jobnum .eq. kilque(i,1)) .and. (ppn .eq. kilque(i,2))) 
     +	  goto 200
c--	  if ((ttynum .eq. kilque(i,3)) .and. 
c--     +	  (etim(kilque(i,4)) .lt. 180000))  goto 200
 100	continue
	return				!player not found in kill queue
*.......Set KINDEX, update KILQUE entries
 200	kindex = i
	kilque(i,1) = jobnum
	kilque(i,2) = ppn
	kilque(i,3) = ttynum
	return
	end
C	LIST -- List various info (location, shield percent, number of
C	builds) on ships, bases, and planets.
	subroutine LIST
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	include 'lstvar'
	cmd = LSTCMD			!command is LIST
	goto 100
	entry SUMMAR			!command is SUMMARY
	cmd = SUMCMD
	goto 100
	entry BASES
	cmd = BASCMD			!command is BASES
	goto 100
	entry PLANET
	cmd = PLNCMD			!command is PLANET
	goto 100
	entry TARGET
	cmd = TARCMD			!command is TARGET
 100	call blkset (lstfz, 0, locf(lstlz)-locf(lstfz)+1)
	svpos = shpcon(who,KVPOS)  ;  shpos = shpcon(who,KHPOS)
	call crlf
	p = 1  ;  n = 0
 200	if (p .gt. KMAXTK) return
	if (typlst(p) .eq. KEOL)  goto 300
	call lstscn ($400)		!scan group from input line
	call lstflg ($200)		!set list flags according to group bits
	n = n + 1
	goto 200
 300	if (n .ne. 0)  call lstout	!output flagged items
 400	return
	end
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
C	LSTSCN -- Scan input group for LIST, SUMMARY, TARGETS, BASES,
C	and PLANETS commands.
	subroutine LSTSCN (*)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	include 'lstvar/nolist'
	goto (50, 100, 200, 300)  cmd
C	LIST command
	omask = SHPBIT .or. BASBIT .or. PLNBIT
	smask = FEDBIT .or. EMPBIT .or. NEUBIT .or. ROMBIT
	lmask = LSTBIT
	range = MAXINT
	goto 400
C	SUMMARY command
  50	omask = SHPBIT .or. BASBIT .or. PLNBIT
	smask = FEDBIT .or. EMPBIT .or. NEUBIT .or. ROMBIT
	lmask = SUMBIT
	range = MAXINT
	goto 400
C	BASES command
 100	omask = BASBIT
	smask = sbits(team)
	lmask = LSTBIT .or. SUMBIT
	range = MAXINT
	goto 400
C	PLANETS command
 200	omask = PLNBIT
	smask = FEDBIT .or. EMPBIT .or. NEUBIT
	lmask = LSTBIT
	range = KRANGE
	goto 400
C	TARGETS command
 300	omask = SHPBIT .or. BASBIT .or. PLNBIT
	smask = sbits(3-team) .or. ROMBIT
	lmask = LSTBIT
	range = KRANGE
 400	imask = 0		!nothing scanned yet
	ships = 0		!no ships yet
	vpos = 0  ;  hpos = 0	!no coordinate scanned
	op = p			!remember where we started the scan
 500	p = p + 1
	if (p .gt. KMAXTK) return 1	! prevent "Data out of bounds"
C.......Check for end of group
	if (typlst(p) .eq. KEOL)  goto 600
	token = tknlst(p)
	if (equal(token, '&'))  goto 600
	if (.not. equal(token, 'AND'))  goto 800
C.......End of group; check for any last minute syntax errors
 600	if (p .ne. op+1)  return
	if (op .eq. 1)  goto 700
	call out (lsts01,1)		!"Null group illegal"
	return 1
C.......Lone command (no modifiers).  In this case, automatically
C	include a summary, unless the command was LIST.
 700	continue
*	if (cmd .ne. LSTCMD)  lmask = lmask .or. SUMBIT
	return
C.......Check for coordinate and range
 800	if ((typlst(p) .eq. KINT) .and. (typlst(p+1) .eq. KINT)) 
     +	goto 2200
	if (typlst(p) .eq. KINT)  goto 2900	!range
	if (typlst(p) .ne. KALF)  goto 1400
C.......Check for ship name (Romulan counts as ship name)
	if ((cmd .ne. LSTCMD) .and. (cmd .ne. TARCMD))  goto 1000
	do 900 i = 1, KNPLAY
	  if (equal(token, names(i,1)))  goto 1800 !ship name
 900	continue
	if (equal(token, 'ROMULAN'))  goto 1700
C.......Check for other keywords
1000	if ((cmd .ne. LSTCMD) .and. (cmd .ne. SUMCMD) .and. 
     +	(cmd .ne. TARCMD))  goto 1100
	if (equal(token, 'SHIPS'))    goto 1900
	if (equal(token, 'BASES'))    goto 2000
	if (equal(token, 'PLANETS'))  goto 2100
	if (equal(token, 'PORTS'))    goto 2150
1100	if (cmd .eq. TARCMD)  goto 1200
	if (equal(token, 'FRIENDLY'))    goto 2300
	if (equal(token, 'ENEMY'))       goto 2400
	if (equal(token, 'TARGETS'))     goto 2400
	if (equal(token, 'FEDERATION'))  goto 2500
	if (equal(token, 'HUMAN'))       goto 2500
	if (equal(token, 'EMPIRE'))      goto 2600
	if (equal(token, 'KLINGON'))     goto 2600
1200	if ((cmd .eq. BASCMD) .or. (cmd .eq. TARCMD))  goto 1300
	if (equal(token, 'NEUTRAL'))   goto 2700
	if (equal(token, 'CAPTURED'))  goto 2800
1300	if (equal(token, 'ALL'))  goto 2850	!legal for any command
	if ((cmd .ne. SUMCMD) .and. equal(token, 'CLOSEST'))  goto 3000
	if ((cmd .ne. LSTCMD) .and. (cmd .ne. SUMCMD) .and. 
     +	equal(token, 'LIST'))  goto 3100
	if ((cmd .ne. SUMCMD) .and. (equal(token, 'SUMMARY')))  goto 3200
1400	call out (lsts02,0)  ;  goto 1600	!"Illegal keyword"
1500	call out (lsts03,0)			!"Syntax error near keyword "
1600	call outw (token)  ;  call crlf
	return 1
C----------------------------------------------------------------------
C		Object selection
C----------------------------------------------------------------------
C.......Romulan
1700	if ((imask .and. ROMBIT) .ne. 0)  goto 1500	!Romulan already given
	imask = imask .or. ROMBIT .or. NAMBIT
	omask = SHPBIT
	goto 500
C.......ship name
1800	if ((imask .and. .not. (NAMBIT .or. ROMBIT)) .ne. 0)  goto 1500
	imask = imask .or. NAMBIT
	if ((ship .and. bits(i)) .ne. 0)  goto 1500	!name already given
	ships = ships .or. bits(i)
	omask = SHPBIT
	goto 500
C.......SHIP
1900	if ((imask .and. (OBJMSK .or. NEUBIT .or. CAPBIT)) .ne. 0) 
     +	goto 1500
	imask = imask .or. SHPBIT
	omask = SHPBIT
	smask = smask .and. (FEDBIT .or. EMPBIT .or. ROMBIT)
	goto 500
C.......BASE
2000	if ((imask .and. (OBJMSK .or. NEUBIT .or. CAPBIT)) .ne. 0) 
     +	goto 1500
	imask = imask .or. BASBIT
	omask = BASBIT
	smask = smask .and. (FEDBIT .or. EMPBIT)
	goto 500
C.......PLANET
2100	if ((imask .and. OBJMSK) .ne. 0)  goto 1500
	imask = imask .or. PLNBIT
	omask = PLNBIT
	smask = smask .and. (FEDBIT .or. EMPBIT .or. NEUBIT)
	goto 500
C.......PORT
2150	if (who .eq. 0)  goto 1500		!Pre-game?
	if ((imask .and. OBJMSK) .ne. 0)  goto 1500
	imask = imask .or. PRTBIT
	if ((imask .and. NEUBIT) .eq. 0)  omask = BASBIT .or. PLNBIT
	if ((imask .and. SIDMSK) .eq. 0)  smask = sbits(team) .or. NEUBIT
	smask = smask .and. .not. ROMBIT
	goto 500
C.......Coordinate
2200	if (cmd .eq. SUMCMD)  goto 1500
	if ((imask .and. (OBJMSK .or. SIDMSK .or. ALLBIT .or. RNGBIT .or. 
     +	CLSBIT .or. OUTMSK)) .ne. 0)  goto 1500
	imask = imask .or. CRDBIT
	Vpos = vallst(p)  ;  Hpos = vallst(p+1)
	p = p + 1
	if (p .gt. KMAXTK) return  1
	if (ingal(Vpos,Hpos))  goto 500
	call out (lsts04,0)			!"Illegal coordinate"
	call prloc (Vpos, Hpos, 1, 0, KABS, SHORT)
	return 1
C----------------------------------------------------------------------
C		Side and range selection
C----------------------------------------------------------------------
C.......Friendly
2300	if (who .eq. 0)  goto 1500		!Pre-game?
	smask = smask .and. .not. ROMBIT
	if (team .eq. 1)  2500, 2600
C.......Enemy
2400	if (who .eq. 0)  goto 1500		!Pre-game?
	smask = smask .or. ROMBIT
	if (team .eq. 1)  2600, 2500
C.......Federation, Human
2500	if ((imask .and. (SIDMSK .or. CRDBIT)) .ne. 0)  goto 1500
	imask = imask .or. FEDBIT
	smask = (smask .and. ROMBIT) .or. FEDBIT
	goto 500
C.......Empire, Klingon
2600	if ((imask .and. (SIDMSK .or. CRDBIT)) .ne. 0)  goto 1500
	imask = imask .or. EMPBIT
	smask = (smask .and. ROMBIT) .or. EMPBIT
	goto 500
C.......Neutral
2700	if ((imask .and. (SIDMSK .or. (OBJMSK .and. .not. PLNBIT))) 
     +	.ne. 0)  goto 1500
	imask = imask .or. NEUBIT
	smask = NEUBIT
	omask = PLNBIT
	goto 500
C.......Captured
2800	if ((imask .and. (SIDMSK .or. (OBJMSK .and. .not. PLNBIT))) 
     +	.ne. 0)  goto 1500
	imask = imask .or. CAPBIT
	smask = FEDBIT .or. EMPBIT
	omask = PLNBIT
	goto 500
C.......ALL
2850	if ((imask .and. (ALLBIT .or. CRDBIT)) .ne. 0)  goto 1500
	imask = imask .or. ALLBIT
	if (((imask .and. SIDMSK) .eq. 0) .and. (cmd .ne. TARCMD)) 
     +	smask = FEDBIT .or. EMPBIT .or. NEUBIT .or. ROMBIT
	if ((imask .and. RNGBIT) .eq. 0)  range = MAXINT
	goto 500
C.......Range
2900	if (who .eq. 0)  goto 1500		!Pre-game?
	if ((imask .and. (RNGBIT .or. CRDBIT)) .ne. 0)  goto 1500
	imask = imask .or. RNGBIT
	range = vallst(p)
	if (range .lt. 1)  goto 1500
	goto 500
C.......Closest
3000	if (who .eq. 0)  goto 1500		!Pre-game?
	if ((imask .and. (CLSBIT .or. CRDBIT .or. OUTMSK)) .ne. 0) 
     +	goto 1500
	imask = imask .or. CLSBIT
	lmask = LSTBIT
	if ((imask .and. RNGBIT) .eq. 0)  range = MAXINT
	goto 500
C----------------------------------------------------------------------
C		List and summary selection
C----------------------------------------------------------------------
C.......LIST
3100	if ((imask .and. (OUTMSK .or. CRDBIT .or. CLSBIT .or. NAMBIT)) 
     +	.ne. 0)  goto 1500
	imask = imask .or. LSTBIT
	lmask = lmask .or. LSTBIT
	if ((cmd .ne. SUMCMD) .and. ((imask .and. SUMBIT) .eq. 0)) 
     +	lmask = LSTBIT
	goto 500
C.......SUMMARY
3200	if ((imask .and. (OUTMSK .or. CRDBIT .or. CLSBIT .or. NAMBIT)) 
     +	.ne. 0)  goto 1500
	imask = imask .or. SUMBIT
	if ((imask .and. RNGBIT) .eq. 0)  range = MAXINT
	lmask = lmask .or. SUMBIT
	if ((cmd .ne. LSTCMD) .and. ((imask .and. LSTBIT) .eq. 0)) 
     +	lmask = SUMBIT
	goto 500
	end
C	LSTFLG -- Set LIST flags
C	Set selection bits in SHPLST, BASLST, and PLNLST according
C	to the masks returned by LSTSCN for the LIST command.
	subroutine LSTFLG (*)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	include 'lstvar/nolist'
	gxf = IRNBIT					!"in range"
	if (range .gt. KGALV)  gxf = IGMBIT		!"in game"
	if ((imask .and. RNGBIT) .ne. 0)  gxf = ISRBIT	!"in specified range"
	grpbts = 0
	if ((smask .ne. sbits(team)) .and. (range .gt. KRANGE) .and. 
     +	(gxf .ne. IGMBIT))  grpbts = KNOBIT
	gxf = gxf .or. lmask
C	---------------------------------------------------------------
	if ((imask .and. CRDBIT) .eq. 0)  goto 1200
C	Specific coordinate was given ---------------------------------
 100	code = disp(Vpos,Hpos)		!display code of object
	object = code/100		!object code
	index = mod(code,100)		!object index
	side = 0			!in case empty, star, or black hole
	d = pdist (Vpos, Hpos, sVpos, sHpos) !distance from ship
	goto (600, 600, 700, 700, 500, 900, 900, 900)  object !E,B,[],(),~~,@,+@,-@
	if (d .gt. KRANGE)  goto 300
	if (cmd .ne. LSTCMD)  goto 1100
 200	call lstobj  ;  return
 300	call out (lstf01,0)	!"Sir, our sensors can't scan as far as"
	call prloc (Vpos, Hpos, 1, 0, KABS, SHORT)
	return
 500	side = 3					!Romulan
	scn = 0
	goto 1000
 600	side = object					!ship
	scn = 0
	goto 1000
 700	if ((omask .and. BASBIT) .eq. 0)  goto 1100
	side = object - 2				!base
	scn = base(index,4,side)
	goto 1000
 900	if ((omask .and. PLNBIT) .eq. 0)  goto 1100
	side = object - 6				!planet
	scn = locpln(index,4)

1000	ctr = 0
	call lstupd (dummy, ctr, scn, dummy)
	if (ctr .ne. 0)  200, 300
C	Specified object was not at coordinate (BASES, PLANETS, or
C	TARGETS command)
1100	if (cmd .eq. BASCMD)  call out (lstf02,0)	!"No base"
	if (cmd .eq. PLNCMD)  call out (lstf03,0)	!"No planet"
	if (cmd .eq. TARCMD)  call out (lstf04,0)	!"No target"
	call prloc (Vpos, Hpos, 1, 0, ocflg, LONG)
	return
C	---------------------------------------------------------------
1200	if ((imask .and. NAMBIT) .eq. 0)  goto 2300
	call crlf
	if ((imask .and. ROMBIT) .eq. 0)  goto 1700
C	ROMULAN -------------------------------------------------------
	if (ROMOPT)  goto 1300
	call out (type06,1)	!Romulans are NOT in this game
	goto 1700
1300	if (ROM)  goto 1400
	call out (lstf05,1)	!"The Romulan is dead"
	goto 1700
1400	side = 3  ;  code = 500  ;  object = 5
	Vpos = locr(KVPOS)  ;  Hpos = locr(KHPOS)
	call lstupd (dummy, dummy, -1, dummy)
	call lstobj
C	---------------------------------------------------------------
1700	if (ships .eq. 0)  goto 2200
C	Ship name -----------------------------------------------------
	do 2100 index = 1, KNPLAY
	  if ((ships .and. bits(index)) .eq. 0)  goto 2100	!ship not selected
	  side = 1  ;  if (index .gt. KNPLAY/2)  side = 2
	  object = side
	  code = object * 100 + index
	  if (.not. alive(index))  goto 1800		!ship not in game
	  Vpos = shpcon(index,KVPOS)  ;  Hpos = shpcon(index,KHPOS)
	  if (disp(Vpos,Hpos) .eq. 0)  goto 1800	!dead, but not gone yet
	  call lstupd (dummy, dummy, -1, dummy)
	  call lstobj
	  goto 2100
1800	  call odisp (code,0)
	  call out (' is not in the game',1)
2100	continue
2200	return
C	---------------------------------------------------------------
2300	clsest = MAXINT
	if ((omask .and. SHPBIT) .eq. 0)  goto 3000
C	SHIP ----------------------------------------------------------
	if ((smask .and. ROMBIT) .eq. 0)  goto 2600	!Rom not selected
	if (.not. ROM)  goto 2600			!Rom not in game
	Vpos = locr(1)  ;  Hpos = locr(2)  ;  side = 3
	scn = 0						!no scan if out of range enemy
	if ((gxf .and. IGMBIT) .ne. 0)   scn = -1	!unless asking for entire game
	if ((imask .and. CLSBIT) .ne. 0)  scn = 0	!no scan if asking for closest
	call lstupd (romlst, romctr, scn, rxf)
2600	first = 1  ;  last = KNPLAY
	if ((smask .and. FEDBIT) .eq. 0)  first = KNPLAY/2+1	!Fed not selected
	if ((smask .and. EMPBIT) .eq. 0)  last = KNPLAY/2	!Emp not selected
	if (first .gt. last)  goto 3000				!neither; was Rom
	do 2900 i = first, last
	  if (.not. alive(i))  goto 2900			!ship not in game
	  Vpos = shpcon(i,KVPOS)  ;  Hpos = shpcon(i,KHPOS)
	  if (disp(Vpos,Hpos) .eq. 0)  goto 2900		!dead, but not gone yet
	  side = 1  ;  if (i .gt. KNPLAY/2)  side = 2
	  scn = 0				!no scan if out of range enemy
	  if ((imask .and. CLSBIT) .eq. 0)  goto 2700 !~ looking for closest
	  if (i .ne. who)  2800, 2900		!don't include self as closest
2700	  if ((gxf .and. IGMBIT) .ne. 0)  scn = -1	!scan if asking for entire game
2800	  call lstupd (shplst(i), shpctr(side), scn, sxf(side))
2900	continue
C	---------------------------------------------------------------
3000	if ((omask .and. BASBIT) .eq. 0)  goto 3500
C	BASE ----------------------------------------------------------
	first = 1  ;  last = 2
	if ((smask .and. FEDBIT) .eq. 0)  first = 2	!Fed not selected
	if ((smask .and. EMPBIT) .eq. 0)  last = 1	!Emp not selected
	do 3400 side = first, last
	  do 3300 i = 1, KNBASE
	    if (base(i,3,side) .le. 0)  goto 3300	!base is dead
	    Vpos = base(i,KVPOS,side)  ;  Hpos = base(i,KHPOS,side)
	    call lstupd (baslst(i,side), basctr(side), base(i,4,side), 
     +	                bxf(side))
3300	  continue
3400	continue
C	---------------------------------------------------------------
3500	if ((omask .and. PLNBIT) .eq. 0)  goto 3800
C	PLANET --------------------------------------------------------
	if (nplnet .eq. 0)  goto 3800			!no planets left
	do 3700 i = 1, nplnet
	  Vpos = locpln(i,KVPOS)  ;  Hpos = locpln(i,KHPOS)
	  side = dispc(vpos,hpos) - 6
	  if ((smask .and. sbits(side)) .eq. 0)  goto 3700	!wrong side
	  call lstupd (plnlst(i), plnctr, locpln(i,4), pxf(side))
3700	continue
C	---------------------------------------------------------------
3800	if ((imask .and. CLSBIT) .eq. 0)  goto 3900
	Vpos = Vposc  ;  Hpos = Hposc
	imask = imask .and. .not. CLSBIT
	if (clsest .eq. MAXINT)  4000, 100
3900	if ((grpbts .and. (LSTBIT .or. SUMBIT)) .ne. 0)  return
4000	msg = locf(lstf06)				!"Sir, there are no"
	if (oflg .ne. LONG)  msg = locf(lstf07)		!"No"
	call out (msg,0)
	if ((grpbts .and. KNOBIT) .ne. 0)  call out (known,0)	!" known"
	msg = 0
	if (smask .eq. NEUBIT)  msg = locf(lstf08)	!" neutral"
	if (smask .eq. FEDBIT)  msg = locf(lstf09)	!" Federation"
	if (smask .eq. EMPBIT)  msg = locf(lstf10)	!" Empire"
	if ((smask .eq. (FEDBIT .or. EMPBIT)) .and. (omask .eq. PLNBIT)) 
     +	msg = locf(lstf11)				!" captured"
	if (((smask .and. ROMBIT) .ne. 0) .and. (smask .and. NEUBIT) 
     +	.eq. 0)  msg = locf(lstf12)			!" enemy"
	call out (msg,0)
	if (omask .eq. PLNBIT)  msg = locf(lstf13)	!" planets"
	if (omask .eq. BASBIT)  msg = locf(lstf14)	!" bases"
	if (omask .eq. SHPBIT)  msg = locf(lstf15)	!" ships"
	if (omask .eq. (BASBIT .or. PLNBIT))  msg = locf(lstf16) !" ports"
	if (omask .eq. (PLNBIT .or. BASBIT .or. SHPBIT)) 
     +	msg = locf(lstf17)				!" forces"
	call out (msg,0)
	if (oflg .eq. SHORT)  goto 4100
	msg = locf(ingame)					!" in game"
	if ((grpbts .and. IRNBIT) .ne. 0)  msg = locf(inrang)	!" in range"
	if ((grpbts .and. ISRBIT) .ne. 0)  msg = locf(inspra)	!" in specified range"
	if ((grpbts .and. IGMBIT) .ne. 0)  msg = locf(ingame)	!" in game"
	call out (msg,0)
4100	call crlf
	return 1
	end
C	LSTUPD -- Update list flags for given object (ship, base, planet)
C	if it's allowed to be listed (or included in a summary).
	subroutine LSTUPD (lstmsk, objctr, scnbts, xxf)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	include 'lstvar/nolist'
	d = pdist (sVpos, sHpos, Vpos, Hpos)
	xf = gxf
	if (d .le. KRANGE)  goto 400		!within range
	if (side .eq. team)  goto 400		!friendly
	if (.not. PASFLG)  goto 100
	xf = xf .or. PASBIT  ;  goto 400	!god
 100	xf = xf .or. ORNBIT			!out of range
	if (range .le. KRANGE)  goto 200
	grpbts = grpbts .or. KNOBIT		!"no KNOWN x in s.range/game"
	if ((xf .and. IGMBIT) .eq. 0)  xf = xf .or. KNOBIT
 200	txf = txf .or. xf			!update target summary flags
	if ((scnbts .and. team) .ne. 0)  goto 400  !already scanned
	if ((xf .and. SUMBIT) .eq. 0)  goto 700	!not requesting summary
	if ((xf .and. IGMBIT) .eq. 0)  goto 700	!not requesting entire game
	xf = xf.and..not.LSTBIT			!allow summary only (no list)
	goto 500
 400	if (d .gt. range)  goto 700		!not in requested range
	if ((imask .and. CLSBIT) .ne. 0)  goto 600  !looking for closest
 500	lstmsk = lstmsk .or. xf
	objctr = objctr + 1
	grpbts = grpbts .or. xf
	xxf = xxf .or. xf
	return
 600	if (d .gt. clsest)  goto 700		!looking for closest
	clsest = d  ;  Vposc = Vpos  ;  Hposc = Hpos
 700	grpbts = grpbts .or. (xf .and. (IRNBIT .or. ISRBIT .or. 
     +	IGMBIT .or. ORNBIT))
	xxf = xxf .or. xf
	return
	end
C	LSTOUT -- Output requested LIST info.
	subroutine LSTOUT
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	include 'lstvar/nolist'
	integer sum(0:2)
	sum(0) = 0 ; sum(1) = 0 ; sum(2) = 0	!nothing flagged for summary
	nt = 0					!no targets yet
C.......Romulan
	if (romctr .eq. 0)  goto 100
	xf = romlst
	if ((xf .and. LSTBIT) .eq. 0)  goto 50
	side = 3  ;  code = DXROM*100  ;  object = DXROM
	vpos = locr(KVPOS)  ;  hpos = locr(KHPOS)
	call crlf
	call lstobj
   50	if ((xf .and. SUMBIT) .eq. 0)  goto 100
	nt = nt + 1
	call crlf
	call lstsum (romctr, 'Romulan', rxf)
C.......ships
  100	first = 1  ;  last = KNPLAY
	if (shpctr(1) .eq. 0)  first = KNPLAY/2 + 1
	if (shpctr(2) .eq. 0)  last = KNPLAY/2
	if (first .gt. last)  goto 300
	call crlf
	do 200 index = first, last
	  xf = shplst(index)
	  if (xf .eq. 0)  goto 200
	  side = 1  ;  if (index .gt. KNPLAY/2)  side = 2
	  if ((xf .and. LSTBIT) .eq. 0)  goto 150
	  object = side
	  code = object * 100 + index
	  vpos = shpcon(index,KVPOS)  ;  hpos = shpcon(index,KHPOS)
	  call lstobj
  150	  if ((xf .and. SUMBIT) .eq. 0)  goto 200
	  sum(side) = sum(side) + 1
	  if (side .ne. team)  nt = nt + 1
  200	continue
	if (cmd .eq. TARCMD)  goto 300
	call crlf
	call lstsum (sum(1), fedshp, sxf(1))	!"Federation ship"
	call lstsum (sum(2), empshp, sxf(2))	!"Empire ship"
C.......bases
  300	first = 1  ;  last = 2
	if (basctr(1) .eq. 0)  first = 2
	if (basctr(2) .eq. 0)  last = 1
	if (first .gt. last)  goto 600
	call crlf
	do 500 side = first, last
	  do 400 index = 1, KNBASE
	    xf = baslst(index,side)
	    if (xf .eq. 0)  goto 400
	    if ((xf .and. LSTBIT) .eq. 0)  goto 350
	    object = side + 2
	    code = object * 100 + index
	    vpos = base(index,KVPOS,side) ; hpos = base(index,KHPOS,side)
	    call lstobj
	    if ((xf .and. PASBIT) .eq. 0) 
     +	    base(index,4,side) = base(index,4,side) .or. team
  350	    if ((xf .and. SUMBIT) .eq. 0)  goto 400
	    sum(side) = sum(side) + 1
	    if (side .ne. team)  nt = nt + 1
  400	  continue
  500	continue
	if (cmd .eq. TARCMD)  goto 600
	call crlf
	call lstsum (sum(1), fedbas, bxf(1))	!"Federation base"
	call lstsum (sum(2), empbas, bxf(2))	!"Empire base"
C.......planets
  600	if (plnctr .eq. 0)  goto 800
	call crlf
	do 700 index = 1, nplnet
	  xf = plnlst(index)
	  if (xf .eq. 0)  goto 700
	  vpos = locpln(index,KVPOS)  ;  hpos = locpln(index,KHPOS)
	  object = dispc(vpos,hpos)
	  side = object - 6
	  if ((xf .and. LSTBIT) .eq. 0)  goto 650
	  code = object * 100 + index
	  call lstobj
	  if ((xf .and. PASBIT) .eq. 0) 
     +	  locpln(index,4) = locpln(index,4) .or. team
  650	  if ((xf .and. SUMBIT) .eq. 0)  goto 700
	  sum(side) = sum(side) + 1
	  if (side .eq. (3-team))  nt = nt + 1
  700	continue
	if (cmd .eq. TARCMD)  goto 800
	call crlf
	call lstsum (sum(0), neupln, pxf(0))	!"neutral planet"
	call lstsum (sum(1), fedpln, pxf(1))	!"Federation planet"
	call lstsum (sum(2), emppln, pxf(2))	!"Empire planet"
C.......targets summary
  800	if (cmd .ne. TARCMD)  return
	if (nt .eq. 0)  return
	call crlf
	call lstsum (nt, 'target', txf)
	return
	end
C	LSTSUM -- List summary line
	subroutine LSTSUM (n, str, f)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	integer str(1)
	if (n .eq. 0)  return
	call odec (n,3)
	if ((f .and. KNOBIT) .ne. 0)  call out (known,0)  !" known"
	call space
	call out (str,0)  ;  if (n .ne. 1)  call outc('s')
	if (oflg .eq. SHORT)  goto 100
	msg = locf(inrang)				!" in range"
	if ((f .and. ISRBIT) .ne. 0)  msg = locf(inspra)  !" in specified range"
	if ((f .and. IGMBIT) .ne. 0)  msg = locf(ingame)  !" in game"
	call out (msg,0)
  100	call crlf
	n = 0
	return
	end
C	LISOBJ -- List object (ship, base, or planet).  Include
C	possibly name, location, shield percent, number of builds,
C	depending on the object, range, side, etc.  Flag line with *
C	in column 1 if the object is an enemy.
	subroutine LSTOBJ
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	include 'lstvar/nolist'
C	Input from LSTVAR:
C	  SVPOS,SHPOS	ship position
C	  CODE		display code of object
C	  OBJECT	object code [CODE/100]
C	  INDEX		object index [MOD(CODE,100)]
C	  VPOS,HPOS	position of object
C	  SIDE		which side the object is on
C	  CMD		command being executed
C	  XF		ORNBIT
	if ((side .eq. 0) .or. (side .eq. team) .or. (cmd .eq. TARCMD)) 
     +	goto 100
	call outc ('*')  ;  goto 200
  100	call space
  200	call odisp (code,0)
	if (oflg .eq. LONG)  call tab (14)
	if (oflg .ne. LONG)  call tab (5)
	goto (400, 400, 600, 600, 300, 700, 700, 700)  object
C.......Romulan
  300	if ((xf .and. ORNBIT) .ne. 0)  goto 500		!out of range
	call prloc (vpos, hpos, 0, 2, ocflg, oflg)
	call oflt (erom,6)
	if (oflg .ne. SHORT)  call outc ('%')
	goto 800
C.......ship
  400	if ((xf .and. ORNBIT) .ne. 0)  goto 500		!out of range
	call prloc (vpos, hpos, 0, 2, ocflg, oflg)
	spc = shpcon(index,KSHCON) * shpcon(index,KSSHPC)
	call osflt (spc,6)
	if (oflg .ne. SHORT)  call outc ('%')
	goto 800
  500	call out ('out of range',0)
	goto 800
C.......base
  600	call prloc (vpos, hpos, 0, 2, ocflg, oflg)
	if ((xf .and. ORNBIT) .ne. 0)  goto 800		!out of range
	call oflt (base(index,3,side),6)
	if (oflg .ne. SHORT)  call outc ('%')
	goto 800
C.......planet
  700	call prloc (vpos, hpos, 0, 2, ocflg, oflg)
	b = locpln(index,3)  ;  if (b .eq. 0)  goto 800
	call odec (b,6)
	if ((oflg .eq. LONG) .and. (b .ne. 1))  call out (' builds',0)
	if ((oflg .eq. LONG) .and. (b .eq. 1))  call out (build3,0)
	if (oflg .eq. MEDIUM)  call out (' b',0)
  800	call crlf
	return
	end
C	This routine drives the WARP and IMPULSE engine movement.
C	The desired destination coordinates are processed, the path
C	searched for collisions, and the energy consumption computed.
	subroutine MOVE (*)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /chkout/ V1, H1, V2, H2, dcode, disV, disH
	real d, disV, disH
	iflg = 0					!warp engines
	if (shpdam(who,KDWARP) .lt. KCRIT)  goto 100	!warp engines kaput?
	call out (wrpdam,1)
	return 1
	entry IMPULS (*)
	iflg = 1					!impulse engines
	if (shpdam(who,KDIMP) .lt. KCRIT)  goto 100	!impulse engines kaput?
	call out (impdam,1)
	return 1
 100	v = etim(tim0) + (slwest * 1000) + 1000
	d = 0.0    					!initialize random movement
	randam = iran (4000)				!penalty for going too fast
	time = randam / 30
*.......Get proposed movement
	tem = locate(2)
 200	if (tem .lt. 0)  return 1
	if (tem .ne. 0)  goto 300
	tem = reloc(2)
	goto 200
*.......Convert to relative coordinates
 300	iV = vallst(1) - shpcon(who,KVPOS)
	iH = vallst(2) - shpcon(who,KHPOS)
	if (.not. ((iV .eq. 0) .and. (iH .eq. 0)))  goto 700
	if (oflg)  400, 400, 500
 400	call out (error2,1)  ;  goto 600
 500	call out (error1,1)
 600	if (reloc(2) .lt. 0)  return 1			!aborted move
	goto 300   					!try again
 700	shpcon(who,KSPCON) = GREEN			!condition green
	docked(who) = .FALSE.
	ia = max0 (iabs(iV), iabs(iH))			!how far to go?
	if (shpdam(who,KDCOMP) .ge. KCRIT)  d = (ran(0) - 0.5) / 2.0	!add deflection if computer damaged
	if (iflg .eq. 1)  goto 800			!impulse
	if (ia .gt. 6)  goto 1300			!TOO fast!
	if ((shpdam(who,KDWARP) .gt. 0) .and. (ia .gt. 3))  goto 900
	if (ia .gt. 4)  goto 1700
	goto 1900
*.......Impulse movement
 800	if (ia .eq. 1)  goto 1900			!going only 1 sector?
	if (oflg .eq. long)  call out (move1A,0)
	call out (move1B,1)
	return 1
 900	if (oflg)  1000, 1000, 1100			!warp engines damaged
1000	call out (move2S,1)  ;  goto 1200
1100	call out (move2L,1)
1200	return 1
1300	if (oflg)  1400, 1400, 1500			!trying to move > 6 sectors
1400	call out (move3S, 0)  ;  goto 1600
1500	call out (move3L,0)
1600	if (shpdam(who,KDWARP) .gt. 0)  call out2c ('3.')
	if (shpdam(who,KDWARP) .eq. 0)  call out2c ('6.')
	return 1
*.......warp 5 or 6 -- might work
1700	if (oflg .eq. long)   call out (engoff,0)	!warning of warp factor
	if (oflg .ne. short)  call out (move5L,1)
	if (oflg .eq. short)  call out (move5S,1)
	tran = iran (100)
	if (.not. (((tran .gt. 80) .and. (ia .ge. 6)) .or. 
     +	((tran .gt. 90) .and. (ia .eq. 5))))  goto 1900	!engines blown?
*.......Warp engines damaged by overheating (ie speeding)
	call out (move06,0)
	call oflt (randam, 3)
	call out (move08,1)
	if (oflg .eq. short)  goto 1800
	call out (move09,0)
	call oflt (time, 2)
	call out (strdat,1)
1800	shpdam(who,KDWARP) = shpdam(who,KDWARP) + randam
*.......Check path for obstacles, move to last empty sector
1900	call check (shpcon(who,KVPOS), shpcon(who,KHPOS), iV, iH, ia, d)
	ied = 40 * ia * ia				!compute energy consumption
	if (shpcon(who,KSHCON) .gt. 0)  ied = 2 * ied
	if (trstat(who) .ne. 0)  ied = 3 * ied
	shpcon(who,KSNRGY) = shpcon(who,KSNRGY) - ied
*	move ship
	if ((V1 .eq. shpcon(who,KVPOS)) .and. 
     +	(H1 .eq. shpcon(who,KHPOS)))  goto 2000
	indxto = (v1-1)*25 + (h1 - 1)/3 + 1
	indxfm = (shpcon(who, kvpos) - 1)*25 + (shpcon(who, khpos) - 1)/3 + 1
	call lock (board(indxto))
	if (lkfail) return 1
	if (indxto .eq. indxfm) goto 333
	call lock (board(indxfm))
	if (.not. lkfail) goto 333
		call unlock (board(indxto))
		return 1		! failed to move
333	call setdsp (shpcon(who,KVPOS), shpcon(who,KHPOS), 0)
	call setdsp (V1, H1, (team * 100) + who)
	shpcon(who,KVPOS) = V1
	shpcon(who,KHPOS) = H1
	if (indxto .ne. indxfm) call unlock (board(indxfm))
	call unlock (board(indxto))
	if (trstat(who) .eq. 0)  goto 2000
	tl = disp(shpcon(trstat(who),KVPOS),shpcon(trstat(who),KHPOS))
	call setdsp (V1-int(disV), H1-int(disH), tl)
	call setdsp (shpcon(trstat(who),KVPOS), 
     +	shpcon(trstat(who),KHPOS), 0)
	shpcon(trstat(who),KVPOS) = V1 - disV
	shpcon(trstat(who),KHPOS) = H1 - disH
2000	if (dcode .ne. 0)  call out (move10,1)		!run into anything?
*.......Compute pause time for move
	ptime = v - etim(tim0)
	return
	end
C	This routine is called by SNOVA to damage an object caught by
C	an exploding star.  Scoring is updated, plus modifying and/or
C	killing the object specified.
	subroutine NOVA (nplc, j)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /chkout/ V1, H1, iVc, iHc, dcode, idisV, idisH
	real idisV, idisH
	Vfrom = iVc  ;  Hfrom = iHc
	Vto = V1  ;  Hto = H1
	if (nplc .eq. DXROM)  goto 800					!Romulan?
	if ((nplc .ge. DXNPLN) .and. (nplc .le. DXEPLN))  goto 1000	!Planet?
*.......Compute size of nova
	d = 1000
	if (nplc .ge. DXFBAS)  d = d - base(j,3,nplc-2)
	if ((nplc .lt. DXFBAS) .and. (shpcon(j,KSHCON) .gt. 0)) 
     +	d = d - shpcon(j,KSSHPC)
	if (d .lt. 200)  d = 250
	if (nplc .ge. DXFBAS)  goto 200		!base?
*.......Damage ship's devices
	do 100 i = 1, KNDEV
	  shpdam(j,i) = shpdam(j,i) + int(ran(0) * d * 4.0)
 100	continue
	if (shpdam(j,KDSHLD) .ge. KCRIT)  shpcon(j,KSHCON) = -1
*.......Update scoring due to nova
 200	ihita = d * 8 + iran (1000)
	if (PLAYER .and. (5-team .eq. nplc))  tpoint(KPBDAM) = 
     +	tpoint(KPBDAM) + ihita
	if ((.not. PLAYER) .and. (nplc .ge. DXFBAS))  rsr(KPBDAM) = 
     +	rsr(KPBDAM) + ihita
	if (PLAYER .and. (3-team .eq. nplc))  tpoint(KPEDAM) = 
     +	tpoint(KPEDAM) + ihita
	if ((.not. PLAYER) .and. (nplc .lt. DXFBAS))  rsr(KPEDAM) = 
     +	rsr(KPEDAM) + ihita
	if (PLAYER .and. (team+2 .eq. nplc))  tpoint(KPBDAM) = 
     +	tpoint(KPBDAM) - ihita
	if (PLAYER .and. (team .eq. nplc))  tpoint(KPEDAM) = 
     +	tpoint(KPEDAM) - ihita
*.......Damage ship
	if (nplc .ge. DXFBAS)  goto 500		!base?
	shpcon(j,KSDAM) = shpcon(j,KSDAM) + ihita
	shpcon(j,KSNRGY) = shpcon(j,KSNRGY) - ihita * ran(0)
	if (shpcon(j,KSHCON) .gt. 0)  shpcon(j,KSSHPC) = max0( 
     +	shpcon(j,KSSHPC) - 300 + iran(100), 0)
	if (shpcon(j,KSSHPC) .le. 0)  shpcon(j,KSHCON) = -1
*	Ship destroyed?  Else, displace it
	if ((shpcon(j,KSDAM) .lt. KENDAM) .and. (shpcon(j,KSNRGY) .gt. 0)) 
     +	goto 300
	call setdsp (shpcon(j,KVPOS), shpcon(j,KHPOS), 0)
	alive(j) = 0  ;  klflg = 2
	goto 400
 300	call jump (nplc,j)			!displace the ship
 400	dispfr = DXSTAR * 100  ;  dispto = (nplc * 100) + j  ;  iwhat = 8
	Vto = shpcon(j,KVPOS)  ;  Hto = shpcon(j,KHPOS)
	shstto = shpcon(j,KSSHPC)  ;  shcnto = shpcon(j,KSHCON)
	if ((klflg .ne. 0) .and. PLAYER .and. (team .eq. nplc)) 
     +	tmscor(team,KPEKIL) = tmscor(team,KPEKIL) - 5000
	if ((klflg .ne. 0) .and. PLAYER .and. (team .ne. nplc)) 
     +	tmscor(team,KPEKIL) = tmscor(team,KPEKIL) + 5000
	if ((klflg .ne. 0) .and. (.not. PLAYER)) 
     +	rsr(KPEKIL) = rsr(KPEKIL) + 5000
	call pridis (shpcon(j,KVPOS), shpcon(j,KHPOS), KRANGE, 0, 0)
	call makhit			!send hit message
	if (trstat(j) .ne. 0)  call trcoff (j)	!break tractor beam?
	return
*.......Damage base
 500	jbase = nplc - 2
	if (base(j,3,jbase) .ne. 1000)  goto 600  !base ALREADY damaged?
	dispfr = DXSTAR * 100  ;  dispto = (nplc * 100) + j  ;  iwhat = 9
	call pridis (30, 30, 100, jbase, 0)
	dbits = dbits .and. .not. nomsg
	call makhit		!send galaxy-wide distress call
 600	base(j,3,jbase) = max0 (base(j,3,jbase) - 300 + iran (100) , 0)
	if (base(j,3,jbase) .gt. 0)  call jump (nplc,j)	!if base still alive, displace
	dispfr = DXSTAR * 100  ;  dispto = (nplc * 100) + j  ;  iwhat = 8
	Vfrom = iVc  ;  Hfrom = iHc
	Vto = base(j,KVPOS,jbase)  ;  Hto = base(j,KHPOS,jbase)
	shstto = base(j,3,jbase)  ;  shcnto = 1
	if (base(j,3,jbase) .gt. 0)  goto 700
	if (.not. PLAYER)  rsr(KPBDAM) = rsr(KPBDAM) + 10000
	if (PLAYER .and. (team .eq. jbase))  tpoint(KPBDAM) = 
     +	tpoint(KPBDAM) - 10000
	if (PLAYER .and. (team .ne. jbase))  tpoint(KPBDAM) = 
     +	tpoint(KPBDAM) + 10000
	nbase(jbase) = nbase(jbase) - 1
	call baskil (jbase)
	klflg = 2
 700	call pridis (base(j,KVPOS,jbase), base(j,KHPOS,jbase), 
     +	KRANGE, 0, 0)
	call makhit
*.......Base killed?
	if (base(j,3,jbase) .gt. 0)  return
	call setdsp (base(j,KVPOS,jbase), base(j,KHPOS,jbase), 0)
	iwhat = 10  ;  dispfr = DXSTAR * 100  ;  dispto = (nplc * 100) + j
	call pridis (30, 30, 100, jbase, 0)
	dbits = dbits .and. .not. nomsg
	Vto = base(j,KVPOS,jbase)  ;  Hto = base(j,KHPOS,jbase)
	call makhit		!send galaxy-wide death notice
	return
*.......Romulan damaged/killed by nova
c-- 800	if (iran(2) .eq. 1)  call deadro (d1,d2)!kill Romulan?
800	continue			! don't kill the Romulan
	if (ROM)  call jump (DXROM,1)
	if (ROM)  erom = erom / 2
	if (.not. PLAYER)  rsr(KPRKIL) = rsr(KPRKIL) - erom
	if (PLAYER)  tpoint(KPRKIL) = tpoint(KPRKIL) + erom
	dispfr = DXSTAR * 100  ;  dispto = DXROM * 100  ;  iwhat = 8
	shstto = erom  ;  shcnto = 1
	Vto = locr(KVPOS)  ;  Hto = locr(KHPOS)
	call pridis (Vto, Hto, KRANGE, 0, 0)
	call makhit			!send hit message
	if (ROM)  goto 900
	if (.not. PLAYER)  rsr(KPRKIL) = rsr(KPRKIL) - 5000
	if (PLAYER)  tpoint(KPRKIL) = tpoint(KPRKIL) + 5000
 900	return
*.......Planet damaged/destroyed by nova
1000	dispfr = DXSTAR * 100  ;  dispto = (nplc * 100) + j  ;  iwhat = 8
	call lock (plnlok,'NOVA')		!lock LOCPLN array
	if (lkfail) return			! ignore the destruction
	Vto = locpln(j,KVPOS)  ;  Hto = locpln(j,KHPOS)
	locpln(j,3) = locpln(j,3) - 3
	if (locpln(j,3) .lt. 0)  klflg = 2	!planet killed?
	shstto = max0 (locpln(j,3), 0)
	call pridis (Vto, Hto, KRANGE, 0, 0)
	call makhit			!send hit message
	if (locpln(j,3) .ge. 0)  goto 1100
*	Update planet information
	if (PLAYER) tpoint(KNPDES) = tpoint(KNPDES) - 1000
	if (.not. PLAYER)  rsr(KNPDES) = rsr(KNPDES) - 1000
	pteam = dispc (locpln(j,KVPOS), locpln(j,KHPOS)) - DXNPLN
	call setdsp (locpln(j,KVPOS), locpln(j,KHPOS), 0)
	call plnrmv (j,pteam)
1100	call unlock (plnlok)			!unlock LOCPLN array
	return
	end
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
C	This routine searches for and prints out messages received by
C	the ship's sub-space radio.
	subroutine OUTMSG
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /omlocl/ msg(16)
 100	dbits = 0  ;  dispfr = 0
	if (msgflg(who) .eq. 0)  return		!any more messages?
	call getmsg (who, msg)			!get another message
	if (dispfr .eq. 0)  goto 400		!message not from player
	if ((gagmsg .and. bits(mod(dispfr,100))) .ne. 0)  goto 100
	call out (mess01,0)			!message from ...
	call odisp (dispfr, 1)
	call out (mess02,0)
	k = 1
	do 300 i = 1, KNPLAY			!message to ...
	  if ((dbits .and. k) .eq. 0)  goto 200
	  call out2c (names(i,3))
 200	  k = k * 2
 300	continue
*.......Print out message
	call crlf
 400	call out (msg,1)
	goto 100
	end
C	This routine sets (and unsets) the password flag for use in
C	debugging, cheating, etc.
	subroutine PASWRD
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	PASFLG = equal(tknlst(2), KPASS, 1)	!match the password?
	if (PASFLG .eq. -1)  PASFLG = 0		!not an exact match
C	70725 project added by merlyn (drforbin)
	if ((usrprj(0) .ne. "70000) .and. (usrprj(0) .ne. "337) .and. 
     +		(usrprj(0) .ne. "70006)
     +.and. (usrprj(0) .ne. "70725))		!added
     +		pasflg = 0
	if (PASFLG)  return			!is he ok?
	call out (unkcom, 0)			!WHAT password routine!?!
	if (oflg .ne. short)  call out (forhlp, 1)
	return
	end
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
C	This routine is used to randomly position objects in the
C	universe.  It can position one or many such objects in a
C	single call.  It is called by SETUP and ROMDRV.
	subroutine PLACE (object, n, V, H)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	do 600 k = 1, n
 100	  V = iran (KGALV)			!find random V location
	  H = iran (KGALH)			!find random H location
	  if (disp(V,H) .ne. 0)  goto 100	!position already filled?
	  if (object/100 .gt. DXESHP)  goto 500	!PLACEing a ship?
*	  Check to make sure ship is not PLACEd in enemy territory.
	  pteam = 3 - (object/100)
	  if (nbase(pteam) .le. 0)  goto 300
	  do 200 i = 1, KNBASE
	    if (ldis (V, H, base(i,KVPOS,pteam), base(i,KHPOS,pteam), 4)) 
     +	    goto 100
 200	  continue
 300	  if ((nplnet .le. 0) .or. (numcap(pteam) .le. 0))  goto 500
	  do 400 i = 1, nplnet
	    if (pteam .ne. dispc (locpln(i,KVPOS), locpln(i,KHPOS))) 
     +	    goto 400
	    if (ldis (V, H, locpln(i,KVPOS), locpln(i,KHPOS), 2)) 
     +	    goto 100
 400	  continue
 500	  call setdsp (V, H, object)		!set up display code
c---	  if (object/100 .lt. DXSTAR)  call setdsp (V, H, (disp(V,H) + k))
 600	continue
	return
	end
C	This routine controls the phaser defenses of planets.  These
C	are activated whenever a player (or the Romulan) makes a time-
C	consuming move.  A player only activates enemy and neutral
C	planets, not planets on his own side (the Romulan activates
C	ALL planets).  The size of the hit is controlled by how many
C	'BUILDS' the planet has undergone.
	subroutine PLNATK
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	if (nplnet .le. 0)  go to 400
	do 300 k = 1, nplnet
	  pcode = dispc (locpln(k,KVPOS), locpln(k,KHPOS))
	  pteam = pcode - DXNPLN
	  if ((pcode .eq. DXNPLN) .and. (iran(2) .eq. 1))  goto 300	!50% chance of attack
	  if (PLAYER .and. (pteam .eq. team))  goto 300	!don't activate friendly planets
*.........Search for a player within range
	  do 200 j = 1, KNPLAY
	    jtype = DXFPLN
	    if (j .gt. KNPLAY/2)  jtype = DXEPLN
	    if ((pcode .eq. jtype) .or. (.not. alive(j)))  goto 200
	    if (disp(shpcon(j,KVPOS),shpcon(j,KHPOS)) .le. 0)  goto 200
	    if (.not. ldis (shpcon(j,KVPOS), shpcon(j,KHPOS), 
     +	    locpln(k,KVPOS), locpln(k,KHPOS), 2))  goto 200	!in range?
*	    Set up parameters for call to MAKHIT
	    dispfr = disp (locpln(k,KVPOS), locpln(k,KHPOS))
	    dispto = disp (shpcon(j,KVPOS), shpcon(j,KHPOS))
	    shstfr = locpln(k,3)
	    Vfrom = locpln(k,KVPOS)  ;  Hfrom = locpln(k,KHPOS)
	    Vto   = shpcon(j,KVPOS)  ;  Hto   = shpcon(j,KHPOS)
	    shjump = 0
	    iwhat = 1  ;  phit = (50 + (30 * locpln(k,3))) / numply
	    id = pdist (Vfrom, Hfrom, Vto, Hto)
	    call phadam (2, j, id, phit, .FALSE.)	!hit him!
	    if (pcode .ne. DXNPLN)  tmscor(pteam,KPEDAM) = 
     +	    tmscor(pteam,KPEDAM) + ihita
	    if ((klflg .ne. 0) .and. (pcode .ne. DXNPLN)) 
     +	    tmscor(pteam,KPEKIL) = tmscor(pteam,KPEKIL) + 5000
	    call pridis (shpcon(j,KVPOS), shpcon(j,KHPOS), KRANGE, 
     +	    pteam, 0)
	    call pridis (shpcon(j,KVPOS), shpcon(j,KHPOS), 4, 0, 1)
	    call makhit				!send hit message
 200	  continue
*.........Hit romulan if he's alive and in range
	  if (.not. ROM)  goto 300
	  if (.not. ldis(locr(KVPOS), locr(KHPOS), locpln(k,KVPOS), 
     +	  locpln(k,KHPOS), 2))  goto 300
	  dispfr = disp (locpln(k,KVPOS), locpln(k,KHPOS))
	  dispto = DXROM * 100  ;  iwhat = 1
	  shstfr = locpln(k,3)
	  Vfrom = locpln(k,KVPOS)  ;  Hfrom = locpln(k,KHPOS)
	  Vto = locr(KVPOS)  ;  Hto = locr(KHPOS)  ;  shjump = 0
	  call pridis (locr(KVPOS), locr(KHPOS), KRANGE, pteam, 0)
	  call pridis (locr(KVPOS), locr(KHPOS), 4, 0, 1)
	  id = pdist (Vfrom, Hfrom, Vto, Hto)
	  call pharom (50 + (30 * locpln(k,3)), id)
	  shstto = erom  ;  shcnto = 1
	  if (pcode .ne. DXNPLN)  tmscor(pteam,KPRKIL) = 
     +	  tmscor(pteam,KPRKIL) + ihita
	  if ((.not. ROM) .and. (pcode .ne. DXNPLN)) 
     +	  tmscor(pteam,KPRKIL) = tmscor(pteam,KPRKIL) + 5000
	  call makhit				!send hit message
 300	continue
 400	return
	end
C	This routine is called whenever a planet is destroyed.  It
C	updates the planetary information, and checks if this ends
C	the game or undocks a player.
	subroutine PLNRMV (i,pteam)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	if (pteam .lt. 0) return
	if (i .gt. nplnet) return
	if (i .le. 0) return
	if (pteam .le. 0)  goto 100		!a captured planet?
	if (pteam .gt. 2) goto 100
	numcap(pteam) = numcap(pteam) - 1
	call baskil (pteam)			!anybody docked at it?
*	Shift the planet array into the empty row
 100	if (i .eq. nplnet) goto 110
	call blkmov (locpln(i+1,KVPOS), locpln(i,KVPOS), nplnet-i)
	call blkmov (locpln(i+1,KHPOS), locpln(i,KHPOS), nplnet-i)
	call blkmov (locpln(i+1,3), locpln(i,3), nplnet-i)
	call blkmov (locpln(i+1,4), locpln(i,4), nplnet-i)
110	nplnet = nplnet - 1
*	update display codes
	if ((nplnet .le. 0) .or. (i .gt. nplnet))  go to 300
	do 200 j = i, nplnet
	  call setdsp (locpln(j,KVPOS), locpln(j,KHPOS), 
     +	  (disp (locpln(j,KVPOS), locpln(j,KHPOS)) - 1))
 200	continue
 300	call endgam				!end of game?
	return
	end
C	This routine itemizes the current point totals.
	subroutine POINTS (DFLG)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /polocl/ total(4), fflg, eflg, rflg, iflg, owidth
	call blkset (total, 0, 4)
	if (DFLG)  goto 500
	fflg = .FALSE.  ;  eflg = .FALSE.
	rflg = .FALSE.  ;  iflg = .FALSE.
	if (ntok .gt. 1)  goto 50
	if (who .ne. 0)  iflg = .TRUE.		!No IFLG option in Pre-game
	if (iflg)  goto 900
	fflg = .TRUE.  ;  eflg = .TRUE.
	rflg = .TRUE.  ;  goto 700
*.......Identify input switches
  50	do 600 i = 2, KMAXTK
	  if (typlst(i) .ne. KALF)  goto 700
	  if (.not. (equal(tknlst(i), 'ME') .or. 
     +	  equal(tknlst(i), 'I')))  goto 100
	  if (who .eq. 0)  goto 100		!No IFLG option in Pre-game
	  iflg = .TRUE.  ;  goto 600
 100	  if (.not. (equal(tknlst(i), federa) .or. 
     +	  equal(tknlst(i), 'HUMANS')))  goto 200
	  fflg = .TRUE.  ;  goto 600
 200	  if (.not. (equal(tknlst(i), 'EMPIRE') .or. 
     +	  equal(tknlst(i), 'KLINGONS')))  goto 300
	  eflg = .TRUE.  ;  goto 600
 300	  if (.not. equal(tknlst(i), 'ROMULANS'))  goto 400
	  rflg = .TRUE.  ;  goto 600
 400	  if (equal (tknlst(i), 'ALL'))  goto 500
	  goto 800
 500	  fflg = .TRUE. ; eflg = .TRUE. ; rflg = .TRUE. ; iflg = .TRUE.
	  if (who .eq. 0)  iflg = .FALSE.	!No IFLG option in Pre-game
 600	continue
 700	if (.not. ROMOPT)  rflg = .FALSE.
	if (fflg .or. eflg .or. rflg .or. iflg)  goto 900
*.......Incorrect input, POINTS aborted
 800	call out (poin04,1)
	return
*.......Print out header for POINTS
 900	call crlf
	if (oflg)  1000, 1100, 1200
C	drforbin mod following lines
1000	call tab (14)  ;  goto 1300		!plus 3
1100	call tab (24)  ;  goto 1300		!plus 1
1200	call tab (31)				!plus 2
1300	if (.not. iflg)  goto 1400
	call space
	call out2w (names(who,1), names(who,2))
	if (oflg .ne. short)  call out2c ('  ')
1400	if (.not. fflg)  goto 1500
	call out (federa,0)
	call space
	if (oflg .ne. short)  call out2c ('  ')
1500	if (.not. eflg)  goto 1600
	call out (empire,0)
	call space
	if (oflg .ne. short)  call out2c ('  ')
1600	if (rflg)  call out (romula,0)
	call crlf
*.......Print out itemized scoring information
	do 3000 i = 1, KNPOIN
	  if (.not. ((iflg .and. (score(i, who) .ne. 0)) .or. (fflg .and. 
     +	  (tmscor(1,i) .ne. 0)) .or. (eflg .and. (tmscor(2,i) .ne. 0))
     +	  .or. (rflg .and. (rsr(i) .ne. 0))))  goto 3000
*       Output the proper title for score breakdown
	  goto (1700,1800,1900,2000,2100,2200,2300,2400) i
1700	  if (oflg .eq. short)  call out (poi11S, 0)
	  if (oflg .ne. short)  call out (poi11L, 0)
	  if (oflg .eq. long)  call tab (26)
	  goto 2500
1800	  if (oflg .eq. short)  call out (poi12S, 0)
	  if (oflg .ne. short)  call out (poi12L, 0)
	  if (oflg .eq. long)  call out (poin22, 0)
	  goto 2500
1900	  if (oflg .eq. short)  call out (poi13S, 0)
	  if (oflg .ne. short)  call out (poi13L, 0)
	  if (oflg .eq. long)  call tab (26)
	  goto 2500
2000	  if (oflg .eq. short)  call out (poi14S, 0)
	  if (oflg .ne. short)  call out (poi14L, 0)
	  if (oflg .eq. long)  call out (poin21, 0)
	  goto 2500
2100	  if (oflg .eq. short)  call out (poi15S, 0)
	  if (oflg .ne. short)  call out (poi15L, 0)
	  if (oflg .eq. long)  call out (poin23, 0)
	  goto 2500
2200	  if (oflg .eq. short)  call out (poi16S, 0)
	  if (oflg .ne. short)  call out (poi16L, 0)
	  if (oflg .eq. long)  call out (poin22, 0)
	  goto 2500
2300	  if (oflg .eq. short)  call out (poi17S, 0)
	  if (oflg .ne. short)  call out (poi17L, 0)
	  if (oflg .eq. long)  call out (poin20, 0)
	  goto 2500
2400	  if (oflg .eq. short)  call out (poi18S, 0)
	  if (oflg .ne. short)  call out (poi18L, 0)
	  if (oflg .eq. long)  call out (poin19, 0)
*.........Print out scores
2500	  if (.not. iflg)  goto 2600
	  call oflt (score(i, who), 11)
	  total(1) = total(1) + score(i, who)
2600	  if (.not. fflg)  goto 2700
	  call oflt (tmscor(1,i), 11)
	  total(2) = total(2) + tmscor(1,i)
2700	  if (.not. eflg)  goto 2800
	  call oflt (tmscor(2,i), 11)
	  total(3) = total(3) + tmscor(2,i)
2800	  if (.not. rflg)  goto 2900
	  call oflt (rsr(i), 11)  ;  total(4) = total(4) + rsr(i)
2900	  call crlf
3000	continue
*.......Print out the total points scored
	if (oflg)  3100, 3200, 3200
3100	call out (poi03S, 0)  ;  goto 3300
3200	call out (poi03L, 0)
	if (oflg .eq. long)  call tab (26)
3300	if (iflg)  call oflt (total(1), 11)
	if (fflg)  call oflt (total(2), 11)
	if (eflg)  call oflt (total(3), 11)
	if (rflg)  call oflt (total(4), 11)
	call crlf
*.......Print out the total number of ships commissioned
	if (.not. (fflg .or. eflg .or. rflg))  goto 4000
	if (oflg)  3400, 3500, 3500
3400	call out (poi07S, 0)  ;  goto 3600
3500	call out (poi07L, 0)
	if (oflg .eq. long)  call tab (24)
3600	owidth = 13  ;  if (oflg .eq. short)  owidth = 11
	if (iflg)  call spaces (owidth)
	if (fflg)  call odec (numshp(1), owidth)
	if (eflg)  call odec (numshp(2), owidth)
	if (rflg)  call odec (numrom, owidth)
*.......Print out the total score / number of players
	if (oflg)  3700, 3800, 3800
3700	call out (poi05S, 0)  ;  goto 3900
3800	call out (poi05L, 0)
	if (oflg .eq. long)  call tab (26)
3900	if (iflg)  call spaces (owidth)
	if (fflg)  call oflt (total(2) / numshp(1), 11)
	if (eflg)  call oflt (total(3) / numshp(2), 11)
	if (rflg)  call oflt (total(4) / numrom, 11)
*.......Print out the total score / number of turns used
4000	if (oflg)  4100, 4200, 4200
4100	call out (poi06S, 0)  ;  goto 4300
4200	call out (poi06L, 0)
	if (oflg .eq. long)  call tab (26)
4300	if (iflg)  call oflt (total(1) / shpcon(who,KNTURN), 11)
	if (fflg)  call oflt (total(2) / tmturn(1), 11)
	if (eflg)  call oflt (total(3) / tmturn(2), 11)
	if (rflg)  call oflt (total(4) / tmturn(3), 11)
	call crlf
	return
	end
C	This routine builds a low segment variable DBITS which
C	indicates (using individual bits) the active ships within ILIM
C	sectors of the specified location (iV, iH).  IFLAG modifies
C	this command: 0 = all ships, 1 = only federation ships, and
C	2 = only klingon ships.  This routine is used by MAKHIT and
C	GETHIT to determine who should receive a particular hit
C	message.  If ZERO = 0, then DBITS is initially set to 0.
	subroutine PRIDIS (iV, iH, ilim, iflag, zero)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	li = 1  ;  lj = KNPLAY
	if (iflag .eq. 1)  lj = KNPLAY / 2
	if (iflag .eq. 2)  li = (KNPLAY / 2) + 1
	if (zero .eq. 0)  dbits = 0
	do 100 i = li, lj
	  if (alive(i) .gt. 0)  goto 100	!alive?
	  if (ldis(iV,iH,shpcon(i,KVPOS),shpcon(i,KHPOS),ilim)) 
     +	  dbits = dbits .or. bits(i)		!add to DBITS if in range
 100	continue
	return
	end
C	This routine prints out a sector location (v,h) in the form
C	v-h.  A carriage return suffixes this print line if prcflg
C	is non-zero.  w should be either 2 or 0 (free format).  Prlflg
C	determines whether to output relative, absolute, or both
C	coordinates (usually OCFLG, but sometimes KABS).  Proflg
C	determines whether to output in the short, medium, or long
C	format (usually oflg, but sometimes SHORT).
	subroutine PRLOC (v, h, prcflg, w, prlflg, proflg)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	if (prlflg .eq. KREL)  goto 100
	if (proflg .ne. SHORT)  call outc('@')
	call odec (v,w)
	call outc ('-')
	call odec (h,w)
 100	if ((pdist(v, h, shpcon(who,KVPOS), shpcon(who,KHPOS)) .eq. 0) 
     +	.and. (w .eq. 0))  goto 200
	if (prlflg .eq. KBOTH)  call space
	if (prlflg .eq. KABS)  goto 200
	tw = w  ;  if (w .ne. 0)  tw = w + 1
	call osdec (v-shpcon(who,KVPOS), tw)
	call outc (',')
	call osdec (h-shpcon(who,KHPOS), tw)
 200	if (prcflg .ne. 0)  call crlf
	return
	end
C	This routine outputs either the 'normal' (Command: ) command
C	prompt, or an 'informative' command prompt.  The 'informative'
C	command prompt consists of a '> ', preceded by any and/or all
C	of the following:	D : Ship damages > 2000 units,
C				E : Ship energy < 1000 units,
C				S : Shields down or < 10%,
C			       nL : Ship life support damaged, reserves
C				    of n stardates.
	subroutine PROMPT
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	if (prtype)  go to 100	!normal or informative prompt?
	call out (comlin,0)	!normal prompt...
	return
*.......Analyse and output pertinent ship conditions.
 100	if (shpdam(who,KDLIFE) .ge. KCRIT) 
     +	call odec (shpcon(who,KLFSUP), 0)
	if (shpdam(who,KDLIFE) .ge. KCRIT)  call outc ('L')
	if ((shpcon(who,KSSHPC) .le. 100) .or. (shpcon(who,KSHCON) 
     +	.lt. 0))  call outc ('S')
	if (shpcon(who,KSDAM) .ge. 20000)  call outc ('D')	!ship damages > 2000?
	if (shpcon(who,KSNRGY) .le. 10000)  call outc ('E')	!yellow alert?
	call out2c ('> ')	!finish prompt...
	return
	end
C	This routine enables the user to stop (or restore) the ability
C	to receive messages from other ships using the sub-space radio.
C	Messages from individual ships may also be gagged.
	subroutine RADIO
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
*.......Get commmand (on, off, gag, or ungag)
	call crlf
	index = 2
	if (typlst(2) .eq. KALF)  goto 200
 100	index = 1
	call out (radio0, 0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	call crlf
 200	if (equal (tknlst(index), 'ON'))   goto 1000
	if (equal (tknlst(index), 'OFF'))  goto 900
	if (.not. (equal(tknlst(index), 'GAG') .or. 
     +	equal(tknlst(index), 'UNGAG')))  goto 100
	gagtyp = 0
	if (equal (tknlst(index), 'UNGAG'))  gagtyp = 1
*.......Gag and Ungag against messages from individual ships
 300	if (typlst(index+1) .eq. KALF)  goto 400!get desired ship name
	call out (radio2,0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	index = 0
	goto 300
 400	do 500 i = 1, KNPLAY			!match input with ship names
	  if (equal (tknlst(index+1), names(i,1)))  goto 600
 500	continue
	call out (unkshp,1)			!unknown ship name
	return
 600	if (i .eq. who)  return			!entered own ship name?
	if (gagtyp .ne. 0)  goto 700		!GAG or UNGAG command?
	gagmsg = gagmsg .or. bits(i)		!GAG command
	call out (radgag, 0)
	goto 800
 700	gagmsg = gagmsg .and. -(bits(i)+1)	!UNGAG command
	call out (radung, 0)
 800	iteam = 1  ;  if (i .gt. KNPLAY/2)  iteam = 2
	call odisp ((iteam * 100) + i, 0)
	call crlf
	return
*.......Turn off radio
 900	nomsg = nomsg .or. bits(who)
	call out (radoff, 1)
	return
*.......Turn on radio
1000	nomsg = nomsg .and. -(bits(who)+1)
	call out (radon0, 1)
	return
	end
C	This routine repairs damaged ship devices.  It is called
C	after every time-consuming move to check for and repair any
C	such damage.  If docked, or if the REPAIR command is used,
C	this normal repair process is accelerated.  A user may
C	specify the exact amount of repairs desired, and the pause
C	time will be computed accordingly.  Also, the ALL switch will
C	determine the repair time needed to fix all the damaged
C	devices and will perform those repairs.  A call to DAMAGE
C	may be appended to such a REPAIR command.
	subroutine REPAIR (il,*)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	v = 0   ;   l = il
	if (docked(who) .and. (l .ne. 3))  l = 2
	if (l .eq. 1)  repsiz =  500   !DOCKed or REPAIR while underway
	if (l .eq. 2)  repsiz = 1000   !REPAIR while docked
	if (l .eq. 3)  repsiz =  300   !normal end-of-turn repair
	ntoken = 2
	if (l .eq. 3) goto 100
	if (typlst(2) .ne. KINT)  goto 100
	repsiz = vallst(2) * 10  ;  ntoken = 3
 100	maxd = 0
	do 200 i = 1, KNDEV
	  maxd = max0 (maxd, shpdam(who,i))
 200	continue
	if (maxd .eq. 0)  goto 600
	repsiz = min0 (repsiz, maxd)
	if (.not. (equal (tknlst(2), 'ALL')))  goto 300
	repsiz = maxd  ;  ntoken = 3
 300	if (l .eq. 3)  go to 400
	v = etim(tim0) + (repsiz * 8) / l
 400	do 500 i = 1, KNDEV
	  shpdam(who,i) = max0((shpdam(who,i) - repsiz), 0)
 500	continue
 600	if (l .eq. 3)  return
	if (equal (tknlst(ntoken), 'DAMAGE'))  call damage (ntoken+1)	!does he want a damage report?
	ptime = v - etim(tim0)
	if (ptime .le. 0)  return 1	!not a time-consuming repair
	return
	end
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
C	This routine is used by the Romulan to see if there is a star
C	adjacent to his target.  If so, the star becomes the new target.
	subroutine ROMSTR (iV, iH)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	iVf = max0(iV - 1, 1)  ;  iVl = min0(iV + 1, KGALV)
	iHf = max0(iH - 1, 1)  ;  iHl = min0(iH + 1, KGALH)
	do 100 i = iVf, iVl
	do 100 j = iHf, iHl
	  if (dispc (i,j) .ne. DXSTAR)  goto 100	!star?
	  iV = i  ;  iH = j  ;  return			!Yes!  retarget, return
 100	continue
	return
	end
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
C	SCAN/SRCAN -- Display the contents of nearby space.
C	SCAN range defaults to 10 sectors in each direction.
C	SRSCAN range defaults to 7 sectors in each direction.
C	The format is:
C	SCAN		square scan, default distance in each direction
C	SCAN d		square scan, d sectors each direction
C	SCAN dV dH	rectangular scan, dV up/down, dH right/left
C	SCAN UP		scan up/right/left default distance
C	SCAN UP d	scan up/right/left d sectors
C	SCAN UP dV dH	scan up dV sectors, right/left dH sectors
C	SCAN DOWN/RIGHT/LEFT	same format as SCAN UP
C	SCAN CORNER dV dH
	subroutine SCAN
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /local/ screen(200)
	dimension dist(4)		!distance to scan in each direction
*.......SCAN entry point -- default to maximum scanning distance
		dist(1) = krange ; dist(2) = krange
		dist(3) = krange  ;  dist(4) = krange
	goto 100
*.......SRSCAN entry point -- use a smaller default scanning distance
	entry SRSCAN
	dist(1) = 7       ;  dist(2) = 7
	dist(3) = 7       ;  dist(4) = 7
*.......Check for warning switch
  100	warn = .FALSE.
	k = (terwid - 9)/4		! calc. max width for user
	if (dist(1) .le. k) goto 101
		dist(1) = k; dist(2) = k; dist(3) = k; dist(4) = k
101	if (ntok .eq. 1)  goto 500
	if (.not. equal (tknlst(ntok), 'WARNING'))  goto 200
	warn = .TRUE.
	typlst(ntok) = KEOL  ;  ntok = ntok - 1
*.......Check for direction modifier
 200	mod = 0  ;  n = 0  ;  p = 2
	if (equal (tknlst(2), 'UP'))  mod = 2
	if (equal (tknlst(2), 'DOWN'))  mod = 1
	if (equal (tknlst(2), 'RIGHT'))  mod = 4
	if (equal (tknlst(2), 'LEFT'))  mod = 3
	if (equal (tknlst(2), 'CORNER'))  mod = 5
	if (mod .ne. 0)  p = 3
	if (typlst(p) .eq. KEOL)  goto 300	!no range given; use default
	if (typlst(p) .ne. KINT)  goto 1000	!expecting range; syntax error
*.......Get first number
	d = vallst(p)  ;  n = n + 1  ;  p = p + 1
	dist(1) = d  ;  dist(2) = d
	dist(3) = d  ;  dist(4) = d
	if (typlst(p) .eq. KEOL)  goto 300	!no second #; give square scan
	if (typlst(p) .ne. KINT)  goto 1000	!wasn't number; syntax error
*.......Get second number
	d = vallst(p)  ;  n = n + 1  ;  p = p + 1
	dist(3) = d  ;  dist(4) = d
	if (typlst(p) .ne. KEOL)  goto 1000	!not last item; error
*.......Trim scan direction for up/down/right/left
 300	if (mod .eq. 5)  goto 400		!corner
	if (mod .ne. 0)  dist(mod) = 0		!up, down, right, or left
	goto 500
*.......Trim scan direction for corner scan
 400	if (n .ne. 2)  goto 1000		!2 #s not given; error
	if (dist(1) .gt. 0)  dist(2) = 0
	if (dist(1) .lt. 0)  dist(2) = -dist(1)
	if (dist(3) .gt. 0)  dist(4) = 0
	if (dist(3) .lt. 0)  dist(4) = -dist(3)
*.......Compute scan bounds
 500	do 600 i = 1, 4
	  if (dist(i) .lt. 0)  dist(i) = 0
	  if (dist(i) .gt. KRANGE)  dist(i) = KRANGE
 600	continue
	Hpos = shpcon(who,KHPOS)
	Vpos = shpcon(who,KVPOS)
	Vmax = min0 (Vpos+dist(1), KGALV)
	Vmin = max0 (Vpos-dist(2), 1)
	Hmax = min0 (Hpos+dist(3), KGALH)
	Hmin = max0 (Hpos-dist(4), 1)
	call setscn (Hmin, Hmax, Vmin, Vmax)	!set up initial scan display
	enemy = 3 - team
*.......Look for planets in scan range
	if (nplnet .le. 0)  goto 800		!no planets
	do 700 i = 1, nplnet
	  if (.not. ldis (locpln(i,KVPOS), locpln(i,KHPOS), Vpos, Hpos, 
     +	  KRANGE))  goto 700
	  locpln(i,4) = locpln(i,4) .or. team	!our side has seen this planet
	  if (dispc(locpln(i,KVPOS),locpln(i,KHPOS))-DXNPLN .ne. enemy) 
     +    goto 700				!not an enemy planet
	  if (warn)  call mark (locpln(i,KVPOS), locpln(i,KHPOS), 2)
 700	continue
*.......Look for enemy bases in scan range
 800	do 900 i = 1, KNBASE
	  if (base(i,3,enemy) .le. 0)  goto 900	!not a live base
	  if (.not. ldis (base(i,KVPOS,enemy), base(i,KHPOS,enemy), 
     +	  Vpos, Hpos, KRANGE))
     +	  goto 900
	  base(i,4,enemy) = base(i,4,enemy) .or. team
	  if (warn) call mark (base(i,KVPOS,enemy),base(i,KHPOS,enemy),4)
 900	continue
*.......Finally output the scan
	call shwscn				!display scan
	return
1000	call out (syntax,1)
	return
	end
C	This routine permits players to set/reset their NAME, OUTPUT
C	message length, TTYTYPE, command PROMPT type, SCAN lengths,
C	and default input and output location flags (ICDEF, OCDEF).
C	System players are also able to end the current game, turn
C	on the Romulan, and remove black holes from the board.
	subroutine SET
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	p = 2
 100	if (typlst(p) .ne. KALF)  goto 200	!no switch yet given?
	if (equal (tknlst(p), 'NAME'))     goto 300
	if (equal (tknlst(p), 'OUTPUT'))   goto 500
	if (equal (tknlst(p), 'TTYTYPE'))  goto 700
	if (equal (tknlst(p), 'PROMPT'))   goto 1200
	if (equal (tknlst(p), 'SCANS'))    goto 1400
	if (equal (tknlst(p), 'ICDEF'))    goto 1600
	if (equal (tknlst(p), 'OCDEF'))    goto 1800
	if (.not. PASFLG)  goto 200
	if (equal (tknlst(p), 'ROMOPT'))   goto 1900
	if (equal (tknlst(p), 'ENDFLG'))   goto 2000
	if (equal (tknlst(p), 'BHREMV'))   goto 2100
 200	call out (set001, 0)			!get the switch
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	p = 1  ;  goto 100
*.......SET NAME switch
 300	if (usrnam(p))  return
	call out (set002,0)
	call gtkn
	call usrnam (0)
	return
*.......SET OUTPUT switch
 400	call out (set003, 0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	p = 0
 500	if (typlst(p+1) .ne. KALF)  goto 400
	if (equal (tknlst(p+1), shtfrm))  oflg = short
	if (equal (tknlst(p+1), medfrm))  oflg = medium
	if (equal (tknlst(p+1), lngfrm))  oflg = long
	return
*.......SET TTYTYPE switch
 600	call crlf
	call out (set008,0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	p = 0
 700	if (typlst(p+1) .ne. KALF)  goto 600
	ttytyp = 0
	do 800 i = 1, KNTTY
	  if (.not. (equal(tknlst(p+1), ttydat(1,i))))  goto 800
	  if (ttytyp .ne. 0)  goto 900
	  ttytyp = i
 800	continue
	if (ttytyp .ne. 0)  return
	call crlf
	goto 1000
 900	call out (set009,0)
1000	call out (set010,2)
	call out (ttys00,1)
	goto 600
*.......SET PROMPT switch
1100	call out (set004, 0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	p = 0
1200	if (typlst(p+1) .ne. KALF)  goto 1100
	if (equal (tknlst(p+1), normal))  prtype = 0
	if (equal (tknlst(p+1), inform))  prtype = -1
	return
*.......SET SCAN switch
1300	call out (set005,0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	p = 0
1400	if (typlst(p+1) .ne. KALF)  goto 1300
	if (equal (tknlst(p+1), shtfrm))  SCNFLG = SHORT
	if (equal (tknlst(p+1), lngfrm))  SCNFLG = LONG
	return
*.......SET ICDEF switch
1500	call out (set006,0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	p = 0
1600	if (typlst(p+1) .ne. KALF)  goto 1500
	if (equal (tknlst(p+1), absfrm))  icflg = KABS
	if (equal (tknlst(p+1), relfrm))  icflg = KREL
	return
*.......SET OCDEF switch
1700	call out (set007,0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	p = 0
1800	if (typlst(p+1) .ne. KALF)  goto 1700
	if (equal (tknlst(p+1), absfrm))  ocflg = KABS
	if (equal (tknlst(p+1), relfrm))  ocflg = KREL
	if (equal (tknlst(p+1), bthfrm))  ocflg = KBOTH
	return
*.......Set ROMOPT flag to true
1900	ROMOPT = .TRUE.
	return
*.......Remove HIGH segment flag
2000	ENDFLG = .TRUE.
	call endgam
	return
*.......Remove Black Holes from board.
2100	do 2200 i = 1, KGALV
	do 2200 j = 1, KGALH
	  if (dispc (i,j) .eq. DXBHOL)  call setdsp (i, j, 0)
2200	continue
	return
	end
C	This routine is used to raise or lower a ship's deflector
C	shields, as well as transfer energy between the ship and shield
C	energy reserves.  The switches recognized are: UP, DOWN, and
C	TRANSFER.
	subroutine SHIELD
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	call crlf
	if (typlst(2) .ne. KALF)  goto 100	!no switch yet given?
	if (equal (tknlst(2), 'TRANSFER'))  goto 500
	if (equal (tknlst(2), 'UP'))  goto 800
	if (equal (tknlst(2), 'DOWN'))  goto 1000
 100	call out (shld01,0)			!get the switch
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	if (equal (tknlst(1), 'UP'))  goto 800
	if (equal (tknlst(1), 'DOWN'))  goto 1000
	if (equal (tknlst(1), 'TRANSFER'))  goto 200
	goto 100
*.......Transfer energy between shields and ship (engines)
 200	if (typlst(2) .eq. KINT)  goto 400	!amount of energy to transfer already given?
 300	call out (shld02,0)
	call gtkn
	if (typlst(1) .ne. KINT)  return
	senrgy = vallst(1) * 10
	goto 600
 400	senrgy = vallst(2) * 10
	goto 600
 500	if (typlst(3) .ne. KINT)  goto 300
	senrgy = vallst(3) * 10
*	Is the specified energy transfer reasonable?
 600	senrgy = min0 (senrgy, (1000 - shpcon(who,KSSHPC)) * 25)
	if (senrgy .lt. shpcon(who,KSNRGY))  goto 700
	call out (shld03,0)
	call gtkn
	if (equal (tknlst(1), 'YES'))  goto 700
	call out (shld04,1)
	return
*	Make energy transfer
 700	if ((-1 * senrgy) .gt. (shpcon(who,KSSHPC) * 25)) 
     +	senrgy = -25 * shpcon(who,KSSHPC)
	if ((shpcon(who,KSNRGY) - senrgy) .gt. 50000) 
     +	senrgy = -(50000-shpcon(who,KSNRGY))
	shpcon(who,KSSHPC) = shpcon(who,KSSHPC) + (senrgy / 25)
	shpcon(who,KSNRGY) = shpcon(who,KSNRGY) - senrgy
	call out (shld05,1)
	if (shpcon(who,KSSHPC) .le. 0)  shpcon(who,KSHCON) = -1
	if (shpcon(who,KSNRGY) .lt. 10000)  shpcon(who,KSPCON) = YELLOW
	if (shpcon(who,KSNRGY) .ge. 10000)  shpcon(who,KSPCON) = GREEN
	return
*.......Raise deflector shields if not critically damaged
*.......(Costs 100 units of ship energy)
 800	if (shpdam(who,KDSHLD) .gt. KCRIT)  goto 1100
	shpcon(who,KSHCON) = 1
	shpcon(who,KSNRGY) = max0 (shpcon(who,KSNRGY) - 1000 , 0 )
	call out (shld06,1)
	if (trstat(who) .ne. 0)  call trcoff (who)	!cut tractor beam?
	if (shpcon(who,KSNRGY) .gt. 0)  goto 900
	call out (shld07,1)
 900	return
*.......Lower deflector shields
1000	shpcon(who,KSHCON) = -1
	call out (shld08,1)
	return
1100	call out (shld09,1)
	return
	end
C	SNOVA -- This routine is called whenever a star is destroyed by
C	a torp.  It checks all objects around the destroyed star, and maims
C	and destroys as necessary.
	subroutine SNOVA
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /chkout/ V1, H1, iVc, iHc, dcode, idisV, idisH
	common /snlocl/ objstk(8,4), strstk(80,2)
	real idisV, idisH
	call setdsp (iVc, iHc, 0)		!get rid of star
	objptr = 0  ;  strptr = 0		!initialize stack pointers
 100	do 400 V = max0 (1,iVc-1), min0(KGALV,iVc+1)
	  do 300 H = max0 (1,iHc-1), min0(KGALH,iHc+1)
	    object = dispc (V,H)
	    if ((object .lt. 1) .or. (object .gt. DXEPLN))  goto 200
	    objptr = objptr + 1
	    objstk(objptr,1) = V  ;  objstk(objptr,2) = H
	    objstk(objptr,3) = V - iVc  ;  objstk(objptr,4) = H - iHc
	    goto 300
 200	    if ((object .ne. DXSTAR) .or. (iran(5) .eq. 5))  goto 300
	    if (strptr .eq. 29)  goto 300	!no more room, so don't blow up star
	    strptr = strptr + 1
	    strstk(strptr,1) = V  ;  strstk(strptr,2) = H
	    call setdsp (V, H, 0)
 300	  continue
 400	continue
 500	if (objptr .eq. 0)  goto 600		!awwww!  no more victims!
	V1    = objstk(objptr,1)  ;  H1    = objstk(objptr,2)
	idisV = objstk(objptr,3)  ;  idisH = objstk(objptr,4)
	objptr = objptr - 1
	thing = disp (V1, H1)
	if ((thing .le. 0) .or. (thing .ge. 100*DXSTAR))  goto 500
	call nova (thing/100, mod(thing,100))	!damage object
	goto 500
 600	if (strptr .eq. 0)  goto 700		!no stars to destroy
	iVc = strstk(strptr,1)  ;  iHc = strstk(strptr,2)
	strptr = strptr - 1
	dispfr = DXSTAR * 100  ;  iwhat = 7
	Vfrom = iVc  ;  Hfrom = iHc
	call pridis (Vfrom, Hfrom, KRANGE, 0, 0)
	call makhit
	if (PLAYER)  tpoint(KNSDES) = tpoint(KNSDES) - 500
	if (.not. PLAYER)  rsr(KNSDES) = rsr(KNSDES) - 500
	goto 100
 700	return
	end
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
C	This routine is used to send messages between ships using the
C	sub-space radio.
	subroutine TELL
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	dimension local (17)
	sntrom = .false.			! .true. if "tel rom; xxx"
	if (.not. player) goto 1150		! is the Romulan speaking?
	rmspk = .false.				! no.
*.......Radio operational?
	if (shpdam(who,KDRAD) .lt. KCRIT)  goto 200
	call out (tell01,1)
	return
*.......Destination ship or group already specified?
 200	nomsg = nomsg .and. (.not. bits(who))	!turn radio on
	p = 2
	if (ntok .gt. 1)  goto 300
*.......Get destination ship or group name
	call out (tell02,0)
	call gtkn
	p = 1
	if (typlst(1) .eq. KEOL)  return
*.......Analyze input string
 300	dbits = 0
	do 1100 i = p, ntok
	  if (equal (tknlst (i), 'ROMULAN')) goto 950
*.......Trying to send junk messages using ALTMODE?
		if (.not. RPTFLG)  goto 100
		call out (tell09,1)
		return
100	  do 400 j = 1, KNPLAY			!valid ship name?
	    if (equal (tknlst(i), names(j,1)))  goto 1000
 400	  continue
	  gm = .false.
	  do 500 j = 1, KNGRP			!valid group name?
	    if (group(j,1) .eq. 0)  goto 500
	    if (.not. equal(tknlst(i), group(j,1)))  goto 500
	    if (gm) goto 800
	    gm = .true.  ;  gbits = group(j,2)
 500	  continue
	  if (.not. gm)  goto 700		!unrecognized ship or group name?
	  do 600 j = 1, KNPLAY			!player in game?
	    if (.not. alive(j))  gbits = gbits .and. -(bits(j) + 1)
 600	  continue
	  dbits = dbits .or. gbits		!save valid ships
	  goto 1100
 700	  call out (tell03,0)			!unrecognized player or name
	  goto 900
 800	  call out (tell04,0)			!ambiguous group name
 900	  call outw (tknlst(i))  ;  call crlf
	  goto 1100
950	  if (.not. rom) goto 955		! is the Romulan dead?
	  svdb = dbits				! preserve destination bits
	  call romspk (local)			! speak to the player
	  call makmsg (local)
	  sntrom = .true.
	  dbits = svdb
	  if (iran (4) .gt. 1) goto 1100	! 25% chance Romulan comes to him
		ph = shpcon (who, khpos)	! find vacant spot neareby
		pv = shpcon (who, kvpos)
		ix = iran(10) - 5
		do 951 ir = ix, 10
		  do 951 jr = ix, 10
			if (.not. ingal (pv+jr, ph+ir)) goto 951
			if (disp (pv+jr, ph+ir) .ne. 0) goto 951
			call setdsp (locr(kvpos), locr(khpos), 0)
			locr(khpos) = ph+ir
			locr(kvpos) = pv+jr
			call setdsp (locr(kvpos), locr(khpos), dxrom*100)
			goto 1100
951		continue
		goto 1100			! no empty space????
955		call out (tell07, 0)		! "can't raise the "
		call out ('Romulan', 1)
		goto 1100
1000	  dbits = dbits .or. bits(j)		!add player to message list
	  if (j .eq. who)  call out (tell05,1)	!self excluded!!
1100	continue
	goto 1190
1150	rmspk = .true.			! the Romulan speaks!
	call romspk(local)		! set up target population & msg
*.......Search message list for problems ....
1190	mask = 1
	do 1500 i = 1, KNPLAY
	  iship = DXFSHP * 100 + i
	  if ((dbits .and. mask) .eq. 0)  goto 1400	!player on message list?
	  if (shpdam(i,KDRAD) .ge. KCRIT)  goto 1300	!player's radio broken?
	  if (alive(i))  goto 1200
	  if (rmspk) goto 1191
		call out (tell06, 0)
		call odisp (iship, 0)
		call crlf
1191	  dbits = dbits .and. (.not. mask)
	  goto 1400
1200	  if ((nomsg .and. mask) .eq. 0)  goto 1400	!radio off?
1300	  if (rmspk) goto 1301
		call out (tell07, 0)
		call odisp (iship,0)  ;  call crlf
1301	  dbits = dbits .and. (.not. mask)
1400	  mask = mask * 2				!update mask
1500	continue
	if (player) 
     +	dbits = dbits .and. (.not. bits(who))		!remove self
	gagmsg = gagmsg .and. (.not. dbits)		!update individual gag
	if (dbits .ne. 0)  goto 1600			!anyone to send to?
	if (.not. rmspk .and. .not. sntrom) call out (tell08, 1)
	return
*.......Send message to designated players
1600	if (rmspk) goto 1650
	dispfr = who + (team * 100)
	call makmsg
	call crlf
	return
1650	call makmsg (local)		! store the Romulan's message
	return
	end
C	This routine prints out useful information concerning the
C	elapsed time and run time of the game, job, and ship involved.
	subroutine TIME
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	call out (time01,0)		!total elapsed time of game
	call otim (etim(tim0))
	if (who .eq. 0)  goto 100	!in Pre-game section?
	call out (time02,0)		!elapsed time of ship
	call otim (etim(job(who,KJOBTM)))
	call out (time03,0)		!run time for this ship
	call otim (runtim(d) - job(who,KRUNTM))
 100	call out (time04,0)		!total run time for this job
	call otim (runtim(d))
	call out (time05,0)		!present time of day
	call otim (daytim(d))
	call crlf
	return
	end
C	This routine, along with it's entry point PHADAM, determines
C	the amount of damage inflicted on ships and bases by torpedo
C	and phaser hits.  It also updates the scoring information, and
C	sets up many of the variables eventually needed by MAKHIT.
	subroutine TORDAM (nplc, j, id, phit, ship)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	real rand, rana, hit, ranb, hita
*.......Has the target already been destroyed?
	if ((nplc .lt. DXFBAS) .and. ((shpcon(j,KSDAM) .ge. KENDAM) 
     +	.or. (shpcon(j,KSNRGY) .le. 0)))  return
	if ((nplc .ge. DXFBAS) .and. (base(j,3,nplc-2) .le. 0))  return
	iwhat = 2
	rand = ran(0)
	rana = ran(0)
	hit  = 0.0
	hita = 0.0
	ranb = rand - 0.5
*.......Determine size of hit and amount absorbed by shields (if up)
*.......Reduce shield energy due to attack
	hit = 4000.0 + 4000.0 * ran(0)
	if (nplc .ge. DXFBAS)  goto 1100
	if (shpcon(j,KSHCON) .gt. 0)  1000, 300
 100	if (nplc .ge. DXFBAS)  goto 200
	hita = hit * (1000.0 - shpcon(j,KSSHPC)) * 0.001
	shpcon(j,KSSHPC) = shpcon(j,KSSHPC) - 
     +	(hit * amax1 (float(shpcon(j,KSSHPC)) * 0.001, 0.1)
     +  + 10) * 0.03
	if (shpcon(j, ksshpc) .lt. 0) shpcon(j, ksshpc) = 0
	goto 300
 200	hita = hit * (1000 - base(j,3,nplc-2)) * 0.001
	base(j,3,nplc-2) = base(j,3,nplc-2) - 
     +  (hit * amax1(float(base(j,3,nplc-2)) * 0.001, 0.1) + 10) * 0.03
	goto 400
 300	if (shpcon(j,KSHCON) .lt. 0)  hita = hit
*.......Determine if hit critical.
 400	ihita = hita
	if (((hita * (rana + 0.1)) .lt. 1700.0) .and. (nplc .lt. DXFBAS)) 
     +	goto 500
	if (((hita * (rana + 0.1)) .lt. 1700.0) .and. (nplc .ge. DXFBAS)) 
     +	goto 600
	if ((iran(5) .eq. 5) .and. (nplc .ge. DXFBAS))  goto 1400
	if (nplc .ge. DXFBAS)  goto 600
*.......Critically damage a random ship device
	hita = hita / 2.0
	critdv = int (KNDEV * ran(0) + 1.0)		!pick a device
	shpdam(j,critdv) = shpdam(j,critdv) + hita	!and damage it
	if (critdv .eq. KDSHLD)  shpcon(j,KSHCON) = -1	!shields down?
	critdm = hita
	hita = hita + (ran(0) - 0.5) * 1000.0
	ihita = hita
 500	shpcon(j,KSDAM) = shpcon(j,KSDAM) + hita
	shpcon(j,KSNRGY) = shpcon(j,KSNRGY) - hita
 600	if (nplc .ge. DXFBAS)  base(j,3,nplc-2) = 
     +	max0 (int(base(j,3,nplc-2) - hita * 0.01), 0)
 700	if ((nplc .lt. DXFBAS) .and. (shpcon(j,KSSHPC) .le. 0)) 
     +	shpcon(j,KSHCON) = -1
*.......Update scoring information
	if (SHIP .and. PLAYER .and. (5-team .eq. nplc)) 
     +	tpoint(KPBDAM) = tpoint(KPBDAM) + hita
	if (SHIP .and. (.not. PLAYER) .and. (nplc .ge. DXFBAS)) 
     +	rsr(KPBDAM) = rsr(KPBDAM) + hita
	if (PLAYER .and. SHIP .and. (3-team .eq. nplc)) 
     +	tpoint(KPEDAM) = tpoint(KPEDAM) + hita
	if (SHIP .and. (.not. PLAYER) .and. (nplc .lt. DXFBAS)) 
     +	rsr(KPEDAM) = rsr(KPEDAM) + hita
	if (nplc .ge. DXFBAS)  goto 1300	!base?
	shpcon(j,KSPCON) = RED
	shstto = shpcon(j,KSSHPC)  ;  shcnto = shpcon(j,KSHCON)
	if ((shpcon(j,KSDAM) .ge. KENDAM) .or. 
     +	(shpcon(j,KSNRGY) .le. 0))  klflg = 2
	if (klflg .ne. 0)  goto 750		!player destroyed?
	if (iwhat .eq. 1)  return		!phaser hit?
	call jump (nplc,j)			!displaced by torp?
	if (klflg .eq. 0)  return		!displaced into BH?
 750	call setdsp (shpcon(j,KVPOS), shpcon(j,KHPOS), 0)
	alive(j) = 0
	if (PLAYER .and. SHIP)  tpoint(KPEKIL) = tpoint(KPEKIL) + 5000
	if (SHIP .and. .not. PLAYER)  rsr(KPEKIL) = rsr(KPEKIL) + 5000
	return
	entry PHADAM (nplc, j, id, phit, ship)
*.......Determine size of phaser hit, and the amount absorbed by the
*.......shields (if up).  Decrease shield energy due to attack.
	iwhat = 1
	powfac = 80
	rana = ran(0)
	hit  = 0.0
	if ((nplc .lt. DXFBAS) .and. (shpcon(j,KSHCON) .gt. 0)) 
     +	powfac = powfac / 2
	if (nplc .ge. DXFBAS)  powfac = powfac / 2
	hit = pwr ((0.9 + 0.02 * ran(0)), id)
*.......If player firing, check if computer or phaser damaged.
*.......Modify size of hit if true.
	if (PLAYER .and. SHIP .and. ((shpdam(who,KDPHAS) .gt. 0) .or. 
     +	(shpdam(who,KDCOMP) .gt. 0)))  hit = hit * 0.8
	if (nplc .ge. DXFBAS)  goto 900
	if (shpcon(j,KSHCON) .lt. 0)  goto 800
	hita = hit
	hit = (1000 - shpcon(j,KSSHPC)) * hita * 0.001
	shpcon(j,KSSHPC) = shpcon(j,KSSHPC) - (hita * powfac * phit * 
     +	amax1 (float(shpcon(j,KSSHPC)) * 0.001, 0.1) + 10) * 0.03
	if (shpcon(j, ksshpc) .lt. 0) shpcon(j, ksshpc) = 0
 800	hita = hit * powfac * phit
	goto 400			!use damage and scoring code in common with TORDAM
 900	hita = hit
	hit = (1000 - base(j,3,nplc-2)) * hita * 0.001
	base(j,3,nplc-2) = base(j,3,nplc-2) - (hita * powfac * phit * 
     +	amax1 (float(base(j,3,nplc-2)) * 0.001, 0.1) + 10) * 0.03
	goto 800
*.......See if torpedo deflected by shields
1000	rand = rana - (shpcon(j,KSSHPC) * 0.001 * rand) + 0.1
1100	if (nplc .ge. DXFBAS)  rand = rana - (base(j,3,nplc-2) 
     +	* 0.001 * rand) + 0.1
	if (rand .gt. 0.0)  goto 100	!torpedo deflected?
	iwhat = 3  ;  ihita = 0
	if (nplc .ge. DXFBAS)  base(j,3,nplc-2) =
     +	amax1((float(base(j,3,nplc-2)) - 50.0 * rana), 0.0) 
	if (nplc .ge. DXFBAS)  goto 1200
	shpcon(j,KSSHPC) = amax1((float(shpcon(j,KSSHPC))-50.*rana),0.)
	if (shpcon(j, ksshpc) .lt. 0) shpcon(j, ksshpc) = 0
1200	hita = 0.0
	goto 700
*.......Critical hit on starbase (base destroyed if klflg .ne. 0)
1300	shstto = base(j,3,nplc-2)  ;  shcnto = 1
	if (base(j,3,nplc-2) .gt. 0)  return
1400	base(j,3,nplc-2) = base(j,3,nplc-2) - 50 - int(100.0 * ran(0))
	critdm = 1
	if ((iran(10) .eq. 10) .or. (base(j,3,nplc-2) .le. 0))  klflg = 2
	shstto = base(j,3,nplc-2)  ;  shcnto = 1
*.......Destroy starbase if shields gone
	if (klflg .eq. 0)  return
	call baskil (nplc-2)
	nbase(nplc-2) = nbase(nplc-2) - 1
	if (SHIP .and. .not. PLAYER)  rsr(KPBDAM) = rsr(KPBDAM) + 10000
	if (SHIP .and. PLAYER)  tpoint(KPBDAM) = tpoint(KPBDAM) + 10000
	call setdsp (base(j,KVPOS,nplc-2), base(j,KHPOS,nplc-2), 0)
	base(j,3,nplc-2) = 0
	return
	end
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
C	This routine allows a ship to tow another friendly ship.  The
C	deflector shields of both ships must be down.  Incoming torpedo
C	hits or nova damage breaks the tractor beam, as does raising
C	either ship's deflector shields.  The entry point TRCOFF is
C	used to break an active tractor beam.
	subroutine TRACTR (ip)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	call crlf
	index = 2
	if ((ntok .gt. 1) .or. (trstat(who) .eq. 0))  goto 100
	ip = who  ;  goto 1400
*.......Input desired ship to tractor beam
 100	if (typlst(index) .eq. KALF)  goto 200
	call out (tract1,0)
	call gtkn
	if (typlst(1) .eq. KEOL)  return
	index = 1
	goto 100
*.......Turn tractor beam off?
 200	if (.not. equal(tknlst(index), 'OFF'))  goto 300
	ip = who  ;  if (trstat(ip) .ne. 0)  goto 1400
	call out (tract2,1)
	return
*.......Tractor beam ALREADY active?
 300	if (trstat(who) .eq. 0)  goto 400
	call out (tract3,1)
	return
*.......Match input with ship name
 400	do 500 i = 1, KNPLAY
	  if (equal (tknlst(index), names(i,1)))  goto 600
 500	continue
	call out (unkshp,1)		!unknown ship name
	return
*.......Tractoring your own ship?
 600	if (i .ne. who)  goto 700
	call out (tract4,1)
	return
*.......Attempting to tractor an enemy ship?
 700	dteam = 1  ;  if (i .gt. (KNPLAY/2))  dteam = 2
	if (team .eq. dteam)  goto 800
	call out (tract5,1)
	return
*.......Ship in game?
 800	if (alive(i))  goto 900
	call out (noship,1)
	return
*.......Adjacent to destination ship?
 900	if (ldis(shpcon(who,KVPOS), shpcon(who,KHPOS), 
     +	shpcon(i,KVPOS), shpcon(i,KHPOS), 1))  goto 1000
	call out (energ3,1)
	return
*.......Destination ship already has active tractor beam?
1000	iship = (DXFSHP * 100) + i
	if (i .gt. KNPLAY/2)  iship = iship + 100
	if (trstat(i) .eq. 0)  goto 1100
	call odisp (iship,1)
	call out (tract6,1)
	return
*.......Trying to apply tractor beam with YOUR shields up?
1100	if (shpcon(who,KSHCON) .lt. 0)  goto 1200
	call out (tract7,1)
	return
*.......Trying to apply tractor beam with HIS shields up?
1200	if (shpcon(i,KSHCON) .lt. 0)  goto 1300
	call odisp (iship,1)
	call out (tract8,1)
	return
*.......Apply tractor beam, inform players
1300	trstat(who) = i  ;  trstat(i) = who
	dbits = bits(who) .or. bits(i)
	iwhat = 13
	call makhit
	return
*.......Entry point for removing tractor beam
	entry TRCOFF (ip)
1400	dbits = bits(ip) .or. bits(trstat(ip))
	iwhat = 14
	trstat(trstat(ip)) = 0  ;  trstat(ip) = 0	!remove beam
	call makhit					!inform players
	return
	end
C	When this routine is called because ^C is typed it removes
C	the player from the game before returning to monitor level,
C	thus preventing derelict ships.  All pertinent information
C	is saved so that the player can continue the game (unless
C	his ship has been taken over by someone else).
	subroutine TRAP
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	call CCTRAP
	call free (who)			!store ship info, remove from high seg
	who = 0
	call monit			!return to monitor
	call rstart (who)		!restore ship to high seg if possible
	return
	end
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
C	This routine prints out information about the currently active
C	captains.  The information includes their ship name and their
C	own name; plus their PPN, TTY number, and TTY speed.  If the
C	password is set, one also gets their present location.
	subroutine USERS
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'
	common /local/ line(90)
*.......Set up output table format
	call crlf
	if (oflg .ne. long)  goto 100
	call out (users1,0)
	if (PASFLG) call out (users2,0)
	call crlf
*.......Print out player information
 100	do 700 i = 1, KNPLAY
	  if (i .eq. (KNPLAY/2)+1)  call out (users5,1)
	  if (.not. alive(i))  goto 700
c--	  if (oflg)  200, 300, 400
c-- 200	  num = 2  ;  goto 500
c-- 300	  num = 4  ;  goto 500
 400	  num = 6
 500	  call stat (num, i+0)
	  if (.not. PASFLG) goto 600
	  call spaces (3)
	  call prloc(shpcon(i,KVPOS), shpcon(i,KHPOS), 0, 2, ocflg, SHORT)
 600	  call crlf
 700	continue
	return
	end
