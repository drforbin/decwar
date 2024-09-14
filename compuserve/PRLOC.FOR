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


C	This routine prints out a sector location (v,h) in the form
C	v-h.  A carriage return suffixes this print line if prcflg
C	is non-zero.  w should be either 2 or 0 (free format).  Prlflg
C	determines whether to output relative, absolute, or both
C	coordinates (usually OCFLG, but sometimes KABS).  Proflg
C	determines whether to output in the short, medium, or long
C	format (usually oflg, but sometimes SHORT).

	subroutine PRLOC (v, h, prcflg, w, prlflg, proflg)
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	if (prlflg .eq. KREL)  goto 100
	if (proflg .ne. SHORT)  call outc('@')
	call odec (v,w)
	call outc ('-')
	call odec (h,w)

 100	if ((pdist(v, h, shpcon(who,KVPOS), shpcon(who,KHPOS)) .eq. 0) 
     +	.and. (w .eq. 0))  goto 200
	if (prlflg .eq. KBOTH)  call space

	if (prlflg .eq. KABS)  goto 200
	tw = w  ;  if (w .ne. 0)  tw = w + 1
	call osdec (v-shpcon(who,KVPOS), tw)
	call outc (',')
	call osdec (h-shpcon(who,KHPOS), tw)

 200	if (prcflg .ne. 0)  call crlf
	return

	end
