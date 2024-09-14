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


C	When this routine is called because ^C is typed it removes
C	the player from the game before returning to monitor level,
C	thus preventing derelict ships.  All pertinent information
C	is saved so that the player can continue the game (unless
C	his ship has been taken over by someone else).

	subroutine TRAP
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'
	include 'extern/nolist'

	call CCTRAP
	call free (who)			!store ship info, remove from high seg
	who = 0
	call monit			!return to monitor
	call rstart (who)		!restore ship to high seg if possible
	return

	end
