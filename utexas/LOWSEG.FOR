C	This file is part of Decwar.
C	Copyright 1979, 2011 Bob Hysick, Jeff Potter, The University of Texas
C	Computation Center and Harris Newman.

C	This program is free software; you can redistribute it and/or modify
C	it under the terms of the GNU General Public License as published by
C	the Free Software Foundation; either version 3, or (at your option)
C	any later version.

C	This program is distributed in the hope that it will be useful,
C	but WITHOUT ANY WARRANTY; without even the implied warranty of
C	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
C	GNU General Public License for more details.

C	You should have received a copy of the GNU General Public License
C	along with this program; if not, write to the Free Software
C	Foundation, Inc., 51 Franklin Street - Fifth Floor, Boston, MA
C	02110-1301, USA.  


	common /lowseg/ 
     +	lfz, ntok, tknlst, vallst, typlst, ptrlst, who, iwhat, 
     +	ihita, Vto, Hto, Vfrom, Hfrom, critdv, critdm, klflg, 
     +	dispfr, dispto, dbits, shcnto, shstto, shcnfr, shstfr, shjump, 
     +	group, ngroup, pasflg, shtype, team, ccflg, player, tpoint, 
     +	phbank, tobank, ptime, prtype, rptflg, gagmsg, oflg, scnflg, 
     +	ttytyp, hcpos, icflg, ocflg, blank, llz, inflag, hungup,
     +  addrck, lkfail, terwid

	integer	lfz			!first location of LOWSEG
	integer	ntok			!number of tokens on input line
	integer	tknlst(kmaxtk)		!buffer for tokens from input line
	integer	vallst(kmaxtk)		!numeric values of tokens, else 0
	integer	typlst(kmaxtk)		!types for corresponding tokens
	integer	ptrlst(kmaxtk)		!pointers to beginning of each token
	integer	who			!which player you are
	integer	iwhat			!type of hit for MAKHIT, GETHIT
	integer	ihita			!size of hit for MAKHIT, GETHIT
	integer	Vto			!V disp. location for MAKHIT, GETHIT
	integer	Hto			!H disp. location for MAKHIT, GETHIT
	integer Vfrom			!V disp. location for MAKHIT, GETHIT
	integer Hfrom			!H disp. location for MAKHIT, GETHIT
	integer	critdv			!dev. # of crit. hit for MAKHIT, GETHIT
	integer	critdm			!size of crit. hit for MAKHIT, GETHIT
	integer	klflg			!killed flag for MAKHIT, GETHIT
	integer	dispfr			!DISP code of sender of information
	integer	dispto			!DISP code of receiver
	integer	dbits			!destination bits for MAKHIT, GETHIT
	integer	shcnto			!hittee's shield condition
	integer shstto			!hittee's shield strength
	integer shcnfr			!hitter's shield condition
	integer shstfr			!hitter's shield strength
	integer shjump			!object displacement flag
	integer	group(kngrp,2)		!player groups for SEND command
	integer	ngroup			!number of defined groups
	integer	pasflg			!true if the guy knows the password
	integer shtype			!shiptype (1=norm,10=trainer)
	integer	team			!1 for federation, 2 for empire
	logical	ccflg			!-1 if ^C while turned off
	logical	player			!player / romulan movement flag
	integer	tpoint(knpoin)		!points to be stored into SCORE
	integer	phbank(2)		!time of last phaser fire
	integer	tobank			!time of last torpedo fire
	integer	ptime			!pause after last command in GETCMD
	integer prtype			!prompt type (0 = normal)
	logical	rptflg			!TRUE if command was repeated with $
	integer gagmsg			!mask to gag msgs from individual ships
	integer oflg			!output verbosity flag
	integer	scnflg			!scan verbosity flag
	integer	ttytyp			!terminal type
	integer	hcpos			!horizontal cursor position
	integer	icflg			!default coord input type (abs,rel)
	integer ocflg			!default coord out type (abs,rel,both)
	integer	blank			!number of consecutive blank lines
	integer	llz			!last location in LOWSEG
	integer inflag			! -1 if waiting for input
	integer hungup			! -1 if job has hung up
	integer addrck			! -1 if an address failure occured
	integer lkfail			! -1 if a lock request failed
	integer terwid



