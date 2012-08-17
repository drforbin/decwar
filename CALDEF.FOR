C	Routine for adding cloaking device to DECWAR
C	Written BY Merlyn Cousins AKA Drforbin


C	very short and sweet routine to activate rom and
C	defenses

	subroutine caldef
	include 'param/nolist'
	include 'hiseg/nolist'


	call cllock
	call baspha                               !activate enemy starbase defense
	if (ROMOPT) call romdrv(d1,d2)            !activate Romulan?
	call plnatk                               !activate neutral and enemy planets
	call basbld                               !partially rebuild enemy bases
	call cluock


	end
