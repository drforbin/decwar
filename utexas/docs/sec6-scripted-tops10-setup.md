
idea is to build on rich's work for scripted setup of a baseline tops10 for decwar

based on the steubentech image modified by merlyn that we have and that does work, we want scripted install from tape of fortran-10 v6 from https://pdp-10.trailing-edge.com/ - here's download of tape image https://pdp-10.trailing-edge.com/tapes/BB-D480C-SB_1981.tap.bz2 

# itr1 - getr goin

ctrl-e in simh to get control

    noah@raspberrypi:~/tops703 $ ./pdp10-kl load-decwar1.ini
    noah@raspberrypi:~/tops703 $ ./pdp10-kl run-decwar1.ini 

was trying the run.ini 'as is' and it ended like so

    if "%SIM_NAME%" != "KL-10" goto KS
    load -c bts/boot.exb
    goto BOOT
    :KS
    boot %DSK%0
    :BOOT

from rich - You can't boot directly to the RP06 on KL10. You need to load "bts/boot.exb", then continue to get it running, You get a BOOT prompt, pressing return will load and execute "dsk:system.exe[1,4].

below works! the 'continue' is the magic, and the script makes it all the way to logged in and tty stomper ready to get ctrl-c

    if "%SIM_NAME%" != "KL-10" goto KS
    load -c bts/boot.exb
    continue
    goto BOOT
    :KS
    boot %DSK%0
    :BOOT

# itr2 - kl only cleanup, kermit, decwar account

first off, need kermit. can worry about fortan in itr3. with some good discussion with rich and merlyn, we're going with [1,27] username decwar pwd disabled. more notes about this below, under 'rando notes'. seems to be working good!

    noah@raspberrypi:~/tops703 $ ~/kermit/wermit 
    (~/tops703/) C-Kermit>set transfer mode manual
    (~/tops703/) C-Kermit>set file type binary
    (~/tops703/) C-Kermit>set host localhost 2030 /raw-socket
    (~/tops703/) C-Kermit>c
    Connecting to host localhost:2030
    Escape character: Ctrl-\ (ASCII 28, FS): enabled
    Type the escape character followed by C to get back,
    Connected to the KL-10 simulator TTY device, line 0
    KL703 11:13:56 TTY4 system 1025
    Connected to Node KL10(1) Line # 4
    Please LOGIN
    .login decwar
    Job 2  KL703  TTY4
    .r k10mit
    TOPS-10 KERMIT version 3(135)
    Kermit-10>set file byte-size 36-bit
    Kermit-10>server

here's the scripts at this stage https://github.com/drforbin/decwar/blob/minimalist/docs/tops703/load-decwar2.ini and https://github.com/drforbin/decwar/blob/minimalist/docs/tops703/run-decwar2.ini

# itr3 - fortran and compiling

doing first compiles on scripted tops10 and will just share what am seeing - this is with the scripted fortran install from tape rich already has there in the library -

    .R FORTRA
    *^C
    .VERSION
    FORTRA 10(2530) +

we're just trying it to see - believe we're gonna need fortran-10 v6 scripted install from tape of fortran-10 v6 from https://pdp-10.trailing-edge.com/ - tape image https://pdp-10.trailing-edge.com/tapes/BB-D480C-SB_1981.tap.bz2

    .LOGIN DECWAR
    Job 3 KL703 CTY
    .COMP PARAM
    FORTRAN: PARAM
    ...snip...
    %FTNWRN MAIN. No fatal errors and 28 warnings
    .COMP LOWSEG
    FORTRAN: LOWSEG
    ...snip...
    ?FTNFTL MAIN. 18 fatal errors and 1 warning

do have to suspect if we can install the fortran v6 tape, those two shooooooould work... now starting to really focus on that v6 tape image - https://pdp-10.trailing-edge.com/tapes/BB-D480C-SB_1981.tap.bz2 and eventual 'do fort10v6.do' command and subscript to have right in here... comment out 'do fort10.do', uncomment 'do fort10v6.do'...?:)

    ;do fort10.do
    do fort10v6.do
    do kermit.do

got that tap file in among rich's collection now

    noah@raspberrypi:~ $ cd tops703/tapes/
    noah@raspberrypi:~/tops703/tapes $ ls -hl
    ...snip...
    -rw-r--r-- 1 noah noah  11M Dec 23 09:07 BB-D480C-SB_FORTRAN10_V6.tap
    -rw-rw-r-- 1 noah noah  19M Apr 16  2022 BB-D480F-SB_FORTRAN10_V10.tap
    ...snip...

beginning to learn about tap files - from zero - beginners brain! first of all, clone the repo for https://github.com/simh/simtools/blob/master/extracters/backup/backup.txt and compile a backup exe. copy that over to our tape folder, and then can do like so, should be some helpful info available in here...

    noah@raspberrypi:~/tops703/tapes $ ./backup -tf BB-D480C-SB_1981_FORTRAN10_V6.tap 
    backup: opening BB-D480C-SB_1981_FORTRAN10_V6.tap for input
    1  10doc.dir
    2  forddt.doc
    3  forddt.hlp
    ...etc...

ahha! but before very many hours digging into that tape - took a step back and thought 'even though it would be amazing if it worked, let's try the current fort10.do install script from rich, just replace the tap file name...' miraculously, it seems to somewhat work! at least didn't get lots of obvious errors during the install from tape.

