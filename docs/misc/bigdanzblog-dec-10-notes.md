**Getting TOPS-10 Running on PDP-10 Emulation** 

Happily someone has done ALL the work for this one. Good thing because I never operated this system and only know if from a user perspective. 

SIM-H compliant disks already exist as dskb.dsk and dskc.dsk. I created the following cmd file for pdp-10.exe to load the operating system: 

set dz 8b   
set tim y2k   
att rp0 dskb.dsk   
att rp1 dskc.dsk   
att lp20 printer.out   
att \-am dz 2020   
boot rp 

this is invoked by simply typing *do tops10* 

\[C:\\Simulators\\DEC10Sim\\emulator\]pdp10 

PDP-10 simulator V3.8-1   
sim\> do tops10   
Listening on port 2020 (socket 1912\)   
Modem control activated   
Auto disconnect activated   
BOOT V3(47) 

I created a BAT file that does this and can have a shortcut linked to to make starting as easy as double clicking. 

You will end up with a boot prompt to which you just press enter and then begin the boot sequence: 

BOOT\>   
\[Loading from DSKB:SYSTEM.EXE\[1,4\]\] 

VNW 10-14-99   
Why reload: sched   
Date: 07-28-2011   
Time: 14:49:00 

Startup option: quick   
\[Rebuilding the system search list from the HOMe blocks\] 

\[Rebuilding the active swapping list from the HOMe blocks\] \[Rebuilding the system dump list from the HOMe blocks\] 

The system will automatically login and run OPSER: 

VNW 14:51:07 CTY system 4097   
Connected to Node (0) Line \# 12   
.LOGIN 1,2   
.R OPSER  
\[CCPWFD Waiting for file daemon to start\]   
\[OPRPAF Processing auto command file\]   
?OPRALF LOOKUP failure 0   
\*%%TTY STOMPER \- Starting 

After you get this far in opser, you can control-C out. 

Once the emulator is up, you can telnet into it using port 2020 (I used VT100 emulation). 

The non-operator login is  

login public   
or   
login 42,42 

and there is no password 

**Various useful commands** 

kjob logout   
sys sysstat \- shows various items of interest   
sos easier than teco 

**To shut down** 

At console, type: 

r opr 

set ksys \+0:01 {turn off time sharing in 1 minute} wait for timesharing to end: 

OPR\>   
;;SYSTEM: \- Timesharing ends in 1 min at 22-Sep-11 13:45:00 13:43:59 \-- Timesharing is over \-- 

13:43:59 Batch-Stream 32 \-- KSYS stream started \-- 13:43:59 Batch-Stream 32 \-- Begin \-- 

 Log file: DSKB:B24644.LOG\[3,3\]   
13:43:59 Batch-Stream 32 \-- End \--   
 Job KSYS Req \#261632 for PUBLIC \[42,42\] 13:43:59 \-- KSYS processing completed \-- 

OPR\>   
;;SYSTEM: \- Timesharing is over\! 

OPR\>exit 

control-e to get to sim prompt   
type: 

set fe stop  
g 

to return to boot prompt 

**SOS Commands** 

SOS is way easier to use than teco, but it produces numbered lines only. sos \<newfilename\> 

This puts you in a blank file in insert mode. Press \<esc\> to escape. 

| \<lf\>  | prints next line |
| ----- | :---- |
| \<esc\>  | print prev line |
| c d,f:l  | copy f:l to/after d |
| d \<f\>\[:\<l\>\]  | to delete lines |
| e \[s|q\]  | exit\&save, exit & save w/o lines, exit and don’t save |
| f\<text\>\<esc\>:0  | find text starting at beginning |
| i \<line\>  | starts inserting at/after \<line\> |
| n \<inc\>  | renumbers |
| p \<f\>\[:\<l\>\]  | to print lines |
| r \<f\>:\<l\>  | replace lines f thru l |

**Stream a batch job** 

Batch jobs are simply commands placed in a .ctl file such as: 

.type test.ctl 

sys 

dir 

to stream(queue) it, type: 

.submit test.ctl 

