expect "BOOT>" send "\r"; continue
expect "Why reload:" send  "sa\r"; continue
expect "Date:" send  "03-19-86\r"; continue
expect "Time:" send  "0000\r"; continue
expect "Startup option:" send  "quick\r"; continue
expect "%TTY STOMPER - Starting" send "\3"; continue
expect "\r\n*" continue
expect "\r\n." continue
expect "\r\n." continue

expect "\r\n." send "r opr\r"; continue
expect "OPR>" send "\r"; continue
expect "OPR>" send "\r"; continue
expect "OPR>" send "set tape mta0 unavailable\r"; continue
expect "Enter text and terminate with ^Z" send "installing software\r\32"; continue
expect "OPR>" send "\r"; continue
expect "OPR>" send "exit\r"; continue
expect "\r\n." send "k/f\r"; continue

expect "\r\n." send -t after=1000k "login 5,30\r"; continue
expect "\r\n." send "r backup\r"; at %TAP%0 -r tapes/utexas23-reconstruction.tap;  continue
expect "\r\n/" send "tape mta0:\r"; continue
expect "\r\n/" send "rewind\r"; continue
expect "\r\n/" send "inter\r"; continue
expect "\r\n/" send "files\r"; continue
expect "\r\n/" send "rest [,]*.*=*.*\r"; continue
expect "\r\n/" send "exit\r"; continue
expect "\r\n." send "compile/comp decwar, high, low, setup, warmac, msg, setmsg\r"; continue
expect "\r\n." send ""; continue
; line above is the expect hack, shouldn't be needed but seems to work
expect "\r\n." send "r link\r"; continue
expect "\r\n*" send "decwar/save\r"; continue
expect "\r\n*" send "low/seg:low\r"; continue
expect "\r\n*" send "high/seg:high\r"; continue
expect "\r\n*" send "decwar/seg:def\r"; continue
expect "\r\n*" send "msg\r"; continue
expect "\r\n*" send "warmac\r"; continue
expect "\r\n*" send "sys:forlib/sea/seg:def\r"; continue
expect "\r\n*" send "setup/seg:low\r"; continue
expect "\r\n*" send "setmsg\r"; continue
expect "\r\n*" send "sys:forlib/sea/seg:low\r"; continue
expect "\r\n*" send "/g\r"; continue
expect "\r\n." send "get decwar\r"; continue
expect "\r\n." send "ssave\r"; continue
expect "\r\n." send "protect decwar.exe <055>\r"; continue
expect "\r\n." send "protect decwar.hlp <055>\r"; continue
expect "\r\n." send "protect decwar.nws <055>\r"; continue
expect "\r\n." send "protect decwar.grp <000>\r"; continue
expect "\r\n." send "protect decwar.ini <000>\r"; continue
expect "\r\n." send "del *.sta\r"; continue
expect "\r\n." send "k/f\r"; continue

expect "\r\n." send -t after=1000k "login 1,2\r"; continue
expect "\r\n." send "assign gam: dskb:[5,30]\r"; continue
;expect "\r\n." send "copy [100,100]decwar.ini=[5,30]decwar.ini\r"; continue
;expect "\r\n." send "protect [100,100]decwar.ini <000>\r"; continue
;expect "\r\n." send "k/f\r"; continue

;show expect
