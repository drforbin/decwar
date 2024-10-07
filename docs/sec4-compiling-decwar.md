# starting point

with kermit rolling and files prepped over from raspi side to tops10 side, time this weekend to start digging into merlyn's instructions from the file 'changes' in the repo.

    CAN1.CMD is linker control file for building executable.
    DECCMP.CMD full compile control file.
    
these two @com1, @com2 are splitting up and equiv to @deccmp. @can1 gets used for r link.

    .compile @com1
    .compile @com2
    .r link
    *@can1
    .get decwar
    .ssave
    then create p,pn [1,27] and install DECWAR.EXE, DECWAR.GRP, DECWAR.HLP, DECWAR.NWS in that p,pn. then
    .dir [1,27]
    .r [1,27] decwar

the one already there decwar in [1,27] is definitely working. and looks like there's also another older one already there in [5,30]

    .dir [5,30]
    .r [5,30] decwar

# experiments with macro compile

here we're user opr [1,2] and getting first rel files. looking in cmp.cmd, tried lofchk, warmac, cishng, msg, setmsg. 

warmac, msg, setmsg seem to work.

    .comp warmac
    MACRO:	WARMAC
    % .SGNAM will be obsolete; please use GETTAB .GTRFN instead.
    % .SGPPN will be obsolete; please use GETTAB .GTRDI instead.
    % .SGDEV will be obsolete; please use GETTAB .GTRDV instead.
    EXIT
    .comp msg
    MACRO:	msg
    EXIT
    .comp setmsgmsg
    MACRO:	setmsg
    EXIT
    .dir
    WARMAC	REL   109  <057>    7-Sep-24
    MSG	REL    21  <057>    7-Sep-24
    SETMSG	REL     3  <057>    7-Sep-24
    Total of 1541 blocks in 142 files on DSKB: [27,101,DECWAR]

lofchk and cishng not, but actually they seem not to appear much elsewhere. bypassing these two for now, probly not needed!

    .compile lofchk
    MACRO:	lofchk
    ?MCRCFU CANNOT FIND UNIVERSAL SYSMAC 
    EXIT
    .comp cishng
    MACRO:	cishng
    ?MCRCFU CANNOT FIND UNIVERSAL SYSMAC 
    EXIT

# experiments with fortran compile

some files seem to go

    .comp param
    FORTRAN: PARAM
    00193	
    %FTNNED No END statement in program
    %FTNWRN   MAIN. 	No fatal errors and 1 warning
    .dir
    PARAM	REL     1  <057>    8-Sep-24
    Total of 1543 blocks in 145 files on DSKB: [27,101,DECWAR]

some not

    .comp decwar
    FORTRAN: DECWAR
    ?FTNFWE Line:00239 Found STATEMENT END when expecting IDENTIFIER
    00240*	
    ?FTNNRC Line:00240 Statement not recognized
    00241*	     +	hfz, shpcon, shpdam, base, nbase, board, locpln, locr, 
    00242*	
    ...snip............
    ?Internal Compiler Error
    ?Memory Protection Violation at location 453034 in Phase FORTB 
    ?while processing statement 00870
    .

would guess that because param.for has no 'include' statements, it's simpler and working. other words, the 'include' statements are causing trouble!

# learnings around fortran versions

    .r fortra
    *^C
    .version
    FORTRA 6(1144) + 
    .r fortra
    */h
    FORTRA.HLP -- HELP file for FORTRAN-10 version 6      December 1981

tape files at https://pdp-10.trailing-edge.com/  
FORTRAN-10 V6.0 1981               3.52 Mbyte      385  
FORTRAN-10_V7wLink_Feb83             4.96 Mbyte      502  
Fortran-10 Version 11               5.54 Mbyte      432

https://github.com/PDP-10/its/issues/170#issuecomment-414909112
philbudne commented on Aug 22, 2018
F10/FORTRA (FORTRAN-10) was FORTRAN-IV (FORTRAN 66) until version 7,
which supported the FORTRAN-77 standard.  I seem to recall finding
version 1 of F10 in ITS' DECSYS directory.  I can't IMAGINE anyone
ever running v7 on ITS, and I wouldn't be shocked if it used TOP-10
monitor calls not supported by DECUUO.

current pic is that we're on dec fortran-10 v6 from 1981, which makes sense historically for decwar. this means a dec superset of fortran IV / f66. it meets the f66 ansi standard, and has dec extensions. we know for a fact that v5 did the same and already had the 'include' statement. highly likely that 'include' is one of the dec extensions to f66! here's a nutshell of current learnings for decwar context  
dec fortran-10 v5, 1977, fortran iv / f66, plus dec extensions  
dec fortran-10 v6, 1981, fortran iv / f66, plus dec extensions  
dec fortran-10 v7, 1983, f77, ?plus dec extensions, !probly!?

# does decwar.com matter for compiling?

turns out, nope! this is a 'comments' file! com == comments. but understanding this did lead onwards to decwar.imp, where probably imp == important! decwar.com is additional comments, on top of decwar.imp and decwar.tap

# decwar.imp has mucho learnings about 'building decwar from tape'

this is clearly some important stuff. hence the '.imp' extension. and note it's first thing listed in decwar.tap file. in fact, decwar.imp and decwar.tap match up perfectly. 

one useful thing could be that [10,30,DECWAR] was an important folder / sfd at some point, probably for the build from tape described in decwar.imp, so p,pn 10,30 and sfd [10,30,decwar] were important back then, and could still be! in fact it's even possible that if we were 10,30 and in [10,30,decwar] then everything would magically work. this may be something to try asap.

for our possible 'include' troubles, note especially

    Files INCLUDEd in DECWAR.FOR (extracted from WARMAC.MAC by TECO macros):
    PARAM.FOR	Parameters (constants).
    HISEG.FOR	High segment common block.
    LOWSEG.FOR	Low segment common block.

    Tools used to build game (.SAV files generated from TECO macros):
    PARAM.SAV	Build PARAM.FOR from WARMAC.MAC.
    HISEG.SAV	Build HISEG.FOR from WARMAC.MAC.
    LOWSEG.SAV	Build LOWSEG.FOR from WARMAC.MAC.
    EXTERN.SAV	Build EXTERN.FOR from MSG.MAC.
    SETEXT.SAV	Build SETEXT.FOR from SETMSG.MAC.

    TECO macros used to build game (require TECO 124):
    PARAM.TEC	Source for PARAM.SAV.
    HISEG.TEC	Source for HISEG.SAV.
    LOWSEG.TEC	Source for LOWSEG.SAV.
    EXTERN.TEC	Source for EXTERN.SAV.
    SETEXT.TEC	Source for SETEXT.SAV.

hmmm, don't have teco 124, potential trouble? wasn't for merlyn! but potentially could be for a 'build from tape'?

    .teco param.tec
    [2K Core]
    *^C
    .version
    TECO 24A(235) + 
