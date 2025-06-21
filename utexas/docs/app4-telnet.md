# telnet

can scan local network with android app 'fing' and see ip numbers. 

or, what's the subnet?

    noah@Noahs-MacBook-Pro ~ % ifconfig
    en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
        inet 192.168.178.48 netmask 0xffffff00 broadcast 192.168.178.255

what's the ip of the raspi?

    noah@Noahs-MacBook-Pro ~ % ping raspberrypi
    PING raspberrypi.fritz.box (192.168.178.21): 56 data bytes

go ahead and telnet in

    noah@Noahs-MacBook-Pro ~ % telnet 192.168.178.21 2030
    Trying 192.168.178.21...
    Connected to raspberrypi.fritz.box.
    Escape character is '^]'.
    Connected to the KL-10 simulator TTY device, line 4

# terminals

Oh, by the way.  Whilst not being replicas in the physical sense, I have made software simulations of the VT100 and VT52 hardware that run the original ROM firmware/microcode.  There are some bugs, but the basics work.

https://github.com/larsbrinkhoff/terminal-simulator/

By the way again, there is a 1:3 scale VT100 replica with a working keyboard.  It's super cute!

hi lars, this reminds me - have wondered - is your terminal-simulator github project https://github.com/larsbrinkhoff/terminal-simulator/ what comes as part of the 'pidp-10 software package', as 'the vt52'? love that 'fuzzy glow' effect in that 'vt52 window', was pretty much the first thing wanted to see when got started with pidp-10:)

No, that's not my simulator.  The one that comes with the PiDP-10 was written by Angelo Papenhoff, which emulates the behaviour of a VT52 without modeling its internals.  Angelo has also written a Verilog simulation which does model the VT52 hardware very well.

also see https://github.com/Swordfish90/cool-retro-term

# aap vt52

    % brew install sdl2       
    % make vt52
    %./vt52 -B -b 9600 telnet 192.168.178.21 2030
