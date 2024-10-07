we want to create a subdirectory called decwar and then 'change directories' so its our working directory. then we want to use kermit to copy the source files from raspi side over to tops10 side.

to create the subdirectory, use the credir command. at the start here, we're logged in our own user account [27,101], and we're in our own user directory [27,101]

    .dir
    TEST2	TXT     1  <057>   31-Aug-24	DSKB:	[27,101]
    .r credir
    Create directory: [,,decwar]
    Created DSKB0:[27,101,DECWAR].SFD/PROTECTION:775
    Create directory: ^C
    .dir
    TEST2	TXT     1  <057>   31-Aug-24	DSKB:	[27,101]
    DECWAR	SFD     1  <775>    3-Sep-24
    Total of 2 blocks in 2 files on DSKB: [27,101]
    .dir[,,decwar]
    %WLDDEM Directory is empty [,,decwar]

now we change directories using the setsrc command. it's documented in the operating system commands manual. 'cp' is for 'create a new default directory path'

    .r setsrc
    *cp [,,decwar]
    *^C
    .dir
    %WLDDEM Directory is empty 

and to change back to main directory

    .r setsrc
    *cp [,]
    *^C
    .dir
    TEST2	TXT     1  <057>   31-Aug-24	DSKB:	[27,101]
    DECWAR	SFD     1  <775>    3-Sep-24
    Total of 2 blocks in 2 files on DSKB: [27,101]

get into our decwar folder and get kermit going there. put kermit into server mode.

    Kermit-10> server

escape back to raspi side with ctrl-\c. keyboard has to really be sending backslash! then can simply send files. especially, 'send *.*' from raspi decwar folder to copy them over to tops10 side.

    .r setsrc
    *cp [,,decwar]
    *^C
    .dir
    %WLDDEM Directory is empty 
    .r kermit
    TOPS-10 KERMIT version 3(136)
    Kermit-10>set file byte-size 36-bit
    Kermit-10>server
    [Kermit Server running  on  the  DEC  Host.   Please  type  your  escape
    sequence   to  return  to  your  local  machine.  Shut down the server by
    typing the Kermit BYE command on your local machine.]
    ctrl-\c
    (Back at raspberrypi)
    ----------------------------------------------------
    (~/decwar/) C-Kermit>dir
    -rw-r--r--      2675  2024-08-21 06:07:34  ALT.COD
    -rw-r--r--      1639  2024-08-21 06:07:34  BASBLD.FOR
    -rw-r--r--      2254  2024-08-21 06:07:34  BASKIL.FOR
    ...snip
    (~/decwar/) C-Kermit>remote dir
    Press the X or E key to cancel.
    File name            Size        Creation date
                    words  blocks      and time
    DSKB:[27,101,DECWAR]
    CHANGE.            333     10     6-Sep-24 19:47:02
    (~/decwar/) C-Kermit>send *.*
    ...snip long wait with kermit on its 'send files screen' doing stuff
    (~/decwar/) C-Kermit>remote dir
    Press the X or E key to cancel.
    File name            Size        Creation date
                    words  blocks      and time
    DSKB:[27,101,DECWAR]
    CHANGE.            333     10     6-Sep-24 19:47:02
    ALT   .COD         586     10     6-Sep-24 19:47:41
    BASBLD.FOR         337     10     6-Sep-24 19:48:22
    BASKIL.FOR         464     10     6-Sep-24 19:48:42
    ...snip

kermit seems to have skipped our 'docs folder' with 'send *.*', which is perfect! we don't want it copied over to tops10 side in any case! fine with us.

# permissions

once we got rolling with attempts to compile, it looked like there were permissions issues. to just bypass those, set permissions on decwar folder to <000>, and even then, started doing everything as user opr [1,2].

    .r setsrc
    *cp [,]
    *^C
    .dir
    TEST2	TXT     1  <057>   31-Aug-24	DSKB:	[27,101]
    DECWAR	SFD     3  <775>    3-Sep-24
    CHANGE	        3  <057>    6-Sep-24
    Total of 7 blocks in 3 files on DSKB: [27,101]
    .protect decwar.sfd<000>
    Files renamed:
    DSKB:DECWAR.SFD 
    .dir
    TEST2	TXT     1  <057>   31-Aug-24	DSKB:	[27,101]
    DECWAR	SFD     3  <000>    3-Sep-24
    CHANGE	        3  <057>    6-Sep-24
    Total of 7 blocks in 3 files on DSKB: [27,101]
    .r setsrc
    *cp [,,decwar]
    *^C
    .protect *.*<000>