\[Batch job TEST queued, request \#19, limit 0:05:00\] 

Normally output would go to printer, but there is no printer, so you will find output in test.log. 

**Monitoring batch jobs**  
At console, in OPR (.r opr) 

To *see batchjobs*, type: 

OPR\>show queues batch-jobs   
OPR\>   
16:27:28 \-- System Queues Listing \-- 

Batch Queue:   
Job Name Req\# Run Time Core User   
\-------- \------ \-------- \----- \------------------------ \* LOOP 25 00:05:00 512 PUBLIC \[42,42\] In Stream:0  Job 14 Running LOOP Runtime 0:01:00 

There is 1 job in the queue (1 in progress); 00:05:00 runtime To *stop batch jobs*: 

hold batch-jobs \* 

then  

release batch-jobs \* 

To *suspend a running job*: 

requeue batch-stream \<n\> (you must list jobs to see the stream it is in) then 

release batch-jobs \* 

to *abort a job*: 

abort batch-stream \<n\> 

**Detaching** 

The best thing in TOPS-1o. At ., type detach: 

.det 

From job 2 

To reattach, specify the job\#: 

.att 2 

Password:  

\[LGNNOC No operator coverage\] 

\[LGNATJ Attaching to job 2 \[42,42\] in monitor mode\] 

If something big is running, ctl-C, ccont, and det to run it in the background:  
.exe loop.for 

LINK: Loading 

\[LNKXCT LOOP execution\] 

^C 

^C 

.ccont 

.det 

From job 2 

and you can see it running detached: 

Job Who Line\# What Size(P) State Run Time 

 1 \[OPR\] DET STOMPR 9+8 SL 0 

 2 42,42 DET LOOP 7+28 RN 8:58 

**Printer Control** 

Printing should automatically occur to the file printer.out. If you want to clear this file while the O/S is running, control-e, detach from the printer, delete printer.out, then attach back to the printer. 

(These notes are from the Operator’s Guide) 

Printer control is done in OPR (.r opr) 

*Printer requires operator action*:  

Generally I have not had to do anything to make the printer work correctly. However, sometimes I have to respond to a request in OPR. 

Here I print a file and type print again to see if it is done: 

.print dsklst.lst   
\[Printer job DSKLST queued, request \#11, limit 197\] 

.print 

Printer Queue:   
Job Name Req\# Limit User   
\-------- \------ \------- \------------------------   
\* DSKLST 11 197 OPSER \[1,2\] On Unit:0  \--Waiting For Operator Response-- 

There is 1 job in the queue (1 in progress); 197 pages 

The printer is waiting for an operator response. So at the console, I run OPR and respond to the request: 

12:52:01 Printer 0 \-- Begin \--   
 Job DSKLST Req \#11 for OPSER \[1,2\]  
12:52:01 Printer 0 \-- Loading RAM with 'LP96' \-- 12:52:01 Printer 0 \-- Loading VFU with 'NORMAL' \-- 

12:52:01 \<1\> Printer 0 \-- Align Forms and Put Online \--  Type 'RESPOND \<number\> PROCEED' when ready OPR\>respond 1 proceed 

To *start the printer*: 

OPR\>start printer 0   
OPR\>   
16:47:04 Printer 0 \-- Already Started \-- 

To *stop the printer:* 

OPR\>stop printer 0   
OPR\>   
16:47:53 Printer 0 \-- Stopped \-- 

To *restart printer after stop:* 

OPR\>continue printer 0   
OPR\>   
16:49:52 Printer 0 \-- Continued \-- 

To *abort current printout*: 

abort printer 0 /purge 

Misc 

OPR\>**Show parameters printer** 

Printer Parameters:   
 Unit Page Limits Form Prio Lim Ex Dev-Chars  \---- \------------ \------ \----- \------- \---------  0 0:2000 NORMAL 1:63 Ask Lower LP05 

OPR\>**show status printer**   
OPR\>   
10:10:09 \-- System Device Status \-- 

Printer Status:   
 Unit Status Jobname Req\# User  \---- \--------------- \------- \------ \------------------------  0 Opr Resp Wait TEST 5 PUBLIC \[42,42\]  Started at 10:01:13 

OPR\>**show messages**   
OPR\>   
10:12:01 \-- System messages outstanding \-- 

10:01:13 \<1\> Printer 0 \-- Align Forms and Put Online \--  Type 'RESPOND \<number\> PROCEED' when ready  
OPR\>**respond 1 proceed**   
OPR\>   
10:12:26 Printer 0 \-- End \--   
 Job TEST Req \#5 for PUBLIC \[42,42\] OPR\> 

10:12:26 Printer 0 \-- Begin \--   
 Job INP Req \#8 for PUBLIC \[42,42\] Printer Config info is kept in sys:lpform.ini 

**Card Reader** 

To assign a text file to the card reader: 

sim\> set cr enabled   
sim\> att cr carddeck.txt   
CR: unit is read only 

In OPR: 

NOTE: I never successfully figured out how to read from the card reader. 

start reader 0   
stop reader 0 

continue reader 0 (if stop command issued from hardware) 

OPR\>show status reader   
OPR\>   
11:10:24 \-- System Device Status \-- 

Reader Status:   
 Unit Status   
 \---- \---------------   
 0 No processor 

**Tape Drive** 

To make tapes available on the emulator, first enable: 

set tu enable 

then assign to file 

attach tu0 magtape.bin 

In OPR these are the useful commands: 

OPR\>**show statUS tapE-DRIVE**   
OPR\>   
13:45:25 \-- Tape Drive Status \-- 

Drive Trk Status AVR Density Write Volume \------ \--- \----------- \--- \------------- \------- \------  
MTA000 9 Online Yes 1600 Enabled   
MTA001 9 Free Yes 800/1600   
MTA002 9 Free Yes 800/1600   
MTA003 9 Free Yes 800/1600 

**Using the tape drive** 

Here is how I mounted a tape and wrote a single file to it: 

At terminal I typed: 

.mount mt: /scratch 

\[Mount request MT-Q0RFXI queued, request \#25\] 

Note that MT is a logical name for my session, it can be anything. 

This produces a tape mount request on the console: 

15:24:27 \-- Magtape mount request \#25 \--   
 User: PUBLIC \[42,42\] Job \#12   
 Volume-set name: MT-Q0RFXI 

 Volume-ID Write Labels Track Density   
 \--------- \------- \------ \----- \-------   
 Scratch Enabled No 9 1600 

The tape is assigned to a file using the emulator’s ATT command. 

sim\> att tu0 mag3.bin   
TU: creating new file 

When you restart the emulator, the console will report it cannot read the tape label: 

15:22:28 \<14\> Device MTA000 \-- Label error \--   
 Can't read this tape's labels on this drive  Type 'RESPOND \<number\> ABORT' to unload the tape on MTA000  Type 'RESPOND \<number\> PROCEED' to treat the tape on MTA000 as u 

nlabled 

Respond with proceed to make this tape unlabeled: 

OPR\>respond 14 proceed   
15:22:53 Device MTA000 \-- Unlabeled volume mounted \--  Density 1600 BPI, write-Enabled 

To assign this tape to the user, you must first identify the volume on the tape drive. At console I typed: 

OPR\>ident mta0: volume-id scratch   
15:26:30 Device MTA000 \-- Unlabeled volume SCRATC mounted \--  
Now you can assign the tape drive/volume to the mount request: 

OPR\>ident mta0: request 25   
15:27:40 Device MTA000 \-- Volume SCRATC reassigned \--  User: PUBLIC \[42,42\] Job \#12 

Back at the terminal, the mount request will now complete and you can copy a file to the psuedo dev: 

\[Magtape SCRATC mounted on MTA000 with logical name MT\] 

now to copy a file to the tape drive, I type: 

.copy mt:=myfile.txt 

then dismount the tape: 

.dismount mt: 

\[MTA000 dismounted\] 

**Misc Tape Commands** 

To Create an unlabeled blank tape: 

OPR\>SET TAPE MTA0: INIT /LABEL-TYPE:UNLABELED   
OPR\>   
14:58:53 Device MTA000 \-- Volume initialized \--   
 Unlabeled tape, Density:1600 

14:58:53 Device MTA000 \-- Volume initialization complete \--  Drive is available for use 

14:58:53 \<12\> Device MTA000 \-- Label error \--   
 Can't read this tape's labels on this drive  Type 'RESPOND \<number\> ABORT' to unload the tape on MTA000  Type 'RESPOND \<number\> PROCEED' to treat the tape on MTA000 as u 

nlabled   
OPR\>RESPOND 12 PROCEED   
OPR\>   
14:59:07 Device MTA000 \-- Unlabeled volume mounted \--  Density 1600 BPI, write-Enabled 

To dismount a tape 

dismount tape-drive mta0: 

To cancel a tape mount request: 

In OPR:   
cancel mount-request \*  
**Full Backup:** 

.MOUNT MT:/SCRATCH /NOWAIT   
{note the request \#}   
.r opr   
{request \# will show up in OPR}   
^E {get into simulator}   
\>att tu0 fullbackup-yymmnn.tap   
\>g   
{IF OPR shows label error reading tape:}   
\>RESPOND \<n\> PROCEED   
{OPR responds \--unlabeled vol mounted--}   
\>ident mta0: volume-id scratch   
{Opr responds \--unlabeled vol SCRATC mounted--}   
\>ident mta0: request \<n\>   
{OPR responds \--volume SCRATC reassigned--}   
\>exit {OPR} 

{tape is now ready to be written to} 

. R BACKUP \<RET\> Run the BACKUP program.   
/TAPE MT: \<RET\> Identifies logical tape MT.   
/REWIND \<RET\> Rewind to the beginning of the tape. /LIST DSK: \<RET\> Request a directory listing of disk. /SAVE DSKB: \<RET\> Save system disk. 

\!\~DSKB BACKUP prints each UFD as it begins to save files from that area. 

"Done The SAVE is complete.   
/exit   
.dismount mt: 

**Backup Utility** 

See Operators Guide, App E for full explanation. 

before invoking mount a tape such as: 

mount mt: /scratch /nowait 

then go into OPR to assign a tape to the request as described in the section on accessing tape. 

To invoke backup: 

.r backup 

To specify a tape: 

/tape mt: 

To backup: 

/save \<spec-list\>  
save myfile.txt   
save myfile.\*   
save \*   
save \*\[1,2\]   
save dskb: {system drive}   
save \[42,42,\*\] 

To restore 

/restore \<spec-list\> 

restore dskc:myfile.txt\[42,42\] note \- do a /rewind before the restore To validate backup: 

/check \<spec-list\> 

To print the tape directory: 

/\[N\]Print \<spec\> {N means narrow, \<spec\> is the output file name} **To Compile** 

compile \<filename\> \[/compile\]\[/list\] 

exe \<filename\> is generally enough \- it will compile only if necessary, link, then run. use exe \<filename\> /compile/list as well. 

**Get info on mounted hard drives** 

OPR\>**show stat str**   
OPR\>   
13:20:57 \-- Disk File Structures \-- 

Name Time Free Mount \#Req Volume Type Drive Owner PPN \---- \------ \-------- \----- \---- \---------- \---- \------ \------------- DSKB 0:40 2230 2 0 ONC312 1/1 RP06 RPA0 

DSKC 0:40 289350 3 0 HELLO 1/1 RP06 RPA1   
 Total of 2 file structures, 2 mounted; 291580 free blocks 

OPR\>**show status disk-DRIVE**   
OPR\>   
13:23:15 \-- Disk Drive Status \-- 

Drive Type Status AVR STR Volume Unit\#   
\------ \---- \----------- \--- \----- \------ \-----   
RPA0 RP06 Mounted Yes DSKB ONC312 0   
RPA1 RP06 Mounted Yes DSKC HELLO 0   
RPA2 RP06 Free Yes   
RPA3 RP06 Free Yes   
RPA4 RP06 Free Yes   
RPA5 RP06 Free Yes  
RPA6 RP06 Free Yes   
RPA7 RP06 Free Yes 

**Subdirectories** 

To create: 

.r credir 

Create directory: \[42,42,PASCAL\] 

Protection: 057 

Name: PASCAL 

Allocation:  

 Created DSKC0:\[42,42,PASCAL\].SFD/PROTECTION:057 Create directory: ^C 

.DIR PASCAL.\* 

PASCAL LOG 100 \<057\> 21-Sep-11 DSKC: \[42,42\] PASCAL DOC 29 \<000\> 5-Sep-77 

PASCAL EXE 220 \<000\> 5-Sep-77 

PASCAL MAN 40 \<000\> 5-Sep-77 

PASCAL REL 51 \<000\> 5-Sep-77 

PASCAL SFD 1 \<057\> 21-Sep-11 PASCAL  Total of 441 blocks in 6 files on DSKC: \[42,42\] 

**To delete a directory** 

First, you must empty the directory: 

.del \*.\*\[,,oldpas\] 

Files deleted: 

DSKC:PASCAL.DOC  

DSKC:PASCAL.EXE  

DSKC:PASCAL.MAN  

DSKC:PASCAL.REL  

340 Blocks freed 

.del oldpas.sfd 

Files deleted: 

DSKC:OLDPAS.SFD  

01 Blocks freed 

**Restoring from DECUS Tape** 

Decus tapes are found at: 

http://pdp-10.trailing-edge.com/  
Had to do the restore the tape from console into end-user’s dir .r backup   
/tape pascal   
/rewind   
/protection 775   
/restore dskc:\[42,42,pascal\]=all:\*.\*\[43,50531\] 

**Change file protection (including subdirs)** 

.protect pascal.sfd\<775\> 

Files renamed: 

DSKC:PASCAL.SFD  

**Pascal** 

I was able to restore pascal from Pascal-declib10.tap. All of the files are in \[42,42,pascal\]. I moved the critical files to SYS: so they will work for all. 

**Adventure** 

The initial game came on advent.tap. I restored that into \[42,42,advent\]. I copied that into \[42,42\] to play with. Compile with: 

.COMPILE ADV.F4 

FORTRAN: ADV 

.COMPILE IOFIL.FOR 

FORTRAN: IOFIL 

and link with: 

.LOAD ADV.REL,IOFIL.REL 

LINK: Loading 

EXIT 

.EXE 

LINK: Loading 

\[LNKXCT ADV execution\] 

PAUSE 

INIT DONE  

Type G to Continue, X to Exit, T To Trace. 

\*G 

WELCOME TO ADVENTURE\!\! WOULD YOU LIKE INSTRUCTIONS?  or save with   
.save adv.exe 

ADV saved 

and run with  

.run adv.exe 

WELCOME TO ADVENTURE\!\! WOULD YOU LIKE INSTRUCTIONS?  

I also doctored ADV.DAT so each line starts with X instead of 0 so that CCTL works correctly. 

Note: I didn’t make any changes to the source, so I deleted it from \[42,42\]. I copied adv.exe and adv.dat to sys: 

To run from SYS, just type “r adv” and respond as follows: 

.**r adv** 

?FRSNAM OPEN unit 1 DSK:ADV.DAT at IFILE+14 (PC 73033\)   
?FRSOPN Can't OPEN file: No such file   
\[FRSEFS Enter correct file specs\]   
\***sys:adv.dat**   
PAUSE   
INIT DONE    
Type G to Continue, X to Exit, T To Trace.   
\***g**   
WELCOME TO ADVENTURE\!\! WOULD YOU LIKE INSTRUCTIONS?  

**kermit** 

You can xfer files between PC and emulator using kermit. I have had luck transferring ASCII files but not binary.  

Start kermit on the dec-10: 

.r kermit 

TOPS-10 KERMIT version 3(136) 

make sure you enter this command or the transfer might act like it is working, but it isn’t really: 

Kermit-10\>set file byte-size 36-bit 

Kermit-10\>server 

\[Kermit Server running on the DEC Host. Please type your escape sequence to return to your local machine. Shut down the server by typing the Kermit BYE command on your local machine.\]  
In reflections File | transfer and make sure protocol is kermit and transfer type is binary: ![][image1]  
Ascii files seem to work fine in both directions. Something goes wrong with binary files but I can’t tell what. 

**SYSANS** 

This is like top in linux.  

**REACT** 

Used to manage users. 

**Changing Directory** 

To change to subdir pascal: 

.r setsrc 

\*dir 

?ILLEGAL COMMAND 'DIR' 

\*help 

Src.Lst.Commands: C M A R T LIB NOLIB SYS NOSYS NEW NONEW 

Sys.Src.Lst.Commands: CS MS AS RS TS 

Path Commands: CP TP SCAN NOSCAN 

File Str. Switches: /WRITE /NOWRITE /CREATE /NOCREATE 

Src.Lst.Switches: /LIB:\[ppn\] /NOLIB /SYS /NOSYS /NEW /NONEW Path Switches: /SCAN /NOSCAN 

\* \= Current Src.Lst. 

For complete description type monitor command 'HELP SETSRC' \*cp \[,,pascal\] 

to change back to main dir:  
cp \[,\] 

**Labeled Tapes** 

Using labeled tapes is kind of easier. 

First mount the tape using simh. Note that mounting labeled tapes defaults as read-only (locked) and if your request doesn’t match the real status of the write-ring, you won’t get assigned the tape. 

sim\> att tu0 clisp.tap   
sim\> set tu0 locked 

If opr doesn’t automatically recognize the tape, ‘recognize’ it: 

OPR\>rec mta0   
OPR\>   
15:35:42 Device MTA000 \-- Volume CLISP mounted \--   
 ANSI labels, 1600 BPI, write-Locked 

Note that this tape is called CLISP, has ANSI labels and is read-only. 

Now the user mounts the tape. Note the volume is “CLISP” which must be specified. The only reel-id (inside parens) I’ve been able to get to work is also CLISP. Also match up the label types and if the tape is read or write: 

.mount clisp(clisp)/label:ansi/read 

\[Mount request CLISP queued, request \#28\] 

\[Magtape CLISP mounted on MTA000 with logical name CLISP\] 

**To get rid of irritating beeps on console window** 

net stop beep 

**sys:sysjob.ini** 

Edit this job to add sprint. Sprint is needed to read batch decks using submit/reader.

[image1]: <data:image/png;base64,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>