# decwar

historic decwar fortran IV code which has been modified to run on simh (standard tops10 system). here's a 1982 letter that utexas sent to compuserve, before sending the primordial decwar tape.

    I  have  received your request for sources to the DECWAR program.
    We will be pleased to send you the sources,  but  first  we  must
    ask  you  to  sign  and  return  the  enclosed license agreement.
    DECWAR was developed at the University of Texas  at  Austin,  and
    it  is  being  maintained.   Hence  our  interest  in  using  the
    agreement to record and control who gets the source to it. 
    
    DECWAR is a sophisticated real-time space  battle  game  designed
    to  be  played  by  from  1  to 18 people.  It was written at the
    University of Texas at Austin, primarily by Jeff Potter  and  Bob
    Hysick.   The game was originally based on a very limited, single
    job, single terminal, two player Star Trek  type  game  known  as
    WAR.   This  game  came  from  the  CDC-6600/6400  system  at the
    University of Texas at Austin, author unknown.  Robert  Schneider
    re-wrote  the original source on the CDC and started the transfer
    to the DEC-10.  In the transfer process, the game was renamed  to
    DECWAR,  largely  re-designed, and almost entirely re-written, so
    that  the  current  version  bears  little  resemblance  to   the
    original.   Almost  all the commands were added once the game was
    on the DEC-10, as well as the  basic  concept  of  separate  jobs
    controlling  each  ship, and most of the other features that make
    the  game  challenging,  exciting,  and  enjoyable.   The   first
    version  was  installed  on  the  DEC-10  in  August 1978.  After
    several revisions, a greatly enhanced and improved game,  version
    2.0, was installed in July 1979. 

# folder structure
    
- utexas folder reflects the contents of utexas/decwar.imp and the primordial tape sent from utexas to compuserve
  - utexas/tec are teco files for extracting fortran from macro
  - utexas/hlp are files used as part of building the game's help system
- compuserve folder is fortran and macro files likely associated with compuserve
  - compuserve/docs folder is files associated with compuserve documenting the primordial tape's arrival from utexas. also some related 'operational' files. decwar.map has logging from a compuserve ki10 dated 19820519.
- deploy folder is files expected for 'deploying' the built game. these are generated, for example see utexas/hlp
- scripts folder is build automations
- docs are notes from 2024 forward
  - docs/misc are miscellaneous tops-10 related things

# notes from merlyn

    changed files:
      4 -rw-r--r-- 1 mercou    382 Jul  4 01:50 DECWAR.CMD
      4 -rw-r--r-- 1 mercou   3896 Jul  9 08:19 GETCMD.FOR
     12 -rw-r--r-- 1 mercou   9503 Jul 13 01:59 DECWAR.FOR
      4 -rw-r--r-- 1 mercou   1526 Jul 15 19:11 PASWRD.FOR
     16 -rw-r--r-- 1 mercou  13784 Jul 18 04:05 MSG.MAC
     20 -rw-r--r-- 1 mercou  16599 Jul 19 18:10 SETUP.FOR
      8 -rw-r--r-- 1 mercou   6762 Jul 20 03:17 POINTS.FOR
    160 -rw-r--r-- 1 mercou 160801 Jul 24 04:07 WARMAC.MAC
    
    all changes commented and additions noted by DrForbin AKA Merlyn Cousins.
    search for (drforbin), all things yet to be fixed, search (tofix).
    email drforbin6@gmail.com to contact me.
    
    files added:
    -rw-r--r-- 1 mercou mercou 528 Jul 31 22:22 CAN1.CMD
    -rw-r--r-- 1 mercou mercou 549 Jul 31 22:22 CAN.MIC
    and DECCMP.CMD.
    
    CAN.MIC is linker control file for debug.
    CAN1.CMD is linker control file for building executable.
    DECCMP.CMD full compile control file.
    
    to compile unpack all files in directory, preferably a SFD (sub file directory).
    and do the following
    
    compile @com1
    compile @com2
    
    This should compile ALL files without any (note WARMAC.MAC) errors.
    The compiler should issue 3 warnings for WARMAC. These warnings are understood and will be fixed. There should also be some "Possible index modified in DO loop" warnings.
    Ignore these.
    They should not affect anything. 
    This will compile each file into a *.REL file (relocatable file).
    
    next,
    
    r link
    @can1
    
    You should get an EXIT.
    than.
    
    get decwar
    ssave
    
    than create p,pn [1,27] and install 
    DECWAR.EXE
    DECWAR.GRP
    DECWAR.HLP 
    DECWAR.NWS
    
    in that p,pn
    
    than path [1,27]
    run decwar
