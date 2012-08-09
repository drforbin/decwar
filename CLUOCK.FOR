




	subroutine cluock 

	include 'hiseg/nolist'
	include 'param/nolist'
	include 'lowseg/nolist'


C	call cloak board 

C	re-remove cloaked units from board

	do 100 iwho = 1,KNPLAY
	if ( .not. (( alive(iwho) ) .and. ( cloak(iwho,clstat)  
     +	.eq. clon )) ) goto 100 
	call setdsp ( shpcon(iwho,KVPOS), shpcon(iwho,KHPOS), 0 ) 
100	continue

C	call unlock

	call unlock(board)

	return

	end
