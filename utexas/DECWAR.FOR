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
C	call royaln('CSIS86') drforbin(merlyn)
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
C	if (lofchk(0)) goto 3800 drforbin (merlyn)	! also if his time is up
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
/
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

C	call onexit ;drforbin added
	end
