C	Routine for adding cloaking device to DECWAR
C	Written BY Merlyn Cousins AKA Drforbin


C	very short and sweet routine to activate rom and
C	defenses

	subroutine caldef
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	call cllock

	if (ROMOPT) call romdrv(d1,d2)            !activate Romulan?
	call baspha                               !activate enemy starbase defense
	call plnatk                               !activate neutral and enemy planets
	call basbld                               !partially rebuild enemy bases

	call cluock 

C call cloak state machine

	if (cloak(who,clhave) .eq. cloyes) call clstup (
     +cloak(who,clstat), who, cloak)

	end
