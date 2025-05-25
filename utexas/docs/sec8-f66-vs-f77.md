# f66 vs f77

decwar is a fusion of fortran and assembly. roughly speaking, much of the real work happens in assembly, it's usually interacting with the high segment memory where the overall game state for multiple players/jobs lives. the fortran is somewhat of an i/o layer, interacting with the players. it's doing quite a bit of text i/o. now here's the thing. very roughly speaking the assembly code is 'six bit ascii' and expects the same with fortran, which means the f66 fortran66 ascii standard, hollerith characters, etc. f77 fortran77 ascii standard brought breaking changes with 'seven/eight bit ascii', character data type, suppression of hollerith, etc. here's the two relevant tapes for decwar.

    tapes/BB-D480C-SB_FORTRAN10_V6.tap   f66  'six bit ascii'
    tapes/BB-D480F-SB_FORTRAN10_V10.tap  f77  'seven/eight bit ascii'

we gotta care about that f66 tape. decwar is 'natively' f66. will discuss below 'porting' decwar to f77, it seems possible, but probly means breaking changes in the assembly code as well.

good question is which direction the 'math stuff' in docs/algebra and docs/inverse will go. f77 makes things 'easier' at least superficially... but does it make sense to 'stay old school' with f66, especially in light of 7090/7094, cdc, etc - in other words - for matrix inverse and simplex, fifties and sixties style - f66? or f77?:)

# f66

    noah@raspberrypi:~/decwar/tops703 $ ./back10 -xvf tapes/BB-D480C-SB_FORTRAN10_V6.tap ins
    fortra.ins -> fortra.ins
    noah@raspberrypi:~/decwar/tops703 $ head fortra.ins     
    FORTRAN-10 Version 6 Installation Guide
    December 1981

f66 installation guide is appended at the end below.

# f77

did indeed get decwar building and running on f10v10 f77 'ok-ish' - was actually playing with two players/jobs etc - but there's definitely i/o gremlins and looks like a major job to fix all that - to say the least:) set that aside in arc/utexas-f77 and focusing on f66 for now!

# f66 installation guide

                               CONTENTS

CHAPTER 1       SUMMARY


CHAPTER 2       INSTALLATION AND TESTING OF STANDARD FORTRAN

        2.1     INSTALLATION OF STANDARD FORTRAN . . . . . . . . . 2-1
        2.2     TESTING OF STANDARD FORTRAN  . . . . . . . . . . . 2-3


CHAPTER 3       INSTALLATION AND BUILDING OF NONSTANDARD FORTRAN

        3.1     BUILDING THE FORTRAN COMPILER FROM SOURCES . . . . 3-1
        3.1.1     Using The FORTRAN Compiler With DDT  . . . . . . 3-2
        3.2     BUILDING A SINGLE-SEGMENT VERSION OF FORTRAN . . . 3-2
        3.3     BUILDING FOROT6.EXE AND FORLIB.REL FROM SOURCES  . 3-3
        3.3.1     Using A Non-standard QUASAR Interface  . . . . . 3-4
        3.3.2     Building A FOROT6 With Symbols . . . . . . . . . 3-4
        3.4     BUILDING FORDDT FROM SOURCES . . . . . . . . . . . 3-4
        3.5     APPLYING SOURCE PATCHES TO THE FORTRAN PRODUCT . . 3-5


CHAPTER 4       BUILDING DBMS VERSION 5A WITH FORTRAN-10


CHAPTER 5       BUILDING SORT VERSION 4C WITH FORTRAN-10













                              CHAPTER 1

                               SUMMARY



This document describes the procedures for  installing  the  following
software:


     1.  Version 6(1144) of the FORTRAN compiler

     2.  Version 6(2033) of FOROTS (the FORTRAN object-time system)

     3.  Version 6(2033) of FORLIB (the FORTRAN library)

     4.  Version 6(154) of FORDDT (the FORTRAN debugger)

FORTRAN, FORLIB, FOROTS, and FORDDT should be installed on  SYS:,  and
.HLP files should be installed on HLP:.

The release is in the form of a 1600  BPI  FORTRAN  distribution  tape
written in BACKUP interchange mode containing six savesets.