took the fort10.do script from rich and simply changed the tap file name to point to the f10v6 tap - in a christmas miracle, this ran with very very few complaints - think there may have been one or a very few at the very end about copying/installing things - this may be relevant below

kermitted in the needed files and did the commands we've used in the past

    .compile @com1
    .compile @com2
    .r link
    *@can1

!!!the compiles all looked good!!!:) really started to think we got it! the linker died though

    .R LINK
    *@CAN1
    %LNKFLE LOOKUP error (0) file was not found SYS:FORLIB.REL
    [       Please retype the incorrect parts of the file specification]

guess right now is that slight glitch in the fort10.do script may not have copied that FORLIB.REL to the right place - could be if we get that FORLIB.REL going, we'll get it all! did that and with a bit of trial and error tinkering, got f10v6 going - committed the three key scripts in here https://github.com/drforbin/decwar/tree/minimalist/docs/tops703

# notes around getting f10v6 and decwar going

first off, strictly the facts, or as many as can remember from a very confusing day. got f10v6 going, tap file is specified here

    expect "\r\n." send "r backup\r"; at %TAP%0 -r tapes/BB-D480C-SB_FORTRAN10_V6.tap;  continue

commented out second line here. evidently this mac file was not in v6 but was in v10. it was causing trouble before commenting out, for sure.

    expect "\r\n*" send "FOROP.REL=FOROP.MAC\r"; continue
    ;expect "\r\n*" send "FOROPN.REL=FOROPN.MAC\r"; continue
    expect "\r\n*" send "FOROTS.REL=FOROTS.MAC\r"; continue

and change the last lines to

    expect "\r\n." send "copy sys:<055>=FORLIB.REL\r"; continue
    expect "\r\n." send "copy sys:<055>=FORDDT.REL\r"; continue
    expect "\r\n." send "copy sys:<055>=FORO10.EXE\r"; continue

they were written a bit differently before and this seems to have been why forlib.rel was not where it should be. in any case, this new way certainly does work for forlib.rel. there are apparently still troubles with foro10.exe, maybe it was not in v6 at all?

note '\xxx' is octal

    expect "\r\n*" send "\003"; continue     ^c, ctrl-c, end of text, 'eom', 'etx'
    expect "\r\n*" send "\3"; continue       ^c, ctrl-c, end of text, 'eom', 'etx'
    expect "\r\n*" send "\032"; continue     ^z, ctrl-z, 'sub' substitute
    expect "\r\n*" send "\32"; continue     ^z, ctrl-z, 'sub' substitute
    expect "\r\n*" send "\033"; continue     ^[, escape

when creating the base system from tape via mongen etc, the first line below is important because it effectively kill some kind of disk process that hangs - this 'set cty stop' is useful, kind of the strongest medicine available within a simh script? one bizarre thing is the space before the ';' seemed to matter somehow. could have been confused about that. it also appears at the end, as in the second line.

    expect "Disk Reads:" set cty stop ; continue
    expect "\r\n." echo "Stopping"; set cty stop; continue

now for some 'softer' notes. the ordering of things, and building in delays via 'send -t after=100k' and 'send -t after=1000k'
seemed to have strangely powerful effects, especially when there were troubles, as in the f10v6 issues. even giving an odd sensation of async 'multi threaded' behaviour, which doesn't make any sense in the pdp10 context! this is why kermit install ended up before fortran install

    do kermit.do
    do decwar3-fort10v6.do

maybe 'out of order' output starts coming because of some kind of buffering, that gets overwhelmed when there's lots of messages? in any case, pauses at strategic points seems important! seems 'standard' for login commands, like this one

    expect "\r\n." send -t after=1000k "login 10,7\r"; continue

# rando notes

here's some comments from merlyn

    The original place where decwar was placed was 5,30 which was the GAM:
    ersatz device, CIS was using [1,27] was the multiplayer decwar directory.
    Everyone would be handed off from their original hosts to that HOST and logged onto that directory.
    The CIS source is Always referencing it.

and another from merlyn 20241223

    I could change it! But the cis code is looking for the stat (history) files in 1,27.
    The standard utexas code does run fine in sys: [1,4].
    If you guys can find the original ut code I'd love to look at it.
    I think the reference to 1,27 is in warmac.mac...look there.

    You dont have to login as 1,27
    it just looks for the stat files in 1,27
    The executable should be able to be placed elsewhere as well, I think?
    Have a look at warmac.mac and search for 1,27
    There should be a function called stat or something like that which is called to handle the history files.
    The swap file of course follows whereever the executable is. You would have to change decfix.exe
    because it does look in 1,27 also.

seems, at utexas the build was done in [10,30,decwar] and then deployed to gam: which was a 'logical device name' assigned to [5,30].

at compuserve, the build was deployed to [1,27]. not clear yet where they did there build, hopefully doesn't really matter too much?

note to self, if it's not already there, create p,pn [1,27] using react, then copy DECWAR.EXE, DECWAR.GRP, DECWAR.HLP, DECWAR.NWS to its home folder to 'deploy/install' it. [1,27] is where decwar was deployed for compuserve. for utexas it was logical device name 'gam:', assigned to [5,30].

## decwar.imp has mucho learnings about 'building decwar from tape'

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

## merlyn's build workflow and the 'steubentech descendant'

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
