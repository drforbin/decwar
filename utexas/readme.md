# utexas decwar

historic fortran and assembly code running on simh pdp10 and standard tops10. there's history around the early parts of the story [esr1](http://www.catb.org/~esr/super-star-trek/) and [esr2](https://gitlab.com/esr/super-star-trek), and [decwar itself](https://en.wikipedia.org/wiki/Decwar). nutshell summary

- 1971, [original single player star trek](https://en.wikipedia.org/wiki/Star_Trek_(1971_video_game)), written in basic for ucal irvine sds sigma 7, mike mayfield. in 1971, mike mayfield, then in his final year of high school, frequented a computer lab at the university of california, irvine, while teaching himself how to program. the lab operated both a sds sigma 7 and a dec pdp-10. the pdp-10 hosted a version of the 1962 pdp-1 spacewar. mayfield had gained illicit access to the sigma 7 at the lab and wanted to create his own version of the game for the system. spacewar required a vector graphics display, however, and the sigma 7 only had access to a non-graphical teletype model 33.
- 1972, rewrite of original, basic for hp 2000c at hp office near ucal irvine, mike mayfield
- 1973, ut trek, written in basic, grady hicks and jim korp at utexas
- 1974, ut fortran, aka 'super star trek', single player fortran on utexas cdc 6600, dave matuszek and paul reynolds
- mid 70s, war, fortran two player version written for utexas cdc 6600, author unknown, rewritten by robert schneider
- 1978, [decwar](https://en.wikipedia.org/wiki/Decwar#Original_versions), assembly and fortran, eighteen player version written for utexas pdp-10, bob hysick and jeff potter. version 1.0 of decwar was released in august 1978. the university would make copies available on tape for the nominal fee of $50, and it soon appeared on pdp-10s around the world. the greatly updated 2.0 was released in july 1979, and another major version, 2.3, on 20 november 1981.

[utexas center for american history](https://briscoecenter.org/) catalog item [v2.2](https://repositories.lib.utexas.edu/items/1aa48343-09ab-4b3b-a9f2-e2e525074a4d) has files migrated from a decus magnetic tape, including a somewhat doubtful patched executable, but no source code. here's the instructions a utexas player saw [june 3, 1980 v2.2 utexas](docs/decwar22-utexas.md). eighteen playable ships, this is also what players at the southwest texas state university computation center, san marcos texas, saw circa 1983 and 1984

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

[utexas center for american history](https://briscoecenter.org/) catalog item [v2.3](https://repositories.lib.utexas.edu/items/7e2ccf50-e814-4bce-91d2-a7f6440eabe4), has files ported by merlyn cousins from harris newman's decwar 2.3 source code to a simh/tops 10 emulator environment. newman's 2.3 version reflected changes made to the ut-developed decwar, which were made so the game could be installed on a compuserve (cis) system, circa 1981. here's the instructions a compuserve player saw [november 20, 1981 v2.3 compuserve](docs/decwar23-compuserve.md). compuserve modified the code, limiting to ten playable ships

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

it's a bit amazing and not completely clear yet why changing this back was so straightforward. problems were expected because compuserve additions to the source code do in fact reference [1,27]. it's possible that the current tops10 configuration in project utexas has something to do with it. it's suspected that the monitor security system is in some sense not fully activated. parts of rcornwell's baseline simh scripts were intentionally left off for a more 'tmp/dev' environment. the objective is not a production tops10 environment, rather a more loose and free sandbox. maybe that's why install in [5,30] 'just works'?

the second reconstruction is even more amazing. at utexas there were up to eighteen players. compuserve changed that to ten players, effectively halving the resources used. since decwar lives in both high and low segment core memory, that was probably a serious concern for their commercial production environment.

the reconstruction was straightforward again, and worked on basically the first try. utexas decwar has eighteen ships and players can again captain 'the buzzard'!

am establishing contact with the briscoe center, as both an academic and alumni. can picture adding a working 'utexas23-reconstruction' catalog item there, but the real idea is to get allies within at least the utexas archival system to pursue discovering original utexas source code. bob hysick is for sure still around, and have tried making contact with him. something more formal with official utexas participation could help with things like that. with allies at utexas and among folks like harris newman and merlyn cousins, it doesn't seem impossible to reach the 'holy grail' of original utexas source code, and even a dusty old mag tape in some mostly forgotten archive somewhere. this is a worthy quest.

# utexas structure

- docs, various howto and note related docs accumulating around the project
    - [utexas decwar notes collection](docs/readme.md/#utexas-decwar-notes)
    - [utexas tops10 users guide](docs/readme.md/#utexas-tops10-users-guide)
    - [utexas v2.2 player guide](docs/decwar22-utexas.md)
    - [compuserve v2.3 player guide](docs/decwar23-compuserve.md)
- msc, miscellaneous shell scripts and related code
    - [create tape utexas23 reconstruction](msc/create-tape-utexas23-reconstruction)
    - [create archive project utexas](msc/create-archive-project-utexas)
- simh, simh scripts
    - [utexas do](simh/utexas.do)
    - [boot from disk](simh/boot-from-disk.ini)
    - [create boot disk from tape](simh/create-boot-disk-from-tape.ini)
- utexas23-reconstruction, [primordial utexas tape reconstruction](docs/sec9-utexas-primordial-tape.md)
    - hlp folder, [hlp.com](utexas23-reconstruction/hlp/HLP.COM) comment file. note [decwar.imp](utexas23-reconstruction/hlp/DECWAR.IMP) important file, and the 1982 letter from utexas to compuserve, included on the primordial decwar tape as [decwar.ltr](utexas23-reconstruction/hlp/DECWAR.LTR)
    - msc folder, [msc.com](utexas23-reconstruction/msc/MSC.COM) comment file.
    - tec folder, for [teco scripts](docs/sec9-utexas-primordial-tape.md/#teco-scripts) to autogen fortran include files
    
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
    
this is no big deal, can do it repeatedly and often, can treat the disk as replaceable/expendable. the simh ini script is a good resource for learning about tops10. the disk will appear as folder dsk. the script should leave you at tops10 monitor prompt. do kjob to log out, ctrl-e to get simh prompt, quit to leave simh.

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