The distribution tape consists of the following savesets:

     1.  <FORTRAN-DOCUMENTATION>

         This saveset includes all FORTRAN  documentation  files.   It
         also includes .HLP files.

     2.  <FORTRAN-SYSTEM>

         This saveset includes the .EXE and .REL files that should  be
         installed on SYS:.

     3.  <FORTRAN-TEST>

         This saveset includes the UETP tests and .VER file.  It  also
         includes  a  .CTL  file  that will run the same tests without
         using UETP.

     4.  <FORTRAN-OTS-DEBUGGER>

         This saveset includes the sources for FOROTS and FORDDT,  and
         all  intermediate  files  generated  when building FOROTS and
SUMMARY                                                       Page 1-2


         FORDDT.

     5.  <FORTRAN-COMPILER>

         This saveset includes the sources for the compiler,  and  all
         intermediate files generated when building the compiler.

     6.  <FORTRAN-TOOLS>

         This saveset  includes  the  miscellaneous  system  utilities
         needed  to  build the compiler and FOROTS.  This includes the
         BLIS10 compiler, HELPER, and other tools.













                              CHAPTER 2

             INSTALLATION AND TESTING OF STANDARD FORTRAN




The following files comprise  the  FORTRAN  compiler  and  object-time
system.   Merely  copying  these  files  from  the  distribution  tape
provides a working FORTRAN system.  The FORTRAN software  works  on  a
KI10, KL10, or KS10 processor.  The files are:

     FORTRA.HLP
     FORTRA.EXE
     FORTB.EXE
     FORTC.EXE
     FORTD.EXE
     FORTE.EXE
     FORTF.EXE
     FORTG.EXE
     FOROT6.EXE
     FORLIB.REL
     FORDDT.REL
     FORDDT.HLP



2.1  INSTALLATION OF STANDARD FORTRAN
     ____________ __ ________ _______

Perform the following steps to install the FORTRAN system:

(1)  LOGIN as the operator.

(2)  Mount the FORTRAN distribution tape.

(3)  Use the CREDIR program to create directories for the contents  of
     the  FORTRAN  distribution tape.  You may use directories of your
     choice.  Type the following commands:

          .R CREDIR
          Create directory:dev:[proj,prog,DOC-directory]
          Create directory:dev:[proj,prog,RUN-directory]
          Create directory:dev:[proj,prog,TESTS-directory]
          Create directory:dev:[proj,prog,FOROTS-directory]
          Create directory:dev:[proj,prog,COMPILER-directory]
          Create directory:dev:[proj,prog,TOOLS-directory]
INSTALLATION AND TESTING OF STANDARD FORTRAN                  Page 2-2


(4)  Use the BACKUP program to restore the files from the distribution
     tape  to  disk.  If you wish not to restore a particular saveset,
     just replace  the  particular  RESTORE  command  with  a  SKIP  1
     command.  Type the following commands:

          .R BACKUP
          /TAPE MTAn:
          /REWIND
          /INTERCHANGE
          /FILES                           !OPTIONAL
          /DENSITY 1600
          /RESTORE [DOC-directory]*.*=*.*       !SAVE SET 1
          /RESTORE [RUN-directory]*.*=*.*       !SAVE SET 2
          /RESTORE [TESTS-directory]*.*=*.*     !SAVE SET 3
          /RESTORE [FOROTS-directory]*.*=*.*    !SAVE SET 4
          /RESTORE [COMPILER-directory]*.*=*.*  !SAVE SET 5
          /RESTORE [TOOLS-directory]*.*=*.*     !SAVE SET 6
          /EXIT

(5)  Follow the "SPECIAL INSTRUCTIONS" (if any)  at  the  end  of  the
     cover  letter.   Also,  read the FORTRAN Beware file for any last
     minute instructions.

(6)  It is recommended that you save the old  version  of  FORTRAN  in
     case they are needed again.  Type the following commands:

          .COPY OLD:=SYS:FOROTS.EXE
          .COPY OLD:=SYS:FORLIB.REL
          .COPY OLD:=SYS:FORTRA.EXE
          .COPY OLD:=SYS:FORTB.EXE
          .COPY OLD:=SYS:FORTC.EXE
          .COPY OLD:=SYS:FORTD.EXE
          .COPY OLD:=SYS:FORTE.EXE
          .COPY OLD:=SYS:FORTF.EXE
          .COPY OLD:=SYS:FORTG.EXE
          .COPY OLD:=SYS:FORDDT.REL
          .COPY OLD:=HLP:FORTRA.HLP
          .COPY OLD:=HLP:FORDDT.HLP

