# utexas decwar notes

## sections

- [1, boot disk](sec1-boot-disks.md)
- [2, kermit](sec2-kermit.md)
- [3, prep source files](sec3-prep-source-files.md)
- [4, building decwar](sec4-compiling-decwar.md)
- [4a, build files](sec4a-build-files.md)
- [4b, continuation line issue](sec4b-continuation-line-issue.md)
- [5, minimalist walkthrough](sec5-minimalist-walkthrough.md)
- [6, scripted tops10 setup](sec6-scripted-tops10-setup.md)
- [7, decwar tape file](sec7-decwar-tape-file.md)
- [8, f66 vs f77](sec8-f66-vs-f77.md)
- [9, utexas primordial tape reconstruction](sec9-utexas-primordial-tape.md)

## appendices

- [0, foundations](app0-foundations.md)
- [1, tops10 versions](app1-tops10-versions)
- [2, tap files](app2-tap-files.md)
- [3, sos](app3-sos.md)

# utexas tops10 users guide

- [create a standard user](#create-user)
- [create a default account template](#account-template)
- [manage user accounts](#user-accounts)
- [mount a tape](#mount-tape)
- [restore a tape](#restore-tape)
- [create a new subdirectory](#create-subdirectory)
- [access a subdirectory](#access-subdirectory)
- [why is there no bcl: device on my system](#bcl-device)
- [why won’t the tops10 system printer work](#system-printer)

<a name="create-user">
how do i create a standard user?
</a>

first ensure that there is a default user template. see the faq for that. next run the user account management utility react and insert a new user ppn following the example below. you will need to be on the opr account to do this.

    .r react
    react>ins [27,101]
    [readpl default profile loaded: [%,%]]
    new user name: test
    user>done
    user [27,101] test inserted with password yebowupuc
    a total of one user inserted
    react>exit

now login to the new user account using login and the password generated above.

    .login test
    job 3 pdp10 tty0
    password:
    %lgnpcr a password change is required by the system administrator
    new password:
    verification:
    [lgnphc password has been changed]
    16:37 28-mar-118 wednesday
    your user account is now ready for use.


<a name="account-template">
how do i create a default account template?
</a>

start the react utility and follow the recipe below. i have been choosy about access-types, you could just use all if you aren’t worried about how your system’s users can access the system and its resources:

    .r react
    
    react>ins [%,%]
    user>login-times
    login-times>all
    login-times>show
    weekdays 0:23 weekends 0:23
    login-times>done
    user>struct
    structure-quotas>add dskb infinite
    structure-quotas>show
    
    structure quota in quota out reserved status
    --------- ----------- ---------- ---------- ----------
    dskb -infinite- -infinite- 0
    structure-quotas>done
    user>access-types
    access-types>local
    access-types>remote
    access-types>batch
    access-types>subj
    access-types>show
    local, remote, subjob of batch, batch
    access-types>done
    user>core
    user>show core
    physical 512, virtual 512
    user>con 30 1000
    user>ipcf 511 511 511
    %reariq reducing ipcf send quota from 511 to 511
    %reariq reducing ipcf receive quota from 511 to 511
    %reariq reducing ipcf pid quota from 511 to 511
    user>enq 511
    user>req
    requirements>change pass both
    requirements>pass both
    requirements>show
    
    account and remark strings are not required
    name is not required
    password under timesharing and batch
    password change at next login
    minimum password length: -none-
    password change interval: -none-
    password changes are allowed
    requirements>done
    user>done
    react>show [%,%]
    
    ppn: [%,%]
    user name: *-default
    profile default: [777777,%] or [%,%]
    * personal name: -none-
      * distribution location: -none-
      * mailing address: -none-
    
      * expiration date: never
      login times: weekdays 0:23 weekends 0:23
      access types: local, remote, subjob of batch, batch
      requirements for login:
      account and remark strings are not required
      name is not required
      password under timesharing and batch
      password change at next login
      minimum password length: -none-
      password change interval: -none-
      password changes are allowed
      * schedular type: 0
      * program to run: -none-
    
      * context-quotas: contexts 30, total pages 10000
      * core limits: physical 512, virtual 512
      * enq/deq quota: 0
      * ipcf quotas: send 511, receive 511, pids 511
      * privileges: -none-
      * spooled device bits: -none-
      * watch bits: -none-
    
    structure quotas:
    structure quota in quota out reserved status
    --------- ----------- ---------- ---------- ----------
    dskb -infinite- -infinite- 0
    
    administrative data:
    profile last changed by [1,2] at 28-mar-18 16:17:04
    last access -never-
    last password change at 7-feb-18 22:05:09
    
    a total of one user listed
    react>exit

you should now have a default user who can login, is forced to change/set a password on first login, has access to the disk storage and can submit batch jobs. there are infinite quotas on the disk and the maximum core use is 512 pages. this is very generous, but unless you are intending on running a real timesharing service this will probably be the best options as it will put the lowest number of barriers in place for a user to do things.

<a name="mount-tape">
how do i mount a tape?
</a>

if you need to mount a tape from a operational tops10 system as a user, use a command similar to the following:

    .mount tape:/reelid:label/nowait

the reeled: parameter specifies the tape label.

this will queue the tape mount request and the opr console will then need to action the request.

when using simh you will need to attach the tape file on the console and respond to the opr console.

    14:44:01 -- magtape mount request #4 --
    user: opr [1,2] job #2
    volume-set name: tape
    
    volume-id write labels track density
    --------- ------- ------ ----- -------
    bcpl locked no 9 1600
    opr>
    simulation stopped, pc: 000001 (sojg 6,1)
    sim> att tu0 tapes/bcpl.tap
    sim> set tu0 lock
    sim> c
    
    14:44:16 device mta0 -- unlabeled volume mounted --
    density 1600 bpi, write-locked
    
    opr>sho que
    opr>
    14:44:53 -- system queues listing --

    mount queue:
    volume status type write req# job# user
    ------- -------- -------- ------- ------ ---- -------------------
    bcpl waiting magtape locked 4 2 opr [1,2]
    volume-set: tape
    label-type: no, tracks: 9, density: 1600 bpi
    there is 1 request in the queue
    opr>ide mta0: re 4
    opr>
    14:45:04 device mta0 -- volume bcpl reassigned --
    user: opr [1,2] job #2

your tape should now be mounted on the system and accessible through tools such as backup.

<a name="user-accounts">
how do i manage user accounts?
</a>

as the opr you can manage user accounts with the react utility. this utility allows you to create, delete, and modify user accounts and their attributes. you would normally use this for creating a standard user account. before creating any standard user accounts it is a good idea to create a system wide user account template first so that any new accounts inherit some standard attributes such as the ability to login on a terminal. to execute react just type:

    .r react
    react>

the react> prompt is where you can enter into a dialog about user accounts. help works in this dialog.

<a name="restore-tape">
how do i restore a tape?
</a>

first mount the tape, see the faq on how to do this.

second use the backup utility to restore the files from tape. backup uses “/” as a prompt.

    .r backup
    /tape tape:
    /rewind
    /protection 155
    /files
    /restore dsk:=*.*

you will then get a list of files and directories being restored to your disk, at the end of which your will see the following to which you type ctrl-z to exit from backup:

    "done
    /^z
    .dismount tape:
    [mta0:bcpl read(c/h/s) = 2173280/0/0]
    [mta0 dismounted]

you will now find the files in the directory you were using when you ran backup.

<a name="create-subdirectory">
how do i create a new subdirectory?
</a>

to create a new sfd (subdirectory) in your own ppn you use credir:

    .r credir
    create directory: [,,bcpl]
    created dskb0:[27,100,bcpl].sfd/protection:775
    create directory: ^z
    .dir
    hello bas 1 7-feb-18 dskb: [27,100]
    bcpl sfd 1 28-mar-18
    total of 2 blocks in 2 files on dskb: [27,100]

<a name="access-subdirectory">
how do i access a subdirectory?
</a>

you can either include the subdirectory in the command ppn argument or change your working directory to where you want to be.

to include the subdirectory in the command, simply append it after a comma in the ppn argument. eg:

    .dir [,,mud]

to temporarily change your working directory for a series of actions, use setsrc as follows:

    .r setsrc
    *cp [,,bcpl]
    *^z
    exit

to return to your ppn just reference it with a ppn of [,] in any command.

<a name="bcl-device">
why is there no bcl: device on my system?
</a>

bcpl needs to have a bcl: ersatz device to function effectively. you can use the path command to set one up on a use by use basis, but the recommended solution in the bcpl documentation is to configure a permanent ersatz device in mongen. this is how you do it based on the tops10 configuration i am running. the key piece is the ersatz device line towards the end of the mongen program dialog:

    .r mongen
    write mongen.mic (yes,no) : n
    mongen for 704 monitors

mongen will generate any known tops10 configuration. for information
about which configurations are supported, please refer to the spd.

    /help (prompt,short,long) ]: prompt
    which gen (sys,f) : s
    output(dsk:syscnf.mac):
    decsystem10 (kl,ks) : ks
    system name : pdp10
    cpu0 serial number (1-10000) : 4097
    exclude monitor overhead from user run time (yes,no) : y
    account verification (yes,no) : n
    
    autoconfigured device options:
    include ethernet service (no,yes,prompt): n
    prompt for rp0x/rm0x massbus disks (no,yes): n
    include tm02/tm03 magtapes (no,yes,prompt): y
    include unibus/lp20 printers (no,yes,prompt): y
    include unibus/cd20 card readers (no,yes,prompt): n
    
    local terminal configuration:
    dz-11 tty lines (0-32) : 32
    
    opr octal line number (cty,0-37) : cty
    data set lines
    
    number of jobs (1-511) : 127
    maximum pages of core for each job (0,0-16384) :
    total amount of system core in k (512-4096) : 1024
    clock ticks per second (60,50) : 60
    allow jobs to be locked in core (yes,no) :
    guaranteed number of pages for unlocked jobs (0,0-16384) :
    number of pages reserved for locking jobs in exec virtual memory (10,0-?) :
    number of high priority interrupt queues (0,0-15): 15
    meter (no,yes) :
    kaser (no,yes) :
    mpxser (yes,no) :
    psiser (yes,no) :
    ipcf (yes,no) :
    enq/deq (yes,no) :
    disk sets (all) :
    configure non-autoconfigured hardware (no,yes) :
    number of kmc/dup lines (0,0-2) :
    number of ptys (20,1-476) :
    
    network software (yes,no) : n
    
    decimal "symbol,value"
    
    octal "symbol,value"
    
    sixbit "symbol,value"
    
    type "device-mnemonic,pi-channel" for special devices
    
    type "device-mnemonic,pi-channel,no.-of-devices"
    
    type "device-mnemonic,pi-channel,highest-ac-to-save"
    
    type "ersatz-device,p,pn,search-list-type"
    bcl,5,24,sys
    
    type "command-name,dispatch,flags,unique-bits,prvtab-name"
    
    terminal class :
    
    additional terminals for classes:
    
    class to extend :
    
    system default terminal type (tty) :
    file dsk:syscnf.mac closed
    
    which gen (sys,f) : f
    output(dsk:f.mac):
    feature set (kl10,ks10) : ks10
    standard settings (yes,no) :
    file dsk:f.mac closed
    
    which gen (sys,f) : ^z
    
    exit
    
    .compile/compile f,s
    macro: f
    macro: s
    
    exit
    
    .compile/compile devprm,dteprm,netprm,d36par
    macro: devprm
    macro: dteprm
    macro: netprm
    macro: d36par
    
    exit
    
    .compile/compile syscnf+
    macro: common
    macro: comdev
    macro: commod
    
    exit
    
    .r link
    
    *sys2/save/noinitial/hash:13k = /locals -
    #common,comdev,commod,tops10[10,7,mon,ks]/search-
    #/patch:200/counters/go
    [lnkrlc reloc. ctr. initial value current value limit value
    .low. 0 64443 344000
    .high. 344000 607662 720000
    .init. 740000 764722 771000
    .twic. 771000 772401 1000000
    absolute code loaded]
    
    exit
    
    .

this has now created a new system monitor in [10,7,mon] called sys2.exe which should now include the bcl: ersatz device. you will need to boot from this new system monitor and also create a ppn of [5,24] to be the directory for the bcl: ersatz device.

<a name="system-printer">
why won’t the tops10 system printer work?
</a>

assuming you are using simh to run your tops10 install on, you need to make sure the following lines are in your simh script or entered on the simh console before booting tops10.

    att lp20 printer.out
    set lp20 enable

all printer output will now go to a file called printer.out in the directory to start simh in.

next you need to make sure that tops10 has started the printer and the spooler. to do this ensure that system.cmd has the following:

    set printer 0 page-limit 2000
    start printer 0

you may not need to do the next step as the galaxy system should just start the spooler when it is need, but for completeness i did do this. in the sysjob.ini ensure the following lines are included:

    lptspl
    log

finally you need to ensure there is a forms descriptor for the printer in lpform.ini

    .type sys:lpform.ini
    normal/banner:1/header:1/trailer:1/width:136/lines:66/ram:lp96

this should allow output to be queued for printing and then appear in the printer.out file on the host.

i found that there may be an issue if you do not have a non-zero anf-10 node number and networking enabled. in this case the system does not appear to correctly assign the device to printer 0. in this case, you need to manually assign the device as follows in opr or amend the system.cmd to include the /device switch on the start printer command.

    opr>shutdown printer 0
    opr>
    13:30:18 printer 0 -- shutdown --
    opr>start printer 0/device:lpt0
    opr>
    13:30:41 printer 0 -- startup scheduled --
    opr>

if you then send something to the printer it should just work. the more comprehensive fix to this is to setup anf-10 and give yourself a nod number greater than 0. the printer device identifier will then become lptn00 where n is the anf-10 node number, and this is supposed to fix the automatic start but i have not tested that. the simplest solution is just to put start printer 0/device:lpt0 in the system.cmd
