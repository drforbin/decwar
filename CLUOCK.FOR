
C	added by merlyn drforbin for cloak device
C	cluock routine returns board to post processing state
C	cloak enabled state and unlocks board array



	subroutine cluock 

	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'


C	call cloak board 

C	re-remove cloaked units from board

	call lock (clolok)!lock for cloak structures

	do 100 iwho = 1,KNPLAY
	if ( .not. (( alive(iwho) ) .and. ( cloak(iwho,clstat)  
     +	.eq. clon )) ) goto 100 
	call setdsp ( shpcon(iwho,KVPOS), shpcon(iwho,KHPOS), 0 ) 
100	continue

	call unlock (clolok)!unlock for cloak structures
	return

	end