(7)  Install the new FORTRAN system software by giving  the  following
     commands:

          .COPY SYS:*.*=[RUN-directory]*.*
          .COPY HLP:*.*=[DOC-directory]*.HLP

     Note that FOROTS and FORLIB have been built to  run  on  a  KI10,
     KL10,  or  KS10  processor.   This  configuration is the only one
     supported.  A slight  improvement  in  speed  and  space  can  be
     obtained  on  a KL10 or KS10 with the following procedure.  First
     remove the line:

          ftki=-1

     and insert the line:
INSTALLATION AND TESTING OF STANDARD FORTRAN                  Page 2-3


          ftkl=-1

     into file B10FRS.CTL, which creates F1SHR.MAC and F1REL.MAC.

(8)  Decide if you want to destroy the directories you created in step
     (3).   For each directory you wish to destroy, give the following
     commands.  (Note:  a directory cannot be deleted  unless  all  of
     its subdirectories have been deleted.)

          .DELETE [proj,prog,name-of-directory-to-destroy]*.*
          .DELETE [proj,prog]name.SFD



2.2  TESTING OF STANDARD FORTRAN
     _______ __ ________ _______

Perform the following procedures to test the FORTRAN system:

(1)  Install the FORTRAN UETP test  module  by  giving  the  following
     commands:

          .COPY UTP:=[TESTS-directory]*.FOR
          .COPY UTP:=[TESTS-directory]FORTRA.VER

(2)  In the file UTP:UETP.DIR, add the line:

          FORTRA.VER

     Also make sure that the file UTP:FORTRA.SFD<777> exists.

(3)  If desired, run the standalone FORTRAN test  module  provided  by
     giving the following command:

          .SUBMIT F10TST.CTL

     The test expects to find all the FORTRAN  system  components  and
     the  distributed  FORTRAN  test  programs on logical device DSK:.
     The test also copies certain required system software  components
     to DSK:, for the duration of the test run.

     When the test batch job is completed, the F10TST.LOG file must be
     examined  to  make  sure  that  none of the tests branched to the
     error label UERR::.

(4)  Once the FORTRAN system components have been  installed  in  SYS:
     (see  Step 7 above), you may run the UETP test module provided by
     giving the following commands:

          .RUN UTP:UETP
          UETP>ENABLE FORTRA/DEPTH:VERIFICATION
          UETP>ENABLE 
          UETP>BEGIN
          UETP>EXIT

     If any errors occur, UETP will report them at your  terminal  and
INSTALLATION AND TESTING OF STANDARD FORTRAN                  Page 2-4


     in  the  file  EXCEPT.LOG  in the UTP:  subdirectory FORTRA.  The
     files FORTRA.LOG, RUN.LOG, and EXCEPT.LOG  may  be  deleted  from
     that  subdirectory.   For  more information on UETP, see the UETP
     Procedures/Reference Manual.

     Run your own tests if desired.  If you run  your  own  tests,  be
     sure that SYS:  is defined to include [RUN-directory].












                              CHAPTER 3

           INSTALLATION AND BUILDING OF NONSTANDARD FORTRAN




This chapter describes building the FORTRAN compiler from  sources  if
modifications to the standard compiler are desired.  It also describes
building FOROTS, FORLIB, and FORDDT from sources.





3.1  BUILDING THE FORTRAN COMPILER FROM SOURCES
     ________ ___ _______ ________ ____ _______

Required software:

     BLIS10 7E(227)
     LINK 4A
     MACRO 53A
     SCAN 7B
     WILD 7
     HELPER 5(41)

Running the control file B10FTN.CTL will build the compiler  from  its
sources   and  produce  the  binary  files.   This  control  file  has
successfully built and loaded the compiler at  the  Digital  Equipment
Corporation  - Marlboro computer facilities.  This, however, in no way
guarantees its operation or support.

The control file used to build the compiler in-house  uses  a  private
pack  called  DSKP:,  and  references field-image software from ersatz
device  DEC:   ([10,7]).   BLIS10.EXE  7E(227)  is  included  on   the
distribution  tape.   One  source  file (COMMON.MAC) references [5,11]
(REL:) for several files.

Building the FORTRAN compiler from  the  sources  provided  is  not  a
trivial  computational  task.   It  requires  a considerable amount of
computer resources.  All of the modules will  compile  within  70K  of
user  core  with  the exception of LEXICA.BLI which requires 75K.  The
complete execution of B10FTN.CTL requires at least 2 and 1/2 hours  on
a  KL10  processor.   It  takes longer on a KI or KS processor.  It is
advised that  only  installations  desiring  to  modify  the  compiler
consider completely rebuilding it.
INSTALLATION AND BUILDING OF NONSTANDARD FORTRAN              Page 3-2


