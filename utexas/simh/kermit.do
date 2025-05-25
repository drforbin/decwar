expect "\r\n." send after=1000k "login 10,7\r"; continue
expect "\r\n." send "r credir\r"; continue
expect "Create directory:" send "[10,7,KERMIT]/prot:755\r"; continue
expect "Create directory:" send "\3"; continue
expect "\r\n." send "r backup\r"; at %TAP% -r tapes/k10mit-135.tap; continue
expect "\r\n/" send "TAPE MTA0\r"; continue
expect "\r\n/" send "FILES\r"; continue
expect "\r\n/" send "RESTORE DSKB:[10,7,KERMIT]*.*=DSKB:[76,5,kermit]*.*\r"; continue
expect "\r\n/" send "EXIT\r"; continue
expect "\r\n." send "R SETSRC\r"; continue
expect "\r\n*" send "CP [10,7,KERMIT]\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "COMP/COMPILE K10UNV.MAC\r"; continue
expect "\r\n." send "COMP/COMPILE K10MIT.MAC,K10SYS.MAC,K10WLD.MAC\r"; continue
expect "\r\n." send "COMP/COMPILE K10MSG.MAC,K10TT.MAC,K10GLB.MAC\r"; continue
expect "\r\n." send "R LINK\r"; continue
expect "\r\n*" send "@K10MIT\r"; continue
expect "\r\n." send "K/F\r"; continue
expect "\r\n." send -t after=100k "login 1,2\r"; continue
expect "\r\n." send "copy sys:<055>=dskb:[10,7,KERMIT]*.exe\r"; continue
expect "\r\n." send "copy hlp:<055>=dskb:[10,7,KERMIT]*.hlp\r"; continue
expect "\r\n." send "k/f\r"; continue
