C	Routine for adding cloaking device to DECWAR
C	Written BY Merlyn Cousins AKA Drforbin



C	routine for cloak state machine.
C	*********MAIN ROUTINE***********

	subroutine clstup (icmd,iwho,icloak)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'


	integer icloak(knplay,4)

	data itset/0/


	goto (100,200,300,400,500,600),icmd	! really ugly switch
C	its best I can do with FORTRAN IV


100	if (.not. (iran(100) .le. 100)) goto 101	!clfind
	icloak(iwho,cltime) = daytim(d)
	icloak(iwho,clstat) = clinit
	icloak(iwho,clhave) = cloyes
	icloak(iwho,clfsta) = 0 
	call crlf
	call out ('***While exploring the planet you have found some
     + strange technology.***',1)
	call out ('***Your Science officer will investigate.***',1)
	call crlf
101	return

C	clinit routine

200	if(.not. ( etim(icloak(iwho,cltime)) .gt. 60000)) goto 201!clinit
C	itime = iran (10)
C	if(.not. ( etim(icloak(iwho,cltime)) .gt. 
C     +	( 60000 * itime)) goto 201!clinit
C	call out ('time equals:',0);call odec (icloak(iwho,cltime),0)
	icloak(iwho,cltime) = 0
	icloak(iwho,clstat) = cloff
	call crlf
	call out ('*It seems you have discovered CLOAK technology.*',1)
	call out ('*The Science officer has taken the liberty of
     + installing it*',1)
	call out ('*to your shield control system.*',1)
	call prompt
	call ttyon
201	return



C	cloff routine

300	return!cloff



C	clfout routine

400	if ((icloak(iwho,clhave) .eq. clno) .or. (icloak(iwho,clstat) .eq. 
     +  clinit)) goto 9999 !clfout 
	if (icloak(iwho,clstat) .eq. clon) goto 10000
	if (shpcon(who,KSHCON) .eq. -1) goto 10002
	if (icloak(iwho,clstat) .eq. clfout) goto 401
	call out ('*Engaging CLOAK*',1)
	icloak(iwho,clstat) = clfout
	icloak(iwho,cltime) = daytim(d)
401	if (.not. (etim(icloak(iwho,cltime)) .gt. 5000)) goto 402
	icloak(iwho,clfsta) = icloak(iwho,clfsta) + 1
	shpcon(iwho,KSNRGY) = shpcon(iwho,KSNRGY) - 250
	call crlf
	call out ('*Fading out stage:',0)
	call odec (icloak(iwho,clfsta), 0)
	call crlf
	call prompt
	icloak(iwho,cltime) = daytim(d)
	if (.not. ((icloak(iwho,clfsta) .eq. 5))) goto 402 
	icloak(iwho,clstat) = clon
	clteam(iwho,cteam) = team
	clteam(iwho,cwho) = who
	call setdsp ( shpcon(iwho,KVPOS), shpcon(iwho,KHPOS), 0)
	call crlf
	call out ('*Cloak Fully ON*',1)
	call prompt
402	return


C	clfin routine

500	if ((icloak(iwho,clhave) .eq. clno) .or. (icloak(iwho,clstat) .eq. 
     +  clinit)) goto 9999 !clfin
	if (icloak(iwho,clstat) .eq. cloff) goto 10001
	if (shpcon(who,KSHCON) .eq. -1) goto 10002
	if (icloak(iwho,clstat) .eq. clfin) goto 501
	call out ('*Disengaging CLOAK*',1)
	icloak(iwho,clstat) = clfin
	icloak(iwho,cltime) = daytim(d)
501	if (.not. (etim(icloak(iwho,cltime)) .gt. 5000)) goto 502
	icloak(iwho,clfsta) = icloak(iwho,clfsta) - 1
	shpcon(iwho,KSNRGY) = shpcon(iwho,KSNRGY) - 250
	call crlf
	call out ('*Fading in stage:',0)
	call odec (icloak(iwho,clfsta), 0)
	call crlf
	call prompt
	icloak(iwho,cltime) = daytim(d)
	if (.not. ((icloak(iwho,clfsta) .eq. 0))) goto 502 
	icloak(iwho,clstat) = cloff
	call setdsp ( shpcon(iwho,KVPOS), shpcon(iwho,KHPOS),
     +  (100 * team) + who )
	icloak(iwho,clfsta) = 0
	clteam(iwho,cteam) = 0
	clteam(iwho,cwho) = 0
	call crlf
	call out ('*Cloak Fully OFF*',1)
	call prompt
502	return


C	clon routine


600	if (shpcon(who,KSHCON) .eq. -1) goto 10002
	if (itset .eq. 1) goto 601
	icloak(iwho,cltime) = daytim(d)!clon
	itset = 1
601	if (.not. (etim(icloak(iwho,cltime)) .gt. 5000)) goto 602
	shpcon(iwho,KSNRGY) = shpcon(iwho,KSNRGY) - 1000
	itset = 0
602	return


C	ERROR returns

9999	call out ('***You donot have Cloaking technology!***',1)
	return

10000	call out ('***The CLOAK is already ON***',1)
	return

10001	call out ('***The CLOAK is already OFF***',1)
	return

10002	call out ('***CLOAK knocked offline due to shields
     + dropping***',1)
	cloak(who,clstat) = cloff
	cloak(who,clfsta) = 0
	cloak(who,time)   = 0
	return


	end



C	routine for range adjustment



	integer function cldist  (id,iwho,icloak)
	include 'param/nolist'
	include 'hiseg/nolist'

	integer icloak(knplay,4)


	if ( icloak(iwho,clstat) .eq. clon ) goto 100
	cldist = (id -1 ) + icloak(iwho,clfsta)
	if (clteam(iwho,cspflg) .eq. 1) cldist = cldist - 1
	return
100	cldist = 2 * ( id -1 ) + icloak(iwho,clfsta)
	if (clteam(iwho,cspflg) .eq. 1) cldist = cldist - 1
	return


	end



C	routine for sensor detection

	logical function clsee (id)
	include 'param/nolist'
	include 'hiseg/nolist'

	isee = 100 -  (50 + ( min0( ( (id - 1) ** iran(7)), 80 ) - 40 ) ) 
	if (clteam(iwho,cspflg) .eq. 1) isee = isee - 5 
	if( iran(100) .le. isee ) goto 100
	clsee = .false.
	return
100	clsee = .true.
	return

	end