In addition, it should be noted that the supplied  control  files  are
divided  into  clearly  commented  sections  so  that it can easily be
determined which phases need to be reloaded if modifications are made.
Therefore,  installations  inserting  their own modifications into the
compiler usually need only recompile the modules  changed  and  reload
the  overlays  affected  without  rebuilding the entire compiler.  See
MODULE.MEM for a list of which modules are in which phases.


                                 NOTE

               When loading the programs LEFT72, LEFTFM
               and  BUILD,  undefined  globals  will be
               encountered.  These should  be  ignored,
               as  indicated  by  comments  in the .CTL
               file.



The control file called L10FTN.CTL will  produce  a  complete  set  of
source listings of the compiler.

To submit a control file to run on a KL10, use the following command:

     .SUBMIT filename/RESTART/TIME:3:0:0/UNIQUE:0



3.1.1  Using The FORTRAN Compiler With DDT
       _____ ___ _______ ________ ____ ___

The distribution tape contains a version  of  the  segmented  compiler
loaded  with  DDT  under  the  names  DORT*.EXE.   These files must be
renamed to FORT*.EXE before use.

If for some reason it is desired to load the compiler with DDT,  there
is  a  series of LINK indirect files included which are similar to the
*.CMD files used in B10FTN.CTL.  They are D*.CMD files and are used in
the same fashion as the *.CMD files.

Since only breakpoints in the low segment are phase  independent,  the
standard  technique  to  set  a  break point is to set one in FORTRA -
module MAIN at GETSG+53 and then SAVE the segment.  This will cause  a
break  point  to  occur at the beginning of each phase of the compiler
just after it is loaded.  At this point, break points can  be  set  in
the  particular  phase.   These  phase-dependent breakpoints should be
removed prior to bringing the next segment into core.



3.2  BUILDING A SINGLE-SEGMENT VERSION OF FORTRAN
     ________ _ ______________ _______ __ _______

The LINK indirect file ALL.CMD  (and  the  DDT  version  DALL.CMD)  is
included  on  the  distribution  tape  and  can  be  used  to  load  a
single-segment  version  of  the  compiler.   This   is   particularly
attractive  for  installations where the job mix contains many FORTRAN
INSTALLATION AND BUILDING OF NONSTANDARD FORTRAN              Page 3-3


compilations of several small  subroutines,  especially  if  they  are
handled   in   batch  mode.   Note  however  that  the  single-segment
configuration is not supported.

The single-segment version is comprised of the  same  modules  as  the
multisegment   version,   except   the  modules  DOPT.MAC,  DGCMN.MAC,
DNPT.MAC, ERROV?.BLI, and OWNDM.MAC are not needed, and ONESEG.REL  is
used  instead  of  MAIN.REL.   ONESEG  is  simply  a  recompilation of
MAIN.BLI, recompiled with the compilation control variable  FT1SEG  in
the  REQUIRED  file FT1SEG.REQ (built as FT1SEG.REQ in B10FTN.CTL) set
to  1  rather  than  0.   This  eliminates  the  GETSEGs.   Note  that
ONESEG.REL  as  well  as  SINGLE.EXE,  as  well  as  other modules are
included on the distribution tape.

If you wish to use the  single-segment  compiler  type  the  following
command:

     .COPY SYS:FORTRA.EXE=SINGLE.EXE

FORTB.EXE, FORTC.EXE, and so on will no longer be used.



3.3  BUILDING FOROT6.EXE AND FORLIB.REL FROM SOURCES
     ________ __________ ___ __________ ____ _______

This section describes the  procedures  for  building  FOROT6.EXE  and
FORLIB.REL  from  sources  if modifications to the standard FOROTS and
FORLIB are desired.

The control file B10FRS.CTL can be used to  build  FOROTS  and  FORLIB
from  the  sources.   The  build  process  uses  structure  DSKP:  and
field-image software from ersatz device DEC:  ([10,7]).

This control file has successfully built and  loaded  the  FOROTS  and
FORLIB  at  the  Digital  Equipment  Corporation  -  Marlboro computer
facilities.  This, however, in no  way  guarantees  its  operation  or
support.

