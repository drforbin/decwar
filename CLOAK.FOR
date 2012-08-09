




	subroutine FINDCL ()
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'


	if (cloak(who,clhave) .eq. cloyes) return
	if (.not. (iran(100) .le. 10) goto 100
	cloak(who,cltime) = daytim(d)
	cloak(who,clstat) = clinit
	cloak(who,clhave) = cloyes
	call out (findcl,1)
100	return
