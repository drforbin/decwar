; Restore base system.
expect "\r\r\n\177." send "login\r"; continue
expect "\r\n\177." send "assign mta0 tape\r"; continue
if "%SIM_NAME%" != "KL-10" goto SKIP
expect "\r\n\177." send "get tape:fefile.exe\r"; continue
expect "\r\n\177." send "start\r"; continue
expect "DISK UNIT NAME:" send "rpa0:\r"; continue
expect "SIZE OF FILE IN BLOCKS (<CRLF> GIVES DEFAULT OF 2000):" send "\r"; continue
:SKIP
expect "\r\n\177." send "get tape:backup.exe\r"; continue
expect "\r\n\177." send "save backup\r"; continue
expect "\r\n\177." send "start\r"; continue
expect "\r\n\177/" send "tape tape\r"; continue
expect "\r\n\177/" send "files\r"; continue
expect "\r\n\177/" send "super always\r"; continue
expect "\r\n\177/" send "restore dskb:*.*\r"; continue
if "%SIM_NAME%" == "KL-10" goto SKIP2
expect "\r\n\177/" send "restore dskb:*.*\r"; continue
:SKIP2
if "%SIM_NAME%" != "PDP-10" 'expect "\r\n\177/" send "unload tape\r"; continue'
expect "\r\n\177/" send "\r"; at %TAP%0 -r tapes/cuspmar86binsrc_1of2_bb-x128b-sb.tap; continue
expect "\r\n\177/" send "rewind\r"; continue
expect "\r\n\177/" send "protect 155\r"; continue
expect "\r\n\177/" send "ssname all\r"; continue
expect "\r\n\177/" send -t delay=1000 "RESTORE DSKB:[10,7,*,*,*,*,*]=DSKB:*.*[*,*,*,*,*,*,*]\r"; continue
expect "mount new tape then type" at %TAP%0 -r tapes/cuspmar86binsrc_2of2_bb-fp63a-sb.tap; continue
expect "\r\n\177/" send "go\r"; continue
expect "\r\n\177/" send "exit\r"; continue
if "%SIM_NAME%" == "KL-10" goto SKIPFE
expect "\r\n\177." send "RUN DSKB:[10,7,CREDIR]CREDIR\r"; continue
expect "Create directory:" send "dskb0:[6,2020]/exit\r"; continue
expect "\r\n\177." send "RUN SYS:SMFILE\r"; continue
expect "SMFILE>" send "WRITE SETUP DSKB0:\r"; continue
expect "SMFILE>" send "WRITE RESET\r"; continue
expect "SMFILE>" send "READ SYS:T10KL.ULD\r"; continue
expect "SMFILE>" send "SERIAL 4097\r"; continue
expect "SMFILE>" send "WRITE CRAM\r"; continue
expect "SMFILE>" send "WRITE BOOT SYS:KSBOOT.EXE\r"; continue
expect "SMFILE>" send "WRITE DONE\r"; continue
expect "SMFILE>" send "EXIT\r"; continue
:SKIPFE
expect "\r\n\177." send "RUN DSKB:[10,7,PIP]PIP\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,acct]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,backup]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,catlog]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,compil]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,conv10]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,credir]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,cref]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,crscpy]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,daemon]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,ddt]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,ddt]ddt.rel\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,declar]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,delfil]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,direct]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,dsklst]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,dskrat]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,dteldr]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,fe]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,fe]*.txt\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,fefile]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,filcom]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,fildae]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,glob]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,galaxy,batcon]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,galaxy,cdrive]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,galaxy,galgen]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,galaxy,glxlib]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,galaxy,lptspl]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,galaxy,mount]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,galaxy,operat]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,galaxy,please]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,galaxy,pulsar]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,galaxy,quasar]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,galaxy,queue]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,galaxy,sprint]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,help]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,jobdat]*.rel\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,initia]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,kdpldr]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,knildr]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,link]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,link]*.rel\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,login]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,logout]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,macdlx]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,macro]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,maklib]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,makvfu]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,netldr]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,networ]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,opser]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,pip]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,projct]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,quolst]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,rms10]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,rsxt10]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,runoff]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,scdset]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,setsrc]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,soup]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,spear]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,sysdpy]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,systat]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,teco]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,teco]*.err\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,tgha]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,twice]*.exe\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,system]*.*\r"; continue
expect "\r\n\177*" send -t delay=2000 "sys:/x=dskb:[10,7,makvfu]*.vfu\r"; continue
expect "\r\n\177*" send "\3"; continue
expect "\r\n\177." send "prot sys:*.* <055>\r"; continue
expect "\r\n\177." send "r credir\r"; continue
expect "Create directory:" send "hlp:\r"; continue
expect "Create directory:" send "doc:\r"; continue
expect "Create directory:" send "rel:\r"; continue
expect "Create directory:" send "unv:\r"; continue
expect "Create directory:" send "act:\r"; continue
expect "Create directory:" send "\3"; continue
expect "\r\n\177." send "copy rel:<055>=dskb:[10,7,acct]*.rel\r"; continue
expect "\r\n\177." send "copy rel:<055>=dskb:[10,7,catlog]*.rel\r"; continue
expect "\r\n\177." send "copy rel:<055>=dskb:[10,7,helper]*.rel\r"; continue
expect "\r\n\177." send "copy rel:<055>=dskb:[10,7,jobdat]*.rel\r"; continue
expect "\r\n\177." send "copy rel:<055>=dskb:[10,7,lcp]*.rel\r"; continue
expect "\r\n\177." send "copy rel:<055>=dskb:[10,7,galaxy,glxlib]*.rel\r"; continue
expect "\r\n\177." send "copy rel:<055>=dskb:[10,7,galaxy,mount]*.rel\r"; continue
expect "\r\n\177." send "copy rel:<055>=dskb:[10,7,galaxy,operat]*.rel\r"; continue
expect "\r\n\177." send "copy rel:<055>=dskb:[10,7,galaxy,pulsar]*.rel\r"; continue
expect "\r\n\177." send "copy rel:<055>=dskb:[10,7,macten]*.rel\r"; continue
expect "\r\n\177." send "copy rel:<055>=dskb:[10,7,ncptab]*.rel\r"; continue
expect "\r\n\177." send "copy rel:<055>=dskb:[10,7,rms10]*.rel\r"; continue
expect "\r\n\177." send "copy rel:<055>=dskb:[10,7,scan]*.rel\r"; continue
expect "\r\n\177." send "copy rel:<055>=dskb:[10,7,swil]*.rel\r"; continue
expect "\r\n\177." send "copy rel:<055>=dskb:[10,7,ufdset]*.rel\r"; continue
expect "\r\n\177." send "copy rel:<055>=dskb:[10,7,uuosym]*.rel\r"; continue
expect "\r\n\177." send "copy rel:<055>=dskb:[10,7,wild]*.rel\r"; continue
expect "\r\n\177." send "copy unv:<055>=dskb:[10,7,acct]*.unv\r"; continue
expect "\r\n\177." send "copy unv:<055>=dskb:[10,7,actsym]*.unv\r"; continue
expect "\r\n\177." send "copy unv:<055>=dskb:[10,7,jobdat]*.unv\r"; continue
expect "\r\n\177." send "copy unv:<055>=dskb:[10,7,galaxy,galgen]*.unv\r"; continue
expect "\r\n\177." send "copy unv:<055>=dskb:[10,7,galaxy,glxmac]*.unv\r"; continue
expect "\r\n\177." send "copy unv:<055>=dskb:[10,7,galaxy,mount]*.unv\r"; continue
expect "\r\n\177." send "copy unv:<055>=dskb:[10,7,galaxy,operat]*.unv\r"; continue
expect "\r\n\177." send "copy unv:<055>=dskb:[10,7,galaxy,quasar]*.unv\r"; continue
expect "\r\n\177." send "copy unv:<055>=dskb:[10,7,macten]*.unv\r"; continue
expect "\r\n\177." send "copy unv:<055>=dskb:[10,7,macsym]*.unv\r"; continue
expect "\r\n\177." send "copy unv:<055>=dskb:[10,7,rms10]*.unv\r"; continue
expect "\r\n\177." send "copy unv:<055>=dskb:[10,7,scan]*.unv\r"; continue
expect "\r\n\177." send "copy unv:<055>=dskb:[10,7,swil]*.unv\r"; continue
expect "\r\n\177." send "copy unv:<055>=dskb:[10,7,ufdset]*.unv\r"; continue
expect "\r\n\177." send "copy unv:<055>=dskb:[10,7,uuosym]*.unv\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,backup]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,catlog]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,credir]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,cref]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,crscpy]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,declar]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,delfil]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,direct]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,dskrat]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,dteldr]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,filcom]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,glob]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,galaxy,please]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,galaxy,pulsar]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,galaxy,mount]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,galaxy,operat]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,galaxy,queue]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,help]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,initia]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,kdpldr]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,link]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,login]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,macro]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,maklib]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,makvfu]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,ncptab]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,netldr]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,networ]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,opser]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,pip]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,quolst]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,rsxt10]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,runoff]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,setsrc]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,soup]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,systat]*.hlp\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,tgha]*.hlp\r"; continue
expect "\r\n\177." send "r backup\r"; at %TAP%0 -r tapes/bb-x140b-bb_1986.tap; continue
expect "\r\n\177/" send "tape tape\r"; continue
expect "\r\n\177/" send "files\r"; continue
expect "\r\n\177/" send "super always\r"; continue
expect "\r\n\177/" send "RESTORE DSKB:[10,7,*,*,*,*,*]=DSKB:*.*[*,*,*,*,*,*,*]\r"; continue
if "%SIM_NAME%" != "PDP-10" 'expect "\r\n\177/" send "unload tape\r"; continue'
expect "\r\n\177/" send "\r"; at %TAP%0 -r tapes/decnet_mcb_cusps_703a.tap; continue
expect "\r\n\177/" send "rewind\r"; continue
expect "\r\n\177/" send "protect 155\r"; continue
expect "\r\n\177/" send "supersede always\r"; continue
expect "\r\n\177/" send "ssname all\r"; continue
expect "\r\n\177/" send -t delay=1000 "RESTORE DSKB:[10,7,*,*,*,*,*]=DSKB:*.*[*,*,*,*,*,*,*]\r"; continue
expect "\r\n\177/" send "exit\r"; continue
expect "\r\n\177." send "copy sys:<055>=dskb:[10,7,dcnmcb]*.exe\r"; continue
expect "\r\n\177." send "copy sys:<055>=dskb:[10,7,dcncsp]*.exe\r"; continue
expect "\r\n\177." send "copy hlp:<055>=dskb:[10,7,dcncsp]*.hlp\r"; continue
expect "\r\n\177." send "delete sys:nml702.exe\r"; continue
