
# notes from merlyn around the work he did getting things going on simh pdp10

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

# notes around simh pdp10

    Requirements:
    1) a copy of bzip2 to extract the image.
    2) a working copy of simh
    3) an intrest in archaic software.

    Getting started:
    Obtain a copy of bzip2 and extract the disk image.
    Build simh you will only need to build the pdp10 emulator.
    put t10.dsk in the same directory as the  pdp10 binary.
    Run pdp10 and then follow the following dialog:
    Script started on Wed 01 Jan 2003 12:22:49 AM EST
    %nice +20 ./pdp10
    PDP-10 simulator V2.10-0
    sim> set dz 8b
    sim> set tim y2k
    sim> att rp0 dskb.dsk
    sim> att rp1 dskc.dsk
    sim> att lp20 printer.out
    sim> att -am dz 2020
    Listening on port 2020 (socket 5)
    Modem control activated
    Auto disconnect activated
    sim> boot rp
    BOOT V3(47)
    BOOT>
    [Loading from DSKB:SYSTEM.EXE[1,4]]
    VNW 10-14-99
    Why reload: shced
    OPR,PARITY,POWER,STATIC,HARDWARE
    NXM,HALT,LOOP,HUNG
    PM,CM,SA
    NEW,SCHED
    OTHER
    /H for help
    Why reload: sched
    Date: 01-jan-2003
    Time: 12:24:15
    Startup option: quick
    [Rebuilding the system search list from the HOMe blocks]
    [Rebuilding the active swapping list from the HOMe blocks]
    [Rebuilding the system dump list from the HOMe blocks]
    VNW 12:24:18 CTY system 4097
    Connected to Node (0) Line # 12
    .LOGIN 1,2
    .R OPSER
    [CCPWFD Waiting for file daemon to start]
    [OPRPAF Processing auto command file]
    ?OPRALF LOOKUP failure 0
    *
    *%%TTY STOMPER - Starting
    ^C
    .kjob

    .login public
    Job 3  VNW  CTY
    %LGNSLE Search list is empty
    12:24    1-Jan-3   Wednesday
    Welcome to TOPS-10 7.03
    Installed software:
    BASIC,COBOL(68 and 74), FORTRAN, ALGOL10A
    ,BLISS-36 V4.2, SORT, RMS, APLSFV2, 
    DBMS V5A, IQL3A V30, Message System V11CK

    .r haunt
    This is HAUNT. Version 4.6
    To the west a bus is pulling away from the next bus stop.
    *stop
    The party's over.
    Your final score is 0
    The total possible is 440
    Hmm... I don't think you tried very hard.
    ..

    .r aplsf
    terminal..tty
    HI!: PLEASE LET ME KNOW IF APL IS BROKEN
    APL-10 DECSYSTEM-10 APLSF 2(435)
    CTY) 12:25:16 WEDNESDAY  1-JAN103 PUBLIC [42,42]
    CLEAR WS
        )END
    21 INCORRECT COMMAND
        )END
        ^
        )OFF
    CTY) 12:27:17  1-JAN103
    CONNECTED   0:02:01 CPU TIME   0:00:00
    0 STATEMENTS 0 OPERATIONS
    KILO-CORE-SECS 4
    Job 3  User PUBLIC [42,42]
    Logged-off CTY  at 12:27:16  on  1-Jan-3
    Runtime: 0:00:07, KCS:1247, Connect time: 0:02:30
    Disk Reads:1906, Writes:11, Blocks saved:0
    ##### This section shows how ot shut down the system ####################
    .kjob

    .login 1,2
    Job 2  VNW  CTY
    [LGNJSP Other jobs same PPN]
    [LGNLAS Last access to [1,2] succeeded on 31-Dec-2:22:31:54]
    12:27    1-Jan-3   Wednesday

    .r opr

    OPR>
    12:24:27 	  -- [SYSTEM]CATALOG error --
            Input error reading DSKB:STRLST.SYS[1,4]; End of file

    12:24:27 	  -- [SYSTEM]CATALOG error --
            Input error reading DSKB:MTALST.SYS[1,4]; End of file

    12:24:27 	  -- [SYSTEM]CATALOG error --
            Input error reading DSKB:DTALST.SYS[1,4]; End of file

    12:24:27 	-- Begin auto take file --
            File: SYS:SYSTEM.CMD[3,3]

    12:24:28 	-- End auto take file --
            8 lines processed

    12:24:28 	Batch-Stream 0  -- Started --

    12:24:28 	Batch-Stream 1  -- Started --

    12:24:28 	Batch-Stream 2  -- Started --

    12:24:28 	Printer 0  -- Started --

    KOPR>set ksys +0:01
    OPR>
    12:27:41 	  -- Event KSYS queued, request #5 --

    SYSTEM: - Timesharing ends in 1 min at  1-Jan-3 12:28:59

    KOPR>
    12:27:59 	  -- Timesharing is over --

    12:27:59 	  -- KSYS processing completed --

    KOPR>
    SYSTEM: - Timesharing is over!

    OPR>exit

    .kjob
    [LGTOUL Other users logged-in under [1,2]]
    Job 2  User OPERATOR [1,2]
    Logged-off CTY  at 12:28:08  on  1-Jan-3
    Runtime: 0:00:00, KCS:21, Connect time: 0:00:40
    Disk Reads:210, Writes:1, Blocks saved:0
    .
    Simulation stopped, PC: 000001 (SOJG 6,1)
    sim> set fe stop
    sim> go
    BOOT>
    Simulation stopped, PC: 706226 (SKIPN 0,302032)
    sim> exit
    Goodbye
    %exit
    script done on Wed 01 Jan 2003 12:28:21 AM EST
