C	Routine for adding cloaking device to DECWAR
C	Written BY Merlyn Cousins AKA Drforbin



C	routine for cloak state machine.


	subroutine clstup (icmd,iwho,icloak)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'


	integer icloak(knplay,4)

	goto (100,200,300,400,500,600),icmd	! really ugly switch
C	its best I can do with FORTRAN IV


100	if (.not. (iran(100) .le. 100)) goto 101	!clfind
	icloak(iwho,cltime) = daytim(d)
	icloak(iwho,clstat) = clinit
	icloak(iwho,clhave) = cloyes
	icloak(iwho,clfsta) = 0 
	call crlf
	call out ('While exploring the planet you have found some
     + strange technology.',1)
101	return


200	if(.not. ( etim(icloak(iwho,cltime))) .gt. 60000) goto 201!clinit
C	call out ('time equals:',0);call odec (icloak(iwho,cltime),0)
	icloak(iwho,cltime) = 0
	icloak(iwho,clstat) = cloff
	call crlf
	call out ('It seems you have discovered CLOAK technology.',1)
	call out ('The Science officer has taken the liberty of
     + installing it',1)
	call out ('to your shield control system.',1)
	call prompt
	call ttyon
201	return


300	return!cloff


400	if ((icloak(iwho,clhave) .eq. clno) .or. (icloak(iwho,clstat) .eq. 
     +  clinit)) goto 9999 !clfout 
	if (icloak(iwho,clstat) .eq. clon) goto 10000
	if (icloak(iwho,clstat) .eq. clfout) goto 401
	call out ('Engaging CLOAK',1)
	icloak(iwho,clstat) = clfout
	icloak(iwho,cltime) = daytim(d)
401	if (.not. (etim(icloak(iwho,cltime))) .gt. 5000) goto 402
	icloak(iwho,clfsta) = icloak(iwho,clfsta) + 1
	call crlf
	call out ('Fading out stage:',0)
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
	call out ('Cloak Fully ON',1)
	call prompt
402	return

500	if ((icloak(iwho,clhave) .eq. clno) .or. (icloak(iwho,clstat) .eq. 
     +  clinit)) goto 9999 !clfin
	if (icloak(iwho,clstat) .eq. cloff) goto 10001
	if (icloak(iwho,clstat) .eq. clfin) goto 501
	call out ('Disengaging CLOAK',1)
	icloak(iwho,clstat) = clfin
	icloak(iwho,cltime) = daytim(d)
501	if (.not. (etim(icloak(iwho,cltime))) .gt. 5000) goto 502
	icloak(iwho,clfsta) = icloak(iwho,clfsta) - 1
	call crlf
	call out ('Fading in stage:',0)
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
	call out ('Cloak Fully OFF',1)
	call prompt
502	return



600	shpcon(iwho,KSNRGY) = shpcon(iwho,KSNRGY) - 250 !clon

	return

C	ERROR returns

9999	call out ('You donot have Cloaking technology!',1)
	return

10000	call out ('The CLOAK is already ON',1)
	return

10001	call out ('The CLOAK is already OFF',1)
	return

	end

C	routine for range adjustment

	integer function cldist  (id,iwho,icloak)
	
	include 'param/nolist'

	integer icloak(knplay,4)


	if ( icloak(iwho,clstat) .eq. clon ) goto 100
	cldist = (id -1 ) + icloak(iwho,clfsta)
	return
100	cldist = 2 * ( id -1 ) + icloak(iwho,clfsta)
	return


	end

C	routine for sensor detection

	logical function clsee (id)

	isee = 100 -  (50 + ( min0( ( (id - 1) ** iran(6)), 80 ) - 40 ) ) 
	if( iran(100) .le. isee ) goto 100
	clsee = .false.
	return
100	clsee = .true.
	return

	end
