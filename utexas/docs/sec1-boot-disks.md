there are three disk image binary files and the objective is to boot into the tops-10 they contain. the following are simh commands to save in a text file beside the three binary files, for example boot.simh

    set cons telnet=1025
    at rp0 dskb.dsk
    at rp1 dskc.dsk
    at rp2 dskd.dsk
    boot rp

we also want to use simh to build a pdp10 binary executable beside the four files above. what worked on a raspi5 was to clone the simh repo

    noah@raspberrypi:~ $ git clone https://github.com/open-simh/simh.git
    Cloning into 'simh'...
    remote: Enumerating objects: 36708, done.
    remote: Counting objects: 100% (8679/8679), done.
    remote: Compressing objects: 100% (590/590), done.
    remote: Total 36708 (delta 8252), reused 8122 (delta 8088), pack-reused 28029 (from 1)
    Receiving objects: 100% (36708/36708), 70.94 MiB | 3.83 MiB/s, done.
    Resolving deltas: 100% (28747/28747), done.

go into the repo and make pdp10

    noah@raspberrypi:~ $ cd simh/
    noah@raspberrypi:~/simh $ make pdp10

then go into the build folder, have all five files there, and run the new pdp10 binary

    noah@raspberrypi:~/simh $ cd BIN/
    noah@raspberrypi:~/simh/BIN $ ls
    buildtools  dskb.dsk  dskc.dsk  dskd.dsk  boot.simh  pdp10
    noah@raspberrypi:~/simh/BIN $ ./pdp10 boot.simh
    PDP-10 simulator Open SIMH V4.1-0 Current        git commit id: 8ed26d30
    /home/noah/simh/BIN/dsk.txt-1> set cons telnet=1025
    %SIM-INFO: Listening on port 1025
    /home/noah/simh/BIN/dsk.txt-5> boot rp
    %SIM-INFO: Waiting for console Telnet connection
    %SIM-INFO: Running

when sim-info says 'waiting for console telnet connection', go into another window and telnet in

    noah@raspberrypi:~ $ telnet localhost 1025
    Trying ::1...
    Connected to localhost.
    Escape character is '^]'.
    Connected to the PDP-10 simulator CON-TELNET device
    BOOT V3(47)
    BOOT>

from here on, things have 'gone internal' within tops-10 and the topics become tops-10 specific.

note, am starting console on 1026 so it doesn't clash with simh pidp-10 ka-10 for front panel. 

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
    Have fun!
    .LOGIN 1,2
    .R OPSER
    [OPRPAF Processing auto command file]

does auto login to [1,2] and runs opser. the login 1,2 is passwordless for console, not for non console telnet. 'tty stomper' starts, get out of it with ctrl-c. can logout of opser with 'kjob' or 'k/f' then login as another user, but might as well keep this free 1,2 login going.

we've got a '.' prompt from the monitor.

# later / follow-on notes

first got a copy of these disk images from merlyn. he's done awesome work on them, getting fortran and then decwar working. thank you merlyn!

as part of learning to use them, am gradually learning more about their heritage. 

first steps down the rabbit hole was looking through the [joerg hoppe](https://retrocmp.com/impressum) [retrocmp.com website](https://retrocmp.com/), especially the section about [blinkenbone](https://retrocmp.com/projects/blinkenbone/simulated-panels). there, it was first dawning that the disk images could have been built on top of some from [steubentech](https://steubentech.com/~talon/pdp10/). screenshots of booting the steubentech disk images looked familiar!

# december 2024 notes from pidp10 google group

I found out that devices are named differently in the KS version.  Especially since the disk images I grabbed are RP06s.  So I had to first define RPA0 and RPA1 as RP06s. Then attach them properly.  But it seems the images I grabbed does not have the passwords to login to other accounts besides the default Console login.  So I am a bit stumped there.  Did you build 703 from the tape images? Or didyou find a different set of images.  I also was not seeing port 2020 being listened to.  So the attach for that had to change to DZ from DC.  I can now kind of login.  Not sure the proper start up for this version.  Setting switch 32 worked.  But trying to force it via the pdpcontrol I learned I had to input the 8 as I tried 10 and it got confused.  I will look at your boot file and see what's different.  Thanks.

Make sure you build PDP10 simulators with PIDP10=1 If you download the ZIP files for the OS you want to run, in 
directory, "<simulator> load.ini"   You can copy the disk images to where ever you want. run.ini will run the images.
For 7.x the scripts automatically configure for Bob's PDP10, KL or KS 10. Accounts are same as other Tops 10 builds. 
Note this is build from tape and not pregened disk image. It includes compilers etc. Rich

"I found out that devices are named differently in the KS version"

Yes, I found that out the hard way as well. The KS-10 version of the SIMH user guide also helped me (attached, in case you don't have it).

"Did you build 703 from the tape images?"

No. I found runnable disk images here: https://steubentech.com/~talon/pdp10/

I have since evolved a lot from that. I would be willing to share my disks, I think I might have room on my DropBox account. Let me know if you're interested.

I did try building from tape once and it failed miserably. I want to look at Rich C's resources at some point.

"But it seems the images I grabbed does not have the passwords to login to other accounts besides the default Console login."

Do any of these work?
        [1,2]      FAILSA
        [6,6]      MAINT
        [7,7]      OPER
        [10,*]     DIST
        [100,100]  DEMO1
        [100,101]  DEMO2

Also, on the steubentech images, there's a "public" account with no password. As in, when asking to log in just say 
username public and either it doesn't ask for a password or just enter nothing as a password.

I have it working now.  It runs the KS code and blinks nicely.  I found the password for 1,2 buried in the
description text for those disk images (RP06s).  No, I have not tried an install from tape.  I'd rather not as I am
sure it would not go well.  Not sure what you mean by you've evolved from steubentech images.  It works.  Is it
perfect?  Who knows. It works for now.  Glad I can be running later TOPS-10, but did not want to give up the
blinkenlights.  But I did not have to, so all is well.  It's been 45 years since I worked on a real KA-10.  :)

Like I said, if you don't mind waiting for 20 to 30 minutes, my auto install scripts will build you a Tops 10 disk 
images with all software installed and tested. The install is from tape. You will also have a log of how to install 
everything. Also where possible, compilers and other additions are build from source.

I built 7.03 and 7.04 from Rich's scripts today. It's an easy process (Thanks, Rich!). The whole job is spread 
across several scripts but they do seem to be relatively straightforward. It should not be a major issue to modify 
them as needed.

Build jobs for all available versions of Tops10 are available on my web site. https://sky-visions.com/dec These 
builds will install available compilers and additional tools.
