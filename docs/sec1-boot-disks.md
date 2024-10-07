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

# later / follow-on notes

first got a copy of these disk images from merlyn. he's done awesome work on them, getting fortran and then decwar working. thank you merlyn!

as part of learning to use them, am gradually learning more about their heritage. 

first steps down the rabbit hole was looking through the [joerg hoppe](https://retrocmp.com/impressum) [retrocmp.com website](https://retrocmp.com/), especially the section about [blinkenbone](https://retrocmp.com/projects/blinkenbone/simulated-panels). there, it was first dawning that the disk images could have been built on top of some from [steubentech](https://steubentech.com/~talon/pdp10/). screenshots of booting the steubentech disk images looked familiar!

