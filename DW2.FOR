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


	BLOCK DATA
	include 'param/nolist'
	include 'hiseg/nolist'
	include 'lowseg/nolist'

	data (device(i), i = 1, KNDEV)/ 
     +	  2HSH, 2HWA, 2HIM, 2HLS, 2HTO, 2HPH, 2HCO, 2HRA, 2HTR /

	data ((isaydo(i,j), i = 1, 2), j = 1, KNCMD)/ 
     +    'BAses', '     ',
     +	  'BUild', '     ',
     +	  'Captu', 're   ',
     +	  'DAmag', 'es   ',
     +	  'DOck ', '     ',
     +	  'Energ', 'y    ',
     +    'Gripe', '     ',
     +	  'Help ', '     ',
     +	  'Impul', 'se   ',
     +	  'List ', '     ',
     +	  'Move ', '     ',
     +	  'News ', '     ',
     +	  'PHase', 'rs   ',
     +	  'PLane', 'ts   ',
     +    'POint', 's    ',
     +	  'Quit ', '     ',
     +	  'RAdio', '     ',
     +	  'REpai', 'r    ',
     +	  'SCan ', '     ',
     +	  'SEt  ', '     ',
     +	  'SHiel', 'ds   ',
     +	  'SRsca', 'n    ',
     +	  'STatu', 's    ',
     +	  'SUmma', 'ry   ',
     +	  'TArge', 'ts   ',
     +	  'TEll ', '     ',
     +	  'TIme ', '     ',
     +	  'TOrpe', 'dos  ',
     +	  'TRact', 'or   ',
     +	  'TYpe ', '     ',
     +    'Users', '     ',
     +    '*Debu' ,'g    ',
     +    '*Pass' ,'word '/

	data ((xhelp(i,j), i = 1, 2), j = 1, KNXTR)/ 
     +	  'CTL-C', '     ',
     +    '     ', '     ',
     +    'INTRO', '     ',
     +	  'HInts', '     ',
     +	  'INput', '     ',
     +	  'Outpu', 't    ',
     +	  'PAuse', 's    ',
     +	  'PRega', 'me   '/

	data ((ttydat(i,j), i = 1, 2), j = 1, KNTTY)/ 
     +	  'ACT-I', 'V    ',
     +	  'ADM-2', '     ',
     +	  'ADM-3', 'a    ',
     +	  'DATAP', 'OINT ',
     +	  'ACT-V', '     ',
     +	  'SOROC', '     ',
     +	  'BEEHI', 'VE   ',
     +	  'CRT  ', '     '/

	data ((names(i,j), j = 1, 3), i = 1, KNPLAY)/ 
     +	  'Lexin', 'gton ', ' L',
     +	  'Nimit', 'z    ', ' N',
     +	  'Savan', 'nah  ', ' S',
     +	  'Vulca', 'n    ', ' V',
     +	  'Yorkt', 'own  ', ' Y',
     +	  'Cobra', '     ', ' C',
     +	  'Demon', '     ', ' D',
     +	  'Hawk ', '     ', ' H',
     +    'Jacka', 'l    ', ' J',
     +	  'Wolf ', '     ', ' W'/

	data (bits(i), i = 1, 18)/ 
     +	  "1, "2, "4, "10, "20, "40, "100, "200, "400, "1000, "2000,
     +	  "4000, "10000, "20000, "40000, "100000, "200000, "400000/

	data (sbits(i), i = 0, 2)/ NEUBIT , FEDBIT , EMPBIT /

	data (cmdbts(i), i = 1, KNCMD)/ 
     +	  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     +	  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0/

	end