To run the control file use the following command:

     .SUBMIT B10FRS.CTL/RESTART/TIME:0:30:00/UNIQUE:0


                                 NOTE

               The GALAXY  Version  2  QSRMAC.UNV  file
               must be used to build FOROTS on TOPS-10.
               A sample V2 QSRMAC.UNV  is  included  on
               the  distribution  tape  in  the saveset
               <FORTRAN-TOOLS>, but we  recommend  that
               you  provide  your  own file to preserve
               your  installation's   QUASAR   specific
               parameters.
INSTALLATION AND BUILDING OF NONSTANDARD FORTRAN              Page 3-4


3.3.1  Using A Non-standard QUASAR Interface
       _____ _ ____________ ______ _________

If your site has  modified  the  QUASAR  system  file  QSRMAC.MAC,  to
include  new  fields  in  the  "CREATE"  message for example, you must
rebuild FOROTS from sources.  If you have  added  non-standard  fields
that  should  not  be  left blank, you must modify FOROPN.MAC near the
label "CLSQ", otherwise FORTRAN programs will not be able to  use  the
DISPOSE='<queue>' options of the CLOSE statement.



3.3.2  Building A FOROT6 With Symbols
       ________ _ ______ ____ _______

FOROT6.EXE does not normally contain symbols.  This configuration  was
assumed  to  be the generally most desirable for TOPS-10 sites so that
memory can be conserved as much as possible.  However,  this  prevents
easy   debugging  or  patching  of  FOROT6.   To  build  symbols  into
FOROT6.EXE, you must edit the file  F10OTS.CCL  and  comment  out  the
first  line  containing  the /SET switches, and remove the ";" comment
character from the next line that contains the /SET switches.  This is
the  configuration  that  loads  symbols.   You  will notice that more
memory must be allocated (The PSECT origins are lower).

If the FOROTS you  are  building  contains  patches  or  is  otherwise
different  from  the  vanilla  released  FOROTS,  you  may encounter a
problem when FOROTS is rebuilt using this updated LINK  command  file.
The likely problems and their recovery procedures are:
1.  PSECT overlap - You must move F.CODE and/or F.ERR down;  LINK will
provide the information you need in the error message.
2.  Not enough room for symbols after  F.ERR  -  You  must  move  down
F.CODE and F.ERR origins.
3.  ?Page UUO error 4 - You must move up F.CODE and F.ERR origins.




3.4  BUILDING FORDDT FROM SOURCES
     ________ ______ ____ _______

This section describes the procedures for building FORDDT from sources
if modifications to the standard FORDDT are desired.

The control file B10FDT.CTL can be used to build FORDDT from  sources.
The  build process uses structure DSKP:  and field-image software from
ersatz device DEC:  ([10,7]).

This control file has successfully built and loaded the FORDDT at  the
Digital  Equipment  Corporation - Marlboro computer facilities.  This,
however, in no way guarantees its operation or support.

To run the control file use the following command:

     .SUBMIT B10FDT.CTL/RESTART/TIME:0:30:00/UNIQUE:0
INSTALLATION AND BUILDING OF NONSTANDARD FORTRAN              Page 3-5


3.5  APPLYING SOURCE PATCHES TO THE FORTRAN PRODUCT
     ________ ______ _______ __ ___ _______ _______

Source patches (edits) are  published  in  the  DECsystem-10  Software
Dispatch  as  a problem description, accompanied by one or more FILCOM
files  which  detail  some  number  of  source  module  changes.   The
specified  problem  is  eliminated by insertion of the source changes,
and rebuilding  the  affected  FORTRAN  product  component  using  the
procedures described above.

In general, each edit to the product consists of a new  entry  in  the
revision  history comments, a change to the edit number of the product
component, and some number of changes to the code.  Code  changes  are
pinpointed by a line of commentary (banner line) that accompanies each
non contiguous set of source line changes.

The component revision histories and edit number definitions are found
in  REVHST.MAC  for  the compiler, FOROTS.MAC for the library and OTS,
and FORDDT.MAC for the debugger.  In  addition,  the  compiler  source
modules  all  have  a local edit number and revision history, found at
the beginning  of  each  source  module.   All  new  revision  history
comments  will  always  precede  the  line "***** End Revision History
*****".

Banner lines, which are provided only as a tool for  patch  insertion,
are  NOT  to  be added to the sources.  They are comment lines, taking
the forms:

!**;[nnnn] Where field 1, Where field 2, XXX, Date - for BLIS10 sources
                         or
