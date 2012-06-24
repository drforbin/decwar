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



*.......Echo input (diagnostic print)

	if (.not. PASFLG)  goto 222
	call out ('iwhat: ',0)  ;  call odec (iwhat,0)
	call out ('   ihita: ',0)  ;  call odec (ihita,0)  ;  call crlf
	call out ('xto: ',0)  ;  call odec (xto,0)
	call out ('   yto: ',0)  ;  call odec (yto,0)  ;  call crlf
	call out ('xfrom: ',0)  ;  call odec (xfrom,0)
	call out ('   yfrom: ',0)  ;  call odec (yfrom,0)  ;  call crlf
	call out ('critdv: ',0)  ;  call odec (critdv,0)
	call out ('   critdm: ',0)  ;  call odec (critdm,0)  ;  call crlf
	call out ('klflag: ',0)  ;  call odec (klflag,0)
	call out ('   shjump: ',0)  ;  call odec (shjump,0)  ;  call crlf
	call out ('dispto: ',0)  ;  call odec (dispto,0)
	call out ('   dispfr: ',0)  ;  call odec (dispfr,0)  ;  call crlf
	call out ('shcnto: ',0)  ;  call odec (shcnto,0)
	call out ('   shstto: ',0)  ;  call odec (shstto,0)  ;  call crlf
	call out ('shcnfr: ',0)  ;  call odec (shcnfr,0)
	call out ('   shstfr: ',0)  ;  call odec (shstfr,0)  ;  call crlf
 222	continue
