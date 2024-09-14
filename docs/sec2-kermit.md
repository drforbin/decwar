# remember

on raspi side.

     set transfer mode manual
     set file type binary

on tops10 side.

    set file byte-size 36-bit
    
# intro

objective here is syncing .for and .mac files between 'simh decwar' and 'other machines'. lots of the below is a walkthrough of notes tracing back via drforbin to the ancestral 'steubentech disk images'. here's a copy of the [kermit specific notes](./misc/kermit.txt).

seems there was good discussion of all this back in early 2010s - roughly 2013? seeing several simh scripts similar to the following. have this one saved in boot2.simh - it's second experiment, and is targeting kermit. note, am starting console on 1026 so it doesn't clash with simh pidp-10 ka-10 for front panel. 

    set cons telnet=1026
    set cpu tops10
    set dz 8b 
    set tim y2k
    set dz lines=32 
    att -am dz 2010 speed=*32,buffer=1024k
    att rp0 dskb.dsk
    att rp1 dskc.dsk
    att rp2 dskd.dsk
    att lp20 printer.out
    set cpu idle
    ;set throttle 2M
    boot rp

seems the important thing here is the 'att -am dz 2010'. this is a multi serial adapter dz10 listening over telnet to port 2010. this is where we want to use kermit. we've booted simh with this script and telnetted in, aiming to start kermit server on simh decwar and connect to it via port 2010 from a kermit client.

    noah@raspberrypi:~ $ telnet localhost 1026
    Trying ::1...
    Connected to localhost.
    Escape character is '^]'.
    Connected to the PDP-10 simulator CON-TELNET device
    BOOT V3(47)
    BOOT>
    [Loading from DSKB:SYSTEM.EXE[1,4]]
    VNW 10-14-99
    Why reload:

can wait and default answers will be given. or answer. some useful ones are 'why reload' = 'sched' and 'startup option' = 'quick'

    Welcome to the decSystem-10 Running Tops10 v7.03

does auto login to [1,2] opser. 'tty stomper' starts, get out of it with ctrl-c. can logout of opser with 'kjob' or 'k/f' then login as another user.

we've got a '.' prompt from the monitor.

# onboard the raspi

meanwhile, onboard the raspi. first get [latest kermit](https://www.kermitproject.org/ckdaily.html). here we see it as x.zip. make, run, and connect.

    noah@raspberrypi:~/kermit $ mv ~/Downloads/x.zip .
    noah@raspberrypi:~/kermit $ unzip x.zip
    noah@raspberrypi:~/kermit $ make linux
    noah@raspberrypi:~/kermit $ ./wermit
    C-Kermit 10.0 Beta.11, 2024/08/08, for Linux (64-bit)
    Copyright (C) 1985, 2024,
    Trustees of Columbia University in the City of New York.
    Open Source 3-clause BSD license since 2011.
    Type ? or HELP for help.

here's the important part for get connection to pdp10

    (~/kermit/) C-Kermit>set host localhost 2010 /raw-socket
    DNS Lookup...  Trying 127.0.0.1...  Reverse DNS Lookup... (OK)
    localhost connected on port 2010

then

    (~/kermit/) C-Kermit>c
    Connecting to host localhost:2010
    Escape character: Ctrl-\ (ASCII 28, FS): enabled
    Type the escape character followed by C to get back,
    or followed by ? to see other options.

for escaping back to the raspi with ctrl-\c, be sure your keyboard is really sending backslash! had to switch keyboard config to exactly the right one by trial and error.

we're ready from the raspi side! now prepare the tops10 side. we need to be able to login from the raspi side! turns out, do walk through first [using react to create default user template](https://www.quentin.org.uk/tops-10-faq/#qaef-176). doesn't take as long as it looks! then [create your account](https://www.quentin.org.uk/tops-10-faq/#qaef-177). did that here for [27,101] usr noah pwd noah and logged in from the raspi kermit side.

    .login noah
    Job 3  VNW  TTY0
    Password: 
    %LGNPCR A password change is required by the system administrator
    New password: 
    Verification: 
    [LGNNOC No operator coverage]
    [LGNPHC Password has been changed]
    10:20   31-Aug-24   Saturday
    Welcome to the decSystem-10 Running Tops10 v7.03
    Have fun!
    .

create a little text file on tops10 side

    .sos test2.txt
    Creating TEST2.TXT
    00100	hello world
    00200	$
    *e
    [DSKB:TEST2.TXT]
    .type test2.txt
    00100	hello world

# onboard tops10

now can start kermit on tops10 side and send it over to raspi side. both 'r k10mit' and 'r kermit' seem to be same.

    .r k10mit
    TOPS-10 KERMIT version 3(136)
    Kermit-10>set file byte-size 36-bit
    Kermit-10>send test2.txt

can check it on raspi side

    noah@raspberrypi:~/kermit $ cat test2.txt

on tops10 side go into 'server mode'

    Kermit-10> server

escape back to raspi side with ctrl-\c. keyboard has to really be sending backslash! then can simply send files. especially, 'send *.*' from raspi decwar folder to copy them over to tops10 side.

# switching back and forth

on raspi side, we're in raspi kermit. enter 'c' to connect back to tops10.

on tops10 side, hit crtl-\c to 'disconnect back to raspi'

# fortran continuation line issue

seems the beginning line preceding a continuation line needs to end with a space character. examples from hiseg.for and lowseg.for

	common /hiseg/
     +	hfz, shpcon, shpdam, base, nbase, board, locpln, locr, 

    common /lowseg/
     +	lfz, ntok, tknlst, vallst, typlst, ptrlst, who, iwhat, 

if there's a space char right after '/' in the beginning line, they work. another example, from captur.for. need a space after Vloc,

	if (.not. ldis(shpcon(who,KVPOS), shpcon(who,KHPOS), Vloc,
     +	Hloc, 1))  goto 500			!adjacent to sector specified?

if the three examples above are fixed with spaces at the end of their beginning lines, then captur.for compiles ok.

ending space is stripped off by kermit, learned that for certain the hard way. if we could stop kermit from stripping off end spaces, it'd be huge. we've got 'properly fixed' files on raspi, just need to get them onto tops10 without 'unfixing'.

got it! at last! 

on raspi side need to set kermit to transfer mode manual and then file type binary

     C-Kermit>set transfer mode manual
     C-Kermit>set file type binary
     C-Kermit>send LOWSEG.FOR
     C-Kermit>send HISEG.FOR
     C-Kermit>send CAPTUR.FOR

on raspi side.

     set transfer mode manual
     set file type binary

on tops10 side.

    set file byte-size 36-bit