;**;[nnnn] @ TAG + (or -) mL, Action, XXX, Date - for MACRO sources

         Where field 1:  Routine, module, or macro name.

         Where field 2:  @ line mmmm:    where mmmm is the line number
                                         taken from a compiler listing
                                         of the module. The word "line"
                                         may not always appear.

                         @ text:         where text is used to describe
                                         positioning when line numbers
                                         are not available (such as
                                         REQUIRE files).

         TAG:            Closest unique MACRO tag to the source change.
                         May be qualified with feature test indicators.

         mL:             The change goes at m Lines down (+) or up (-)
                         from the specified TAG. Using an editor to
                         position to the line defining the TAG, and
                         then advancing m lines will assure correct
                         positioning for the actual source change.

         Action:         The usual 3 are: inserted x lines, deleted
                         x lines, or replaced x lines.
INSTALLATION AND BUILDING OF NONSTANDARD FORTRAN              Page 3-6


The BLIS10 line numbers referenced are those produced by compiling the
distributed version of the module, using the distributed REQUIRE files
(if any are required).  Distributed means exactly as  they  appear  on
the FORTRAN distribution tape, with no edits installed.

In situations where lines of  code  are  deleted,  a  single  line  of
commentary will be left behind containing the edit number that removed
the code.  This line MUST remain in the sources (just as banner  lines
must  NOT  appear).   Failure  to  adhere  to  these  rules  may cause
difficulties with later edits that give line counts from MACRO  module
TAGs used in previous edits.

Each changed line of source code (where  feasible),  will  be  flagged
with an edit indicator [nnnn] in commentary associated with the source
line.  For MACRO changes, this text will usually appear as  the  first
item in the comment field, such as:

                 MOVEI   T1,3            ;[1234] Get error count

For BLIS10 changes, this text will  generally  appear  down  the  left
margin of the source module, such as:

         %[1234]%        T1 _ 3;         !Get error count
but may also appear as the first item in the comment field.












                              CHAPTER 4

               BUILDING DBMS VERSION 5A WITH FORTRAN-10




This chapter describes how to build FORTRAN-10 with DBMS Version 5A.

First, install the accompanying LINK patches (see the  FORTRAN  Beware
file).   These  patches  enable  PSECTED  FOROTS and TWOSEG DBMS to be
combined  into  a  single  module.   This  version  of  LINK  is   not
recommended for any other use.

Make sure you have:
FOROTS.RLS
FORCNV.RLS
FORDBM.RLS
FOREND.RLS
FORERR.RLS
FORFMT.RLS
FORIO.RLS
FORMEM.RLS
FOROP.RLS
FOROPN.RLS
FORTRP.RLS
FORXIT.RLS
FORHAK.REL
and a non-DBMS FORLIB.REL in your build area.   Create  the  following
file, called 10500.FIX:

     .EDIT 10500
     .MODULE DBGATE
     .INSERT OTSCALL+10,REPLACE,<PUSHJ P,DBMS.>
            PUSHJ   P,DBMS%##
     .ENDI
     .ENDE

In the DBMS10.CTL file, at label QFORT, change the following .R MAKLIB
command sequence:

     .R MAKLIB
     *FORLIB=FORLIB/DELETE:FORDBM
     *FORLIB=FORLIB,DBSFOR/APPEND,DBS10/APPEND,DBSANY/APPEND,SCHIO1/APPEND
     *FORLIB=FORLIB/INDEX
BUILDING DBMS VERSION 5A WITH FORTRAN-10                                Page 4-2


to

     .R MAKLIB
     *DBSFOR=DBSFOR,10500/FIX
     *FORLIB=DBSFOR,DBSANY/APP,DBS10/APP,SCHIO1/APP,FUNDEF/APP,FORLIB
     /APP
     *FORLIB=FORLIB/INDEX

Then change the following .R LINK command sequence:

     .R LINK
     *@DBSCS1F
     .SAVE FDBOTS

to

     .R LINK
     *@F1DOTS
     .RU FDBOTS
     .SSAVE FDBOTS
     When you are satisfied that the build has gone correctly,
     rename FDBOTS.EXE to be FOROT6.EXE.












                                   CHAPTER 5

                    BUILDING SORT VERSION 4C WITH FORTRAN-10



To install SORT Version 4C with FORTRAN-10, just restore the file FSORT.EXE from
the  SORT  distribution tape and place on SYS:.  The necessary interface routine
is built into FORLIB.REL.



[End of FORTRA.INS]

