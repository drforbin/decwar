target is to be able to make, use, remake decwar.tap tape file, all on top of our scripted tops10 setup, with automations that make it simpler to keep the 'know how' alive going forward.

# tape drive fair warning!

to read from tape, the following has to come first in simh script. it may not be obvious but this actually enables the tape drive for use! without it, no tape read. 

    expect "\r\n." send "r opr\r"; continue
    expect "OPR>" send "\r"; continue
    expect "OPR>" send "\r"; continue
    expect "OPR>" send "set tape mta0 unavailable\r"; continue
    expect "Enter text and terminate with ^Z" send "installing software\r\32"; continue
    expect "OPR>" send "\r"; continue
    expect "OPR>" send "exit\r"; continue
    expect "\r\n." send "k/f\r"; continue

# write decwar file with back10

here's our initial automation for writing decwar.tap

    rm -rf ./decwar-files
    mkdir ./decwar-files
    cp ~/decwar/utexas/*.* ./decwar-files
    cp ~/decwar/compuserve/*.* ./decwar-files
    cp ~/decwar/scripts/COM1.CMD ./decwar-files
    cp ~/decwar/scripts/COM2.CMD ./decwar-files
    cp ~/decwar/scripts/CAN1.CMD ./decwar-files
    ./back10 -cf ./decwar.tap ./decwar-files/*
    ./back10 -lf ./decwar.tap

# read decwar tap file

assuming opr has prepped the tape drive as noted first thing above in 'tape drive fair warning', following will make the files we wrote to the tap file appear in current users sfd decwar. we usually want to be user dist [10,7] for this, so sfd [10,7,decwar]

    expect "\r\n." send "r backup\r"; at %TAP%0 -r decwar.tap;  continue
    expect "\r\n/" send "tape mta0:\r"; continue
    expect "\r\n/" send "rewind\r"; continue
    expect "\r\n/" send "inter\r"; continue
    expect "\r\n/" send "files\r"; continue
    expect "\r\n/" send "rest [,,decwar]*.*=*.*\r"; continue
    expect "\r\n/" send "exit\r"; continue

# build and install decwar

we're user dist [10,7] - change directory into [10,7,decwar]

    expect "\r\n." send "r setsrc\r"; continue
    expect "\r\n*" send "cp [10,7,decwar]\r"; continue
    expect "\r\n*" send "\3"; continue
    
alright, build

    expect "\r\n." send "compile @com1\r"; continue
    expect "\r\n." send "compile @com2\r"; continue
    expect "\r\n." send "r link\r"; continue
    expect "\r\n*" send "@can1\r"; continue
    expect "\r\n." send ""; continue
    expect "\r\n." send "get decwar\r"; continue
    expect "\r\n." send "ssave\r"; continue
    expect "\r\n." send "k/f\r"; continue

if you don't do the send "" line you get a bizarre 'race condition' where the next line beats the '@can1\r' send to the linker - iterated on this many tens of times, it's real and it's weird - tried 'pauses', 'delays', 'sleeps', etc - only real workaround was to 'win the race' with 'nothing'!:0

now install. compuserve code is expecting directory [1,27] for keeping some global data, so create that now as part of install.
    
    expect "\r\n." send -t after=1000k "login 1,2\r"; continue
    expect "\r\n." send "r credir\r"; continue
    expect "Create directory:" send "[1,27]/prot:777\r"; continue
    expect "Create directory:" send "\3"; continue
    expect "\r\n." send "copy sys:<055>=dskb:[10,7,DECWAR]*.exe\r"; continue
    expect "\r\n." send "copy hlp:<055>=dskb:[10,7,DECWAR]*.hlp\r"; continue
    expect "\r\n." send "k/f\r"; continue

# additional notes

there's more available we may end up using, beyond the above

    noah@raspberrypi:~/tops703/tapes $ ./back10 -h
    Usage: ./back10 [action] [options] [args]
    
        Action is one of the following:
    
        -c           -- create a backup tape containing the files in arglist.
    
        -l           -- list files on tape.
        -p           -- peek at tape data.
        -s           -- show the structure of the tape.
        -t           -- type file list as .DIR MTA0: does.
        -x           -- extract files matching any of the args in arglist,
                        or any regexp given to a -R option.
    
        Options are:
    
        -b           -- build tree of output files.  (extract)
        -d           -- omit device from output tree.  (extract)
        -f <file>    -- operate on tape file for input/output.
                        "-" means stdin/stdout.
        -h           -- print help text.
        -i           -- interchange flag.
        -n           -- number of items to print.  (peek)
        -q           -- quiet (extract)
        -v           -- increase verbose mode.
    
        -A           -- set disk mode to ascii.
        -B           -- set disk mode to binary.
        -C           -- set disk mode to core-dump.
        -D           -- turn on debugging.
        -H           -- set disk mode to high-density.
        -I           -- set disk mode to industri-standard.
        -M <str>     -- set system name.  (write)
        -O opt=val   -- set option to value.
        -P <bits>    -- set/clear print control bits.  (peek)
        -R <exp>     -- set regexp of files to match.  (extract, list)
        -S <str>     -- set SaveSet name.  (write)
        -T <fmt>     -- set tape container format.
                        format is raw, tap, e11 or tpc.
                        default is tap.
        -U <str>     -- set device and UFD. (write)
                        format is "device:p,pn".

