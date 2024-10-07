20240819 had an awesome chat with merlyn yesterday and have many things to begin remembering. will just focus on decwar here. my starting point - 'new' raspi5 prepped and ready to integrate into pidp-10 front panel. pidp-10 software is installed and running great for months now. first played with its - emacs, lisp, spacewar, adventure, etc. then switched to tops-10 - sos, macro, fortran.

yesterday merlyn shared the disk image he's built up. it has a working decwar, old fortran iv needed for that, tops-10 7.03 monitor, etc. here's a minimal simh script which roughly speaking could boot it

```
set cons telnet=1025
at rpa0 dskb.dsk
at rpa1 dskc.dsk
at rpa2 dskd.dsk
boot rpa
```

was curious how the pdp10-kl binary in pidp-10 package would react - the package binaries were built by richard cornwell? here's what that looked like

noah@raspberrypi:/opt/pidp10/bin $ ./pdp10-kl dsk.txt
%SIM-INFO: Created blink_thread
warning: failed to set RT priority
%SIM-INFO: PiDP-10 FP on

KL-10 simulator Open SIMH V4.1-0 Current
/opt/pidp10/bin/dsk.txt-1> set cons telnet=1025
%SIM-INFO: Listening on port 1025
/opt/pidp10/bin/dsk.txt-5> boot rpa
                                   %SIM-INFO: Waiting for console Telnet connection
%SIM-INFO: Running
Killed

it didn't crash and burn immediately - but didn't really boot either.

next step seems to be to build a simh pdp10 binary matching what merlyn uses!:)

wootwoot! quick update - plain vanilla simh pdp10 binary built and booting from merlyn's disk image first try:)

```
set cons telnet=1025
at rp0 dskb.dsk
at rp1 dskc.dsk
at rp2 dskd.dsk
boot rp
```

VNW 12:24:23 CTY system 4097
Connected to Node (0) Line # 12
Welcome to the decSystem-10 Running Tops10 v7.03
...snip...
Do you want black holes? (no) 

Currently there are 0 Federation ships and 0 Empire ships.
Which side do you wish to join? (Federation or Empire) fed

You will join the forces of the Federation.

The following vessels are available for you to use.

Excalibur 
Farragut  
Intrepid  
Lexington 
Nimitz    
Savannah  
Trenton   
Vulcan    
Yorktown  

Which vessel do you wish to command? ex

Command: scan

```
   33  35  37  39  41  43  45  47  49  51  53
23  . . . . . . . . . . . . . . . . . . . . . 23
22  . . . . . . * . . . . . . . . . . . . . . 22
21  . . . . . . . . . . . . . . . . . . . . . 21
20  . . . . * . . * . . . . . . . . . . . . . 20
19  . . . . . . . . . . . . . . . . . . . . . 19
18  . . . . . . . . . . . . . . . . . . . . . 18
17  . . . . . . . . .[] . . . . . . . . . . . 17
16  . . . . . . . . . . . . . . . . . . . . . 16
15  . . . . . . . . . . . . . . . . . . . . . 15
14  . . . . . . . . . . . . . . . . . . . . . 14
13  . . . . * . . . . . E . . . . . . . . . . 13
12  * . . . . . . . . . . . . . . . . . . . . 12
11  . . . . . . . . . . . . . . . * . . . . . 11
10  . . . . . . . . . . . . . . . . . . . . . 10
 9  . . . . . . . . . . . . . . . . . . . . .  9
 8  . . . . . . * . . . . . . . . . . . . . .  8
 7  . . . . . . . . . . . . . . . . . . * . .  7
 6  . . . . . . . . . . . * . . . . . . . . .  6
 5  . . . . . . . . . . * . . . . . . . . . *  5
 4  @ * . . . . * . . . . . . . * . . * . . .  4
 3  . . . . . . * * . . . . . . . . . . . . .  3
   33  35  37  39  41  43  45  47  49  51  53
```

first time have seen that in forty years!:0
