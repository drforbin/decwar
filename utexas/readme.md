# utexas decwar

historic fortran and assembly code running on simh pdp10 and standard tops10
- player instructions for [june 3, 1980 v2.2 utexas](docs/decwar22-utexas.md)
- player instructions for [november 20, 1981 v2.3 compuserve](docs/decwar23-compuserve.md)
- [decwar wikipedia page](https://en.wikipedia.org/wiki/Decwar)
- catalog item [v2.2](https://repositories.lib.utexas.edu/items/1aa48343-09ab-4b3b-a9f2-e2e525074a4d), [utexas center for american history](https://briscoecenter.org/)
- catalog item [v2.3](https://repositories.lib.utexas.edu/items/7e2ccf50-e814-4bce-91d2-a7f6440eabe4), [utexas center for american history](https://briscoecenter.org/)
- 1982 letter from utexas to compuserve, included on the primordial decwar tape as [DECWAR.LTR](utexas23-reconstruction/hlp/DECWAR.LTR)

decwar evolved across the seventies. eric raymond has done lots of excellent work around the single player side of that whole story, http://www.catb.org/~esr/super-star-trek/ and https://gitlab.com/esr/super-star-trek. nutshell summary for decwar context, rough timeline am detecting so far, thanks to feedbacks from merlyn, ron, etc.

- 1971, original single player star trek, written in basic for ucal irvine sds sigma 7, mike mayfield
- 1972, rewrite of original, basic for hp 2000c at hp office near ucal irvine, mike mayfield
- 1973, ut trek, written in basic, grady hicks and jim korp at utexas
- 1974, ut fortran, aka 'super star trek', single player fortran on utexas cdc 6600, dave matuszek and paul reynolds
- mid 70s, war, fortran two player version written for utexas cdc 6600, author unknown, rewritten by robert schneider
- 1978, decwar, assembly and fortran, eighteen player version written for utexas pdp-10, bob hysick and jeff potter

[1971 star trek](https://en.wikipedia.org/wiki/Star_Trek_(1971_video_game)) In 1971, Mike Mayfield, then in his final year of high school, frequented a computer lab at the [University of California, Irvine](https://en.wikipedia.org/wiki/University_of_California,_Irvine), while teaching himself how to program. The lab operated both a [SDS Sigma 7](https://en.wikipedia.org/wiki/SDS_Sigma_series) and a [DEC PDP-10](https://en.wikipedia.org/wiki/PDP-10) [mainframe computer](https://en.wikipedia.org/wiki/Mainframe_computer). The PDP-10 hosted a copy of [Spacewar!](https://en.wikipedia.org/wiki/Spacewar!), a multiplayer space combat video game developed in 1962 in the [early history of video games](https://en.wikipedia.org/wiki/Early_history_of_video_games). Mayfield had gained illicit access to the Sigma 7 at the lab and wanted to create his own version of the game for the system. Spacewar! required a [vector graphics](https://en.wikipedia.org/wiki/Vector_graphics) display, however, and the Sigma 7 only had access to a non-graphical [Teletype Model 33](https://en.wikipedia.org/wiki/Teletype_Model_33) ASR [teleprinter](https://en.wikipedia.org/wiki/Teleprinter).

[1978 decwar](https://en.wikipedia.org/wiki/Decwar#Original_versions) Version 1.0 of DECWAR was released in August 1978. The university would make copies available on tape for the nominal fee of $50, and it soon appeared on PDP-10s around the world. The greatly updated 2.0 was released in July 1979, and another major version, 2.3, on 20 November 1981. concerning the [utexas center for american history](https://briscoecenter.org/) catalog items and 
 
utexas center for american history catalog item [v2.2](https://repositories.lib.utexas.edu/items/1aa48343-09ab-4b3b-a9f2-e2e525074a4d) has files migrated from a Decus magnetic tape, including a somewhat doubtful patched executable, but no source code. here's the instructions a utexas player saw [june 3, 1980 v2.2 utexas](decwar22-utexas.md). eighteen playable ships, this is also what players at the southwest texas state university computation center, san marcos texas, saw circa 1983 and 1984

                 Federation ships               Empire ships
                 ----------------               ------------
                    Excalibur                     Buzzard
                    Farragut                      Cobra
                    Intrepid                      Demon
                    Lexington                     Goblin
                    Nimitz                        Hawk
                    Savannah                      Jackal
                    Trenton                       Manta
                    Vulcan                        Panther
                    Yorktown                      Wolf

utexas center for american history catalog item [v2.3](https://repositories.lib.utexas.edu/items/7e2ccf50-e814-4bce-91d2-a7f6440eabe4), has files ported by Merlyn Cousins from Harris Newman's Decwar 2.3 source code to a Simh/Tops 10 emulator environment. Newman's 2.3 version reflected changes made to the UT-developed Decwar, which were made so the game could be installed on a Compuserve (CIS) system, circa 1981. here's the instructions a compuserve player saw [november 20, 1981 v2.3 compuserve](decwar23-compuserve.md). compuserve modified the code, limiting to ten playable ships

                 Federation ships               Empire ships
                 ----------------               ------------
                    Lexington                     Cobra
                    Nimitz                        Demon
                    Savannah                      Hawk
                    Vulcan                        Jackal
                    Yorktown                      Wolf

# project utexas

thanks to merlyn cousins, there's a [working decwar](https://github.com/drforbin/decwar). it's a little different than the primordial utexas decwar however. [project utexas](https://github.com/drforbin/decwar/tree/utexas/utexas) is about reconstruction of the original, converging nearer and nearer towards the primordial code and effectively going backwards in time. if a copy of the original code is discovered, it will hopefully match closely with the utexas reconstruction.

the first reconstruction concerns where the game is installed. at utexas the players typed 'r gam:decwar' and the virtual device 'gam:' was assigned to ppn [5,30]. the install involved commands like 'copy [5,30]decwar.exe<055>=[10,7]decwar.exe' and 'assign gam: dskb:[5,30]'. the tape contents were originally copied into [10,30] and compiled and linked there, you can see that in this [primordial tape listing](https://github.com/drforbin/decwar/blob/utexas/utexas/utexas23-reconstruction/hlp/DECWAR.TAP). for now, project utexas is looking at using [10,7] as it matches with install scripts for fortran, kermit, etc in the utexas simh folder. meanwhile, utexas is simply copying tape contents directly into [5,30] then compiling and linking 'in place'.

compuserve changed the target install directory. they had players coming from various host machines across their network. they brought the players to a central machine with the game installed in [1,27] using commands like 'copy [1,27]decwar.exe<055>=[10,7]decwar.exe'. the players effectively did 'r [1,27]decwar', without a virtual device like 'gam:'.

it's a bit amazing and not completely clear yet why changing this back was so straightforward. problems were expected because compuserve additions to the source code do in fact reference [1,27]. it's possible that the current tops-10 configuration in project utexas has something to do with it. it's suspected that the monitor security system is in some sense not fully activated. parts of rcornwell's baseline simh scripts were intentionally left off for a more 'tmp/dev' environment. the objective is not a production tops-10 environment, rather a more loose and free sandbox. maybe that's why install in [5,30] 'just works'?

the second reconstruction is even more amazing. at utexas there were up to eighteen players. compuserve changed that to ten players, effectively halving the resources used. since decwar lives in both high and low segment core memory, that was probably a serious concern for their commercial production environment.

the reconstruction was straightforward again, and worked on basically the first try. utexas decwar has eighteen ships and players can again captain 'the buzzard'!

# utexas structure

- docs, various howto and note related docs accumulating around the project
    - msc folder, miscellaneous useful docs collected from the internet
    - utexas22 folder, interesting reading from the v22 catalog item discussed above
- msc, miscellaneous shell scripts and related code
- simh, simh scripts
- utexas23-reconstruction, a reconstruction attempt, at least on the surface layers, of the primordial utexas tape received by compuserve
    - hlp folder, help.com comment file. note decwar.imp important file!
    - msc folder, msc.com comment file.
    - tec folder, for teco files to autogen fortran include files
    
# utexas in action

baseline situation is to be on a raspberry pi that is/can be used for the pidp-10 stuff. pidp-10 is not necessary, but simply guessing most decwar will be associated with pidp-10 raspi. then also have a local clone of the decwar repo. checkout/be in the utexas branch. and 'in the utexas folder' within the utexas branch. so you're seeing the git tracked files, this is the 'utexas folder'. now you want to add some relatively large and static binary files that aren't included in the git tracking, these are downloaded as an archive in the step1.

### step1 have the contents of the downloadable archive in your utexas folder

the script msc/create-archive-project-utexas was used to create project-utexas-archive-20250506.tar.gz. download the archive by hitting this [archive link](https://drive.google.com/file/d/1aLbaDcyIBG6pUwKbhw9UbuXFTfXkR1Cd/view?usp=sharing) and dearchive the contents and have them placed in your utexas folder
- dec10blinken simh exe that will drive console panel if you have one
- dec10 simh exe that is plain vanilla and does not drive console panel
- dec10test simh exe that is just for testing console front panel
- back10 exe that handles writing and listing tapes
- tapes folder with tape images
- bts folder with kl-10 boot loader exe needed by the simh scripts
    
### step2 prep boot disk

    ./dec10blinken simh/create-boot-disk-from-tape.ini
    
this is no big deal, can do it repeatedly and often, can treat the disk as replaceable/expendable. the simh ini script is a good resource for learning about tops-10. the disk will appear as folder dsk. the script should leave you at tops-10 monitor prompt. do kjob to log out, ctrl-e to get simh prompt, quit to leave simh.

### step3 prep tape file

    msc/create-tape-utexas23-reconstruction

this bash script will copy the decwar source code into tape file tapes/utexas23-reconstruction.tap and do a listing of the tape, showing the contents as confirmation.

### step4 boot from disk

    ./dec10blinken simh/boot-from-disk.ini

have the line 'do utexas.do' uncommented in the ini file to install/reinstall utexas. simh 'expect' usage is not yet top-notch and there are some hacky workarounds. it should finish by setting permissions on decwar exe so its playable by all and assigning the gam: device. 

### step5 telnet in

    $ telnet localhost 2030
    Trying ::1...
    Connected to localhost.
    Escape character is '^]'.
    Connected to the KL-10 simulator TTY device, line 0
    KL703 11:01:21 TTY4 system 1025
    Connected to Node KL10(1) Line # 4
    Please LOGIN
    .login demo
    Job 3  KL703  TTY4
    11:01   19-Mar-86   Wednesday
    .r gam:decwar
    DECWAR, Edit    16
    [DECWAR Version 2.3, 20-Nov-81]

you can use the above to telnet in from multiple terminals and start the game as several players on both sides, then try the radio, phasers, torpedoes, shields, etc.

# primordial utexas tape reconstruction

there were seven key 'non include' code files. the high.for and low.for are stubs, and somewhat likewise for msg.mac and setmsg.mac.
    
    DECWAR.FOR  FORTRAN source.
    WARMAC.MAC  MACRO source.
    SETUP.FOR   Once only code, deleted from core after initialization.
    HIGH.FOR    Used to force common block into high segment.
    LOW.FOR     Used to force common block into low segment.
    MSG.MAC     Output text source.
    SETMSG.MAC  Equivalent to MSG.MAC for SETUP text strings.

six include files. five teco scripts in the tec folder originally were used to autogen five of the six.

    lowseg.tec -> lowseg.for
    hiseg.tec  -> hiseg.for
    param.tec  -> param.for
    extern.tec -> extern.for
    setext.tec -> setext.for
                  lstvar.for, this is also an include file, but without teco autogen

probably the scripts simply search through warmac.mac and pick out 'variables' that need to appear in the include for files. this can be done manually. if there's an update to warmac.mac, include for files can be manually updated. the teco scripts probably just automate this, generating the include for 'from scratch'. so it's not a 'must have'. can be done by hand. but possibly nice. and an interesting usage of teco.

at utexas the build was done in [10,30,decwar] and then deployed to gam: which was a 'logical device name' assigned to [5,30]. 10,30 seems to have been the 'dist' account, which is 10,7 for many simh scripts. let's just accept that dist is [10,7] now, not [10,30]. this allows leaving many simh scripts as is.

# notes

v2.2 31 commands - bases, build, capture, damages, dock, energy, gripe, help, impulse, list, move, news, planets, points, quit, radio, repair, scan, set, shields, srscan, status, summary, targets, tell, time, torpedoes, tractor, type, users

v2.3 31 commands - apparently, zeroth order, same as v2.2

there was a 'micro script' l.mic used to drive the linker. micro is evidently something inbetween teco and macro? any case, it seems a bit obscure for today, but the following is clearly the crucial parts for linking, these are linker commands, entered at the r link * prompt

    low/seg:low
    high/seg:hi
    decwar/seg:def
    msg
    warmac
    sys:forlib/sea/seg:def
    setup/seg:low
    setmsg
    sys:forlib/sea/seg:low
    decwar/ssave
    /g

this absolutely does work, after the little trick of first doing

    decwar/save

then the remainder from low/seg:low
