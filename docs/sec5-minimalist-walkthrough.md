assume you've started simh pdp10 and it's listening on 2010 for connections.

# on raspi side, start kermit

    ./kermit/wermit
    C-Kermit>set host localhost 2010 /raw-socket
    C-Kermit>c

# on tops10 side, start kermit

assume you've created a subfolder [,,decwar] in your home folder [,].

    .r setsrc
    *cp [,,decwar]
    *^C
    .r kermit
    Kermit-10>set file byte-size 36-bit
    Kermit-10>server
    
ctrl-\c back over to raspi kermit

# in raspi kermit

    C-Kermit>set transfer mode manual
    C-Kermit>set file type binary
    C-Kermit>send utexas/*.*
    C-Kermit>send compuserve/*.*
    C-Kermit>send scripts/COM1.CMD
    C-Kermit>send scripts/COM2.CMD
    C-Kermit>send scripts/CAN1.CMD

can leave this connection in this state for further usage and get on tops10 via another connection, but if you like to use just this connection
    
    C-Kermit>c
    Kermit-10>^c^c^c
    .
    
# on tops10 side

    .compile @com1
    .compile @com2
    .r link
    *@can1
    .get decwar
    .ssave

if it's not already there, create p,pn [1,27] using react, then copy DECWAR.EXE, DECWAR.GRP, DECWAR.HLP, DECWAR.NWS to its home folder to 'deploy/install' it. [1,27] is where decwar was deployed for compuserve. for utexas it was logical device name 'gam:', assigned to [5,30].
