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


C	This routine outputs either the 'normal' (Command: ) command
C	prompt, or an 'informative' command prompt.  The 'informative'
C	command prompt consists of a '> ', preceded by any and/or all
C	of the following:	D : Ship damages > 2000 units,
C				E : Ship energy < 1000 units,
C				S : Shields down or < 10%,
C			       nL : Ship life support damaged, reserves
C				    of n stardates.

	subroutine PROMPT
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	if (prtype)  go to 100	!normal or informative prompt?
	call out (comlin,0)	!normal prompt...
	return

*.......Analyse and output pertinent ship conditions.

 100	if (shpdam(who,KDLIFE) .ge. KCRIT) 
     +	call odec (shpcon(who,KLFSUP), 0)
	if (shpdam(who,KDLIFE) .ge. KCRIT)  call outc ('L')
	if ((shpcon(who,KSSHPC) .le. 100) .or. (shpcon(who,KSHCON) 
     +	.lt. 0))  call outc ('S')
	if (shpcon(who,KSDAM) .ge. 20000)  call outc ('D')	!ship damages > 2000?
	if (shpcon(who,KSNRGY) .le. 10000)  call outc ('E')	!yellow alert?
	call out2c ('> ')	!finish prompt...
	return

	end
