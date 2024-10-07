here's some comments from merlyn

        The original place where decwar was placed was 5,30 which was the GAM:
        ersatz device, CIS was using [1,27] was the multiplayer decwar directory.
        Everyone would be handed off from their original hosts to that HOST and logged onto that directory.
        The CIS source is Always referencing it.

current pic is that the three files below could be direct from the utexas tape that got sent to compuserve. notice they don't mention the many 'newer / later / compuserve' fortran files. so...

at utexas the build was done in [10,30,decwar] and then deployed to gam: which was a 'logical device name' assigned to [5,30].

at compuserve, the build was deployed to [1,27]. not clear yet where they did there build, hopefully doesn't really matter too much?


# 'important' file decwar.imp

    The following files are included on the DECWAR source distribution tape:

    DECWAR.IMP	This file.

    Files to be installed on GAM:
    DECWAR.EXE	DECWAR game.  Protected for EXECUTE access.
    DECWAR.HLP	Help for DECWAR.  Source for on line help system.
            Protected for READ access.
    DECWAR.NWS	News file (recent developments).  Protected for READ access.
    DECWAR.GRP	Gripe file.  Initially empty, added to by the DECWAR GRIPE
            command.  Must be protected to allow write access.

    Files from which the GAM: files are derived:
    DECWAR.EXE:
    HIGH.FOR	Used to force common block into high segment.
    LOW.FOR	Used to force common block into low segment.
    DECWAR.FOR	FORTRAN source.
    WARMAC.MAC	MACRO source.
    MSG.MAC	Output text source (to force text into the high segment,
            and to get rid of the annoying trailing blanks FORTRAN
            generates for literals).
    SETUP.FOR	Once only code, deleted from core after initialization.
    SETMSG.MAC	Equivalent to MSG.MAC for SETUP text strings.
    DECWAR.RNH	Help file source.
    DECNWS.RNO	News file source.

    Files INCLUDEd in DECWAR.FOR (extracted from WARMAC.MAC by TECO macros):
    PARAM.FOR	Parameters (constants).
    HISEG.FOR	High segment common block.
    LOWSEG.FOR	Low segment common block.

    Other files INCLUDEd in DECWAR.FOR:
    EXTERN.FOR	External declarations for strings used in DECWAR (extracted
            from MSG.MAC).
    SETEXT.FOR	Equivalent external declarations used by SETUP (extracted
            from SETMSG.MAC).
    LSTVAR.FOR	Common block INCLUDEd by all LIST routines (LST???).

    Relocatable files needed to produce DECWAR.EXE:
    HIGH.REL	High segment common block.
    LOW.REL		Low segment common block.
    DECWAR.REL	From DECWAR.FOR source.
    WARMAC.REL	From WARMAC.MAC source.
    MSG.REL		From MSG.MAC source.
    SETUP.REL	From SETUP.FOR source.
    SETMSG.REL	From SETMSG.MAC source.

    Tools used to build game (.SAV files generated from TECO macros):
    L.MIC		Load REL files in proper sequence into right segments.
            Note you can DO L/H for help on building the DECWAR core
            image.
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

    Misc. utilities:
    MAKHLP.MIC	Build DECWAR.HLP file from DECWAR.RNH using RUNOFF.
    MAKNWS.MIC	Build DECWAR.NWS file from DECNWS.RNO using RUNOFF.
    NDX.TEC		Build DECWAR.NDX file to be used by PAGE.TEC.
    PAGE.TEC	Search DECWAR.NDX file for page number of desired
            DECWAR.FOR subprogram.

# 'listing' file decwar.tap

    dskc:[10,30,decwar,hlp]DECWAR.IMP
    gam:DECWAR.EXE
    gam:DECWAR.HLP
    gam:DECWAR.NWS
    gam:DECWAR.GRP
    dskc:[10,30,decwar]HIGH.FOR
    dskc:[10,30,decwar]LOW.FOR
    dskc:[10,30,decwar]DECWAR.FOR
    dskc:[10,30,decwar]WARMAC.MAC
    dskc:[10,30,decwar]MSG.MAC
    dskc:[10,30,decwar]SETUP.FOR
    dskc:[10,30,decwar]SETMSG.MAC
    dskc:[10,30,decwar,hlp]DECWAR.RNH
    dskc:[10,30,decwar,hlp]DECNWS.RNO
    dskc:[10,30,decwar]PARAM.FOR
    dskc:[10,30,decwar]HISEG.FOR
    dskc:[10,30,decwar]LOWSEG.FOR
    dskc:[10,30,decwar]EXTERN.FOR
    dskc:[10,30,decwar]SETEXT.FOR
    dskc:[10,30,decwar]LSTVAR.FOR
    dskc:[10,30,decwar]HIGH.REL
    dskc:[10,30,decwar]LOW.REL
    dskc:[10,30,decwar]DECWAR.REL
    dskc:[10,30,decwar]WARMAC.REL
    dskc:[10,30,decwar]MSG.REL
    dskc:[10,30,decwar]SETUP.REL
    dskc:[10,30,decwar]SETMSG.REL
    dskc:[10,30,decwar]L.MIC
    dskc:[10,30,decwar]PARAM.SAV
    dskc:[10,30,decwar]HISEG.SAV
    dskc:[10,30,decwar]LOWSEG.SAV
    dskc:[10,30,decwar]EXTERN.SAV
    dskc:[10,30,decwar]SETEXT.SAV
    dskc:[10,30,decwar,tec]PARAM.TEC
    dskc:[10,30,decwar,tec]HISEG.TEC
    dskc:[10,30,decwar,tec]LOWSEG.TEC
    dskc:[10,30,decwar,tec]EXTERN.TEC
    dskc:[10,30,decwar,tec]SETEXT.TEC
    dskc:[10,30,decwar,hlp]MAKHLP.MIC
    dskc:[10,30,decwar,hlp]MAKNWS.MIC
    dskc:[10,30,decwar,tec]NDX.TEC
    dskc:[10,30,decwar,tec]PAGE.TEC

# 'comments' file decwar.com

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
