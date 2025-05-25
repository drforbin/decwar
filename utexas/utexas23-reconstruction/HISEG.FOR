	common /hiseg/ 
     +	hfz, shpcon, shpdam, base, nbase, board, locpln, locr, 
     +	erom, eromo, rsr, nplnet, rom, romcnt, rtpaus, rppaus, 
     +	job, msgflg, hitflg, numcap, romopt, blhopt, endflg, nomsg, 
     +	tmscor, tim0, slwest, kilque, nkill, kilndx, tmturn, numshp, 
     +	numrom, trstat, active, alive, comknt, hitime, dead, docked, 
     +	hlz, plnlok, frelok, quelok, device, isaydo, xhelp, ttydat, 
     +	names, bits, sbits, cmdbts, numply, numsid, versio, gameno,
     +  dotime, score

c Note: the following MUST be last entry in hiseg impure area
	common /hiseg/ hilst

	!High core zeroed out by first player

	integer	hfz			!first location to zero out
	integer	shpcon(KNPLAY,10)	!ship information
	integer	shpdam(KNPLAY,KNDEV)	!damage to ship devices
	integer	base(KNBASE,4,2)	!base information
	integer	nbase(2)		!number of federation and klingon bases
	integer board(brdsiz)		!board
	integer	locpln(KNPLNT,4)	!planet info
	integer	locr(2)			!romulan position
	integer	erom			!romulan energy
	integer eromo			!initial rom energy
	integer	rsr(8)			!romulan scoring info
	integer	nplnet			!number of existing planets
	logical	rom			!true if Romulan exists
	integer	romcnt			!Romulan move counter
	integer rtpaus			!Romulan torpedo tube pause time
	integer rppaus			!Romulan phaser pause time
	integer	job(KNPLAY,KNJBST)	!various job status information
	integer	msgflg(KNPLAY)		!flag for message routine
	integer	hitflg(KNPLAY)		!flag for MAKHIT, GETHIT
	integer	numcap(2)		!number of fed and emp planets
	integer	romopt			!romulan option flag
	integer	blhopt			!black hole option flag
	integer	endflg			!universe is destroyed flag
	integer	nomsg			!radio off flag
	integer	tmscor(2,8)		!team scoring information
	integer	tim0			!initial startup time
	integer	slwest			!class code of slowest terminal
	integer	kilque(KQLEN,5)		!list of players recently killed
	integer	nkill			!current length of killed queue
	integer	kilndx			!current index into killed queue
	integer tmturn(3)		!total # of turns used by each side
	integer numshp(2)		!total numbers of ships used
	integer numrom			!total number of romulans used
	integer	trstat(KNPLAY)		!tractor beam status
	integer	active(KNPLAY)		!dead ship flags
	logical	alive(KNPLAY)		!true if player is alive
	integer comknt			!dead ship monitor count
	integer hitime			!time to reinitialize HISEG
	logical	dead			!true if KILHGH already called
	integer	docked(KNPLAY)		!docked flags
	integer	hlz			!last location to zero out

	!high core not zeroed out by first player

	integer plnlok			!lock variable for LOCPLN array
	integer frelok			!lock variable for FREE routine
	integer quelok			!lock variable for queue routines

	integer	device(KNDEV)		!device names
	integer	isaydo(2,KNCMD)		!mnemonics for commands
	integer	xhelp(2,KNXTR)		!extra things help is available for
	integer	ttydat(2,KNTTY)		!mnemonics for supported TTYs
	integer	names(KNPLAY,3)		!names of players
	integer	bits(18)		!player's identification bit
					!(powers of 2 table)
	integer sbits(0 : 2)		!flag bits for different sides
	integer cmdbts(KNCMD)		!flags commands usable before game
	integer	numply			!number of active players
	integer	numsid(2)		!current # of active ships per side
	integer	versio			!version number
	integer gameno			! game number
	integer dotime			! counter for rebuilding bases
	integer score(knpoin, knplay)
