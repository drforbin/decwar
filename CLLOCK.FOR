




	subroutine cllock 

	include 'hiseg/nolist'
	include 'param/nolist'
	include 'lowseg/nolist'


C	call lock

	call lock(board, 'boardlock')

C	call board normal

C	place routines for placing cloaked (removed) units back on board
C	for processing.

	do 100 iwho = 1,KNPLAY
	if ( .not. (( alive(iwho) ) .and. ( cloak(iwho,clstat)  
     +	.eq. clon )) ) goto 100 
	call setdsp ( shpcon(iwho,KVPOS), shpcon(iwho,KHPOS),
     +	(100 * team) + who ) 

100	continue
	return

	end
