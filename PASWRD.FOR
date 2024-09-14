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


C	This routine sets (and unsets) the password flag for use in
C	debugging, cheating, etc.

	subroutine PASWRD
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	PASFLG = equal(tknlst(2), KPASS, 1)	!match the password?
	if (PASFLG .eq. -1)  PASFLG = 0		!not an exact match
C	70725 project added by merlyn (drforbin)
	if ((usrprj(0) .ne. "70000) .and. (usrprj(0) .ne. "337) .and. 
     +		(usrprj(0) .ne. "70006)
     +.and. (usrprj(0) .ne. "70725))		!added
     +		pasflg = 0
	if (PASFLG)  return			!is he ok?
	call out (unkcom, 0)			!WHAT password routine!?!
	if (oflg .ne. short)  call out (forhlp, 1)
	return

	end
