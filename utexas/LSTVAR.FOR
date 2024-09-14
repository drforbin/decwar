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


	common /local/ 
     +	lstfz,
     +	shpctr(2), shplst(KNPLAY), sxf(2),
     +	romctr, romlst, rxf,
     +	basctr(2), baslst(KNBASE,2), bxf(2),
     +	plnctr, plnlst(KNPLNT), pxf(0:2),
     +	txf,
     +	lstlz,
     +	cmd, svpos, shpos,
     +	p, omask, smask, lmask, imask, ships, range, vpos, hpos, gxf,
     +	vposc, hposc, clsest,
     +	xf, grpbts, code, object, index, side

C	shpctr	number of ships selected for output
C	shplst	output flags for each ship
C	sxf	ship summary flags
C	romctr	number of Romulans selected for output (0 or 1)
C	romlst	Romulan output flags
C	rxf	Romulan summary flags
C	basctr	number of bases selected for output
C	baslst	output flags for each base
C	bxf	base summary flags
C	plnctr	number of planets selected for output
C	plnlst	output flags for each planet
C	pxf	planet summary flags
C	txf	target summary flags

C	cmd	command being executed
C	svpos	vertical position of ship
C	shpos	horizontal position of ship

C	p	pointer to current input token
C	omask	object mask (SHPBIT,BASBIT,PLNBIT)
C	smask	side mask (FEDBIT,EMPBIT,NEUBIT,ROMBIT)
C	lmask	listing flags (LSTBIT,SUMBIT)
C	imask	input flags (NAMBIT,ROMBIT,SHPBIT,BASBIT,PLNBIT,PRTBIT,
C		CRDBIT,FEDBIT,EMPBIT,NEUBIT,CAPBIT,RNGBIT,CLSBIT,OUTBIT)
C	ships	ships encountered on input line
C	range	maximum range to look for objects
C	vpos	vertical position of object
C	hpos	horizontal position of object
C	gxf	group summary flags

C	vposc	vertical coordinate of closest object
C	hposc	horizontal coordinate of closest object
C	clsest	distance to closest object

C	xf	{LSTBIT,SUMBIT,ORNBIT,PASBIT}
C	grpbts	selection bits for group (used for error message)
C	code	disply code of object
C	object	object code (code div 100)
C	index	object index (code mod 100)
C	side	team object is on (0=neutral,1=Federation,2=Empire,3=Romulan)
