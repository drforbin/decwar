expect "\r\n." send -t after=1000k "login 10,7\r"; continue
expect "\r\n." send "r credir\r"; continue
expect "Create directory:" send "[,,ftn10v6]/prot:755\r"; continue
expect "Create directory:" send "[,,ftn10v6,doc]/prot:755\r"; continue
expect "Create directory:" send "[,,ftn10v6,run]/prot:755\r"; continue
expect "Create directory:" send "[,,ftn10v6,tests]/prot:755\r"; continue
expect "Create directory:" send "[,,ftn10v6,compiler]/prot:755\r"; continue
expect "Create directory:" send "[,,ftn10v6,forots]/prot:755\r"; continue
expect "Create directory:" send "[,,ftn10v6,tools]/prot:755\r"; continue
expect "Create directory:" send "\3"; continue

expect "\r\n." send "r backup\r"; at %TAP%0 -r tapes/BB-D480C-SB_FORTRAN10_V6.tap;  continue
expect "\r\n/" send "tape mta0:\r"; continue
expect "\r\n/" send "rewind\r"; continue
expect "\r\n/" send "inter\r"; continue
expect "\r\n/" send "files\r"; continue
expect "\r\n/" send "rest [,,ftn10v6,doc]*.*=*.*\r"; continue
expect "\r\n/" send "rest [,,ftn10v6,run]*.*=*.*\r"; continue
expect "\r\n/" send "rest [,,ftn10v6,tests]*.*=*.*\r"; continue
expect "\r\n/" send "rest [,,ftn10v6,forots]*.*=*.*\r"; continue
expect "\r\n/" send "rest [,,ftn10v6,compiler]*.*=*.*\r"; continue
expect "\r\n/" send "rest [,,ftn10v6,tools]*.*=*.*\r"; continue
expect "\r\n/" send "exit\r"; continue
expect "\r\n." send "k/f\r"; continue

expect "\r\n." send -t after=1000k "login 1,2\r"; continue
expect "\r\n." send "copy sys:*.*=[10,7,ftn10v6,run]*.*\r"; continue
expect "\r\n." send "copy hlp:*.*=[10,7,ftn10v6,doc]*.hlp\r"; continue
expect "\r\n." send "k/f\r"; continue
