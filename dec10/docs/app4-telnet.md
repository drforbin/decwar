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


