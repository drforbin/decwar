
C	Added by Merlyn drforbin as lock routine for 
C	cloak DECWAR

C	cllock locks board array and returns board to
C	non-cloak state for processing



	subroutine cllock 

	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'


C	call board normal

C	place routines for placing cloaked (removed) units back on board
C	for processing.

	do 100 iwho = 1,KNPLAY
	if ( .not. (( alive(iwho) ) .and. ( cloak(iwho,clstat)  
     +	.eq. clon )) ) goto 100 
	call setdsp ( shpcon(iwho,KVPOS), shpcon(iwho,KHPOS),
     +	(100 * clteam(clteam(iwho,cwho),cteam) ) + clteam(iwho,cwho) ) 

100	continue
	return

	end
