expect "\r\n." send -t after=1000k "login 10,7\r"; continue
expect "\r\n." send "r backup\r"; at %TAP%0 -r tapes/decwar.tap;  continue
expect "\r\n/" send "tape mta0:\r"; continue
expect "\r\n/" send "rewind\r"; continue
expect "\r\n/" send "inter\r"; continue
expect "\r\n/" send "files\r"; continue
expect "\r\n/" send "rest [,]*.*=*.*\r"; continue
expect "\r\n/" send "exit\r"; continue

expect "\r\n." send "compile/comp decwar, high, low, setup\r"; continue
expect "\r\n." send "compile/comp warmac, warver, msg, setmsg\r"; continue
expect "\r\n." send ""; continue

expect "\r\n." send "r link\r"; continue
expect "\r\n*" send "decwar/save\r"; continue
expect "\r\n*" send "low/seg:low\r"; continue
expect "\r\n*" send "high/seg:high\r"; continue
expect "\r\n*" send "decwar/seg:def\r"; continue
expect "\r\n*" send "msg\r"; continue
expect "\r\n*" send "warmac,warver\r"; continue
expect "\r\n*" send "sys:forlib/sea/seg:def\r"; continue
expect "\r\n*" send "setup/seg:low\r"; continue
expect "\r\n*" send "setmsg\r"; continue
expect "\r\n*" send "sys:forlib/sea/seg:low\r"; continue
expect "\r\n*" send "/g\r"; continue
expect "\r\n." send ""; continue

expect "\r\n." send "get decwar\r"; continue
expect "\r\n." send "ssave\r"; continue
expect "\r\n." send "k/f\r"; continue
expect "\r\n." send -t after=1000k "login 1,2\r"; continue
expect "\r\n." send "copy [5,30]decwar.exe<055>=[10,7]decwar.exe\r"; continue
expect "\r\n." send "copy [5,30]decwar.hlp<055>=[10,7]decwar.hlp\r"; continue
expect "\r\n." send "copy [5,30]decwar.nws<055>=[10,7]decwar.nws\r"; continue
expect "\r\n." send "copy [5,30]decwar.grp<055>=[10,7]decwar.grp\r"; continue
expect "\r\n." send "assign gam: dskb:[5,30]\r"; continue

;expect "\r\n." send "k/f\r"; continue
