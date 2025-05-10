LOCAL .REL [10,30,DECWAR]     ;.REL file for LOCAL.
LOW   .FOR [10,30,DECWAR]     ;Dummy routine used by L.MIC linker to
                              ;force LOWSEG common block into the low
                              ;segment.
LOW   .REL [10,30,DECWAR]     ;.REL file for LOW.
MSG   .REL [10,30,DECWAR]     ;.REL file for MSG.
NIO   .SFD [10,30,DECWAR]     ;SFD containing various read/write multiple-acces
                              ;s routines.
WARMAC.REL [10,30,DECWAR]     ;.REL file for WARMAC.
DECWAR.NDX [10,30,DECWAR]     ;List of DECWAR.FOR routines and their
                              ;respective page numbers. (including
                              ;Entry point locations).  Useful when
                              ;editing.
DECWAR.REL [10,30,DECWAR]     ;.REL file for DECWAR.
LOWSEG.FOR [10,30,DECWAR]     ;Low segment common block definition
                              ;file.  'Included' throughout DECWAR,
                              ;created from WARMAC source using TECO
                              ;macro LOWSEG.SAV
HISEG .FOR [10,30,DECWAR]     ;High segment common block definition
                              ;file.  'Included' throughout DECWAR,
                              ;created from WARMAC source using TECO
                              ;macro HISEG.SAV
PARAM .SAV [10,30,DECWAR]     ;TECO macro to create PARAM.FOR file
                              ;from WARMAC source.
HISEG .SAV [10,30,DECWAR]     ;TECO macro to create HISEG.FOR file
                              ;from WARMAC source.
LOWSEG.SAV [10,30,DECWAR]     ;TECO macro to create LOWSEG.FOR file
                              ;from WARMAC source.
EXTERN.SAV [10,30,DECWAR]     ;TECO macro to create EXTERN.FOR file
                              ;from MSG source.
NDX   .SAV [10,30,DECWAR]     ;TECO macro to create DECWAR.NDX file
                              ;from DECWAR source.
EXTERN.FOR [10,30,DECWAR]     ;External text string definition file.
                              ; 'Included' throughout DECWAR, created
                              ;from MSG source using TECO macro EXTERN.SAV
                              ;(EXTERN used to force text into high-segment).
SETUP .REL [10,30,DECWAR]     ;.REL file for SETUP.
PAGE  .SAV [10,30,DECWAR]     ;TECO macro to return the appropriate
                              ;page number (from DECWAR.NDX) for a
                              ;given DECWAR Fortran routine.
MSC   .SFD [10,30,DECWAR]     ;SFD containing Misc. DECWAR related
                              ;files.
HIGH  .FOR [10,30,DECWAR]     ;Dummy routine used by L.MIC linker to
                              ;force HISEG common block into the high
                              ;segment.
HIGH  .REL [10,30,DECWAR]     ;.REL file for HIGH.
HLP   .SFD [10,30,DECWAR]     ;SFD containing all documents pertaining
                              ;to DECWAR (HELP, NEWS, plus various
                              ;letters).
TEC   .SFD [10,30,DECWAR]     ;SFD containing all the sources for the
                              ;many TECO 'tools' used in writing and
                              ;updating DECWAR.
22    .SFD [10,30,DECWAR]     ;SFD containing copies of Version 2.2
                              ;sources.
LOCAL .FOR [10,30,DECWAR]     ;Dummy subroutine for adding to L.MIC
                              ;linker when debugging a subroutine declaring
                              ;the 'LOCAL' common block (eg., to debug
                              ;a routine w/o recompiling the entire
                              ;DECWAR source, insert the desired routine
                              ;before DECWAR in the link sequence,
                              ;and add LOCAL before that if /LOCAL/
                              ;is declared).
SETMSG.REL [10,30,DECWAR]     ;.REL file for SETMSG.
SETEXT.SAV [10,30,DECWAR]     ;TECO macro to create SETEXT.FOR from
                              ;SETMSG source file.
SETEXT.FOR [10,30,DECWAR]     ;Equivalent file to EXTERN.FOR file for
                              ;SETUP code (will be loaded into the
                              ;Low-segment during SETUP, and thrown
                              ;away after entering the game proper).
LSTVAR.FOR [10,30,DECWAR]     ;Definition file for 'LSTVAR' common
                              ;block (actually, defines the use of
                              ;/LOCAL/ within the various LIST routines).
DECWAR.TAP [10,30,DECWAR]     ;Describes (lists) files to be put on
                              ;DECWAR **source** distribution tape.
                              ; This is NOT for making a 'normal' transport
                              ;tape, which should include only the
                              ;executable file, plus documentation.
PARAM .FOR [10,30,DECWAR]     ;Definition file for PARAM parameter
                              ;section 'Included' throughout DECWAR.
                              ; Created using PARAM.SAV TECO macro
                              ;from WARMAC source.
L     .MIC [10,30,DECWAR]     ;Sophisticated linker for creating new
                              ;executable file with various attributes
                              ;(Debug, DDT, Symbol table, Map, etc.)
DECWAR.COM [10,30,DECWAR]     ;Comment file for [10,30,DECWAR] SFD.
SETMSG.MAC [10,30,DECWAR]     ;Equivalent to MSG.MAC for SETUP.  Will
                              ;be thrown away after entering main part
                              ;of game.
SETUP .FOR [10,30,DECWAR]     ;Fortran source code for Startup of game,
                              ;Pre-game activity, reactivation checks
                              ;for returning players, etc.  Is eliminated
                              ;after entering main part of game.
MSG   .MAC [10,30,DECWAR]     ;Macro source defining all text strings
                              ;used with DECWAR. Combined with EXTERN.FOR,
                              ;it allows all this text to be loaded
                              ;in the High-segment.
CONTEN.MIC [10,30,DECWAR]     ;MICRO to (1) create a new contents for
                              ;a MACRO file; (2) recompile the resulting
                              ;new MACRO file; (3) generate the CREF
                              ;listing; and (4) print the CREF listing.
TO    .DO  [10,30,DECWAR]     ;Somewhat informal list of things 'to
                              ;do', that have been done, that can't
                              ;be done although it would be nice, etc.,
                              ;etc.
DECFIX.MAC [10,30,DECWAR]     ;source to program to drop decwar off
                              ;the swapper
