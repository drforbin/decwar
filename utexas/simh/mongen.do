expect "\r\n\177." send "R SETSRC\r"; continue
expect "\r\n\177*" send "CP [10,7,703MON]\r"; continue
expect "\r\n\177*" send "\3"; continue
expect "\r\n\177." send "ASSIGN DSKB DSK\r"; continue
expect "\r\n\177." send "copy =dskb:tops10.rel[10,7,703mon,%C%]\r"; continue
if "%SIM_NAME%" != "KL-10" goto NO
expect "\r\n\177." send "copy =dskb:makdcn.ccl[10,7,703mon,%C%]\r"; continue
expect "\r\n\177." send "copy =dskb:decnet.rel[10,7,703mon,%C%]\r"; continue
expect "\r\n\177." send "r maklib\r"; continue
expect "\r\n\177*" send "@makdcn.ccl\r"; continue
expect "\r\n\177*" send "\003"; continue
:NO
expect "\r\n\177." send "RUN MONGEN\r"; continue
expect "(PROMPT,SHORT,LONG)" send "prompt\r"; continue
expect "Which GEN(HDW,NET,F,MUNGEN):" send "HDW\r"; continue
expect "Output(DSK:HDWCNF.MAC):" send "\r"; continue
expect "DECsystem10(KL,KS):" send "%c%\r"; continue
expect "Cpu's(1,1-3):" send "1\r"; continue
expect "System name:" send "%c%703\r"; continue
if "%SIM_NAME%" == "KL-10" 'expect "CPU0 serial #(1-10000):" send "1025\r"; continue'
if "%SIM_NAME%" != "KL-10" 'expect "CPU0 serial #(1-10000):" send "4097\r"; continue'
expect "Exclude monitor overhead from user run time(Y,N):" send "N\r"; continue
if "%SIM_NAME%" == "KL-10" 'expect "EBOX/MBOX runtime accounting(Y,N):" send "N\r"; continue'
if "%SIM_NAME%" != "KL-10" 'expect "Disk drives(1,1-8)" send "8\r"; continue'
if "%SIM_NAME%" != "KL-10" 'expect "Tape drives(1,1-4)" send "4\r"; continue'
if "%SIM_NAME%" != "KL-10" 'expect "TTY lines(0-32)" send "32\r"; continue'
if "%SIM_NAME%" != "KL-10" 'expect "OPR octal line #(CTY,0-37)" send "CTY\r"; continue'
expect "Account verification(Y,N):" send "Y\r"; continue
if "%SIM_NAME%" == "KL-10" 'expect "MOS memory(Y,N):" send "N\r"; continue'
if "%SIM_NAME%" == "KL-10" 'expect "SCA support(Y,N):" send "N\r"; continue'
if "%SIM_NAME%" == "KL-10" 'expect "Include RNXKON(Y,N):" send "N\r"; continue'
if "%SIM_NAME%" == "KL-10" 'expect "Include TM2KON(Y,N):" send "Y\r"; continue'
if "%SIM_NAME%" == "KL-10" 'expect "Include TD2KON(Y,N):" send "N\r"; continue'
if "%SIM_NAME%" == "KL-10" 'expect "Include T78KON(Y,N):" send "N\r"; continue'
if "%SIM_NAME%" == "KL-10" 'expect "\r\n\177#"; continue'
if "%SIM_NAME%" == "KL-10" 'expect " of DTEs on CPU0(1,1-4):" send "2\r"; continue'
if "%SIM_NAME%" == "KL-10" 'expect "Type of front end on DTE0 (RSX20F,ANF10,IBM,DECNET):" send "RSX20F\r"; continue'
if "%SIM_NAME%" == "KL-10" 'expect "Type of front end on DTE1 (RSX20F,ANF10,IBM,DECNET):" send "DECNET\r"; continue'
if "%SIM_NAME%" == "KL-10" 'expect " terminals on front end #0(0,0-128):" send "64\r"; continue'
if "%SIM_NAME%" == "KL-10" 'expect " line printers on front end #0(0,0-2):" send "1\r"; continue'
if "%SIM_NAME%" == "KL-10" 'expect "Front end printer 0 lower case(Y,N):" send "Y\r"; continue'
expect "OPR octal line #(CTY" send "CTY\r"; continue
expect "Data set lines" send "\r"; continue
expect "\r\n\177#"; continue
expect " Jobs(1-511):" send "128\r"; continue
expect "Maximum P of core for each job(0,0-16384):" send "\r"; continue
expect "\r\n\177#"; continue
if "%SIM_NAME%" == "KL-10" 'expect " K total system core(512-4096):" send "1024\r"; continue'
if "%SIM_NAME%" != "KL-10" 'expect " K total system core(512-4096):" send "512\r"; continue'
expect "Clock ticks per second(60,50):" send "60\r"; continue
if "%SIM_NAME%" == "KL-10" 'expect "\r\n\177#"; continue'
if "%SIM_NAME%" == "KL-10" 'expect " Real-time devices(0,0-77):" send "0\r"; continue'
expect "Allow jobs to be locked in core(Y,N):" send "Y\r"; continue
expect "\r\n\177#"; continue
expect " Pages min guaranteed among jobs not locked in core(0,0-16384):" send "\r"; continue
expect "\r\n\177#"; continue
expect "\r\n\177#"; continue
expect " High priority queues(0,0-15):" send "5\r"; continue
expect "MSGSER(Y,N):" send "Y\r"; continue
expect "PSISER(Y,N):" send "Y\r"; continue
expect "IPCF(Y,N):" send "Y\r"; continue
expect "ENQ/DEQ(Y,N):" send "Y\r"; continue
if "%SIM_NAME%" == "KL-10" 'expect "LPTs(1,0-3):" send "0\r"; continue'
if "%SIM_NAME%" != "KL-10" 'expect "LPT(0,0-1):" send "1\r"; continue'
expect "Lower case(Y,N):" send "Y\r"; continue
if "%SIM_NAME%" == "KL-10" goto KLNET
expect "\r\n\177#"; continue
expect "KMC/DUP Lines(0,0-2):" send "0\r"; continue
expect "Type of line for KDP0 (ANF10,DECNET,USER):" send "DECNET\r"; continue
:KLNET
expect " PTYs(20,1-510):" send "20\r"; continue
expect 'Decimal "symbol,value"' send "\r"; continue
expect 'Octal "symbol,value"' send "\r"; continue
expect 'SIXBIT "symbol,value"' send "\r"; continue
expect 'Type "device-mnemonic,PI-channel" for special devices' send "\r"; continue
expect 'Type "device-mnemonic,PI-channel,no.-of-devices"' send "\r"; continue
expect 'Type "device-mnemonic,PI-channel,highest-ac-to-save"' send "\r"; continue
expect 'Type "ersatz-device,P,Pn,search-list-type"' send "BCL,5,24,SYS\r\r"; continue
expect 'Type "command-name,dispatch,flags,unique-bits,PRVTAB-name"' send "\r"; continue
expect 'Type "terminal-type/Alias,WIDTH,LENGTH,FF,TAB,LC,ALT,' send "\r"; continue
expect "Which GEN(HDW,NET,F,MUNGEN):" send "NET\r"; continue
expect "Output(DSK:NETCNF.MAC):" send "\r"; continue
if "%SIM_NAME%" != "KL-10" 'expect "Network software(Y,N):" send "N\r"; continue'
if "%SIM_NAME%" == "KL-10" 'expect "Network software(Y,N):" send "Y\r"; continue'
expect "ANF node number of central site(1,1-77):" send "1\r"; continue
if "%SIM_NAME%" == "KL-10" 'expect "Name of central site:" send "KL10\r"; continue'
if "%SIM_NAME%" != "KL-10" 'expect "Name of central site:" send "KS10\r"; continue'
expect "\r\n\177#"; continue
expect " of remote TTY\'s(1,1-512):" send "1\r"; continue
expect "ANF Network virtual terminals(Y,N):" send "N\r"; continue
expect "Remote card readers(Y,N):" send "N\r"; continue
expect "Remote line printers(Y,N):" send "N\r"; continue
expect "Remote DN8x DDCMP devices(Y,N):" send "N\r"; continue
expect "Remote data entry terminals(Y,N):" send "N\r"; continue
expect "Remote task-to-task through ANF(Y,N):" send "N\r"; continue
expect "\r\n\177#"; continue
expect " of ANF connects(256,1-512):" send "1\r"; continue
expect "DECnet software(Y,N):" send "Y\r"; continue
expect "DECnet area number of central site" send "1\r"; continue
expect "DECnet node number of central site" send "10\r"; continue
expect "DECnet router type(ROUTING,NONROUTING)" send "ROUTING\r"; continue
if "%SIM_NAME%" == "KL-10" 'expect "Ethernet software(Y,N):" send "Y\r"; continue'
if "%SIM_NAME%" != "KL-10" 'expect "Ethernet software(Y,N):" send "N\r"; continue'
if "%SIM_NAME%" == "KL-10" 'expect "Include LATSER(Y,N):" send "Y\r"; continue'
expect "Which GEN(HDW,NET,F,MUNGEN):" send "F\r"; continue
expect "Output(DSK:F.MAC):" send "\r"; continue
expect "Feature set(KLFULL,KSFULL):" send "%C%FULL\r"; continue
expect "Standard setting(YES,NO,LIST,EXPLAIN):" send "YES\r"; continue
expect "Which GEN(HDW,NET,F,MUNGEN):" send "\3"; continue
expect "\r\n\177." send "COMP/COMP F,S,NETPRM\r"; continue
expect "\r\n\177." send "COMP/COMP DTEPRM,ICHPRM,D36PAR\r"; continue
expect "\r\n\177." send "COMP/COMP HDWCNF+NETCNF+<COMMON,COMDEV,COMNET,COMMOD>\r"; continue
;if "%SIM_NAME%" != "KL-10" goto NODEC
expect "\r\n\177." send "R LINK\r"; continue
expect "\r\n\177*" send "/NOINIT/HASH:9000 MON%C%/SAV,MON%C%/MAP=/LOCALS -\rCOMMON,COMDEV,COMNET,COMMOD,TOPS10/SEARCH/GO\r"; continue
;goto DEC
;:NODEC
;expect "\r\n\177." send "R LINK\r"; continue
;expect "\r\n\177*" send "/NOINIT/HASH:9000 MON%C%/SAV,MON%C%/MAP=/LOCALS -\r"; continue
;expect "\r\n\177#" send "COMMON,COMDEV,COMNET,COMMOD,TOPS10[10,7,703MON,%C%]/SEARCH/GO\r"; continue
;:DEC

