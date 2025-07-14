# project utexas

- [going backwards](#going-backwards)
- [how-to](#how-to)
  - [step1 and step2, hardware](#step1-have-the-contents-of-the-downloadable-archive-in-your-utexas-folder)
  - [step3 and step4, software](#step3-prep-utexas23-reconstruction-tape-file)
- [robot players](#robot-players)
- [folder structure](#folder-structure)

nutshell summary, from [esr1](http://www.catb.org/~esr/super-star-trek/) and [esr2](https://gitlab.com/esr/super-star-trek), and [decwar wiki](https://en.wikipedia.org/wiki/Decwar)

- 1971, [original single player star trek](https://en.wikipedia.org/wiki/Star_Trek_(1971_video_game)), written in basic for ucal irvine sds sigma 7, mike mayfield. in 1971, mike mayfield, then in his final year of high school, frequented a computer lab at the university of california, irvine, while teaching himself how to program. the lab operated both a sds sigma 7 and a dec pdp-10. the pdp-10 hosted a version of the 1962 pdp-1 spacewar. mayfield had gained illicit access to the sigma 7 at the lab and wanted to create his own version of the game for the system. spacewar required a vector graphics display, however, and the sigma 7 only had access to a non-graphical teletype model 33.
- 1972, rewrite of original, basic for hp 2000c at hp office near ucal irvine, mike mayfield
- 1973, ut trek, written in basic, grady hicks and jim korp at utexas
- 1974, ut fortran, aka 'super star trek', single player fortran on utexas cdc 6600, dave matuszek and paul reynolds
- mid 70s, war, fortran two player version written for utexas cdc 6600, author unknown, rewritten by robert schneider
- 1978, [decwar](https://en.wikipedia.org/wiki/Decwar#Original_versions), assembly and fortran, eighteen player version written for utexas pdp-10, bob hysick and jeff potter. version 1.0 of decwar was released in august 1978. the university would make copies available on tape for the nominal fee of $50, and it soon appeared on pdp-10s around the world. the greatly updated 2.0 was released in july 1979, and another major version, 2.3, on 20 november 1981.

[utexas center for american history](https://briscoecenter.org/) catalog item [v2.2](https://repositories.lib.utexas.edu/items/1aa48343-09ab-4b3b-a9f2-e2e525074a4d) has files migrated from a decus magnetic tape, including a somewhat doubtful patched executable, but no source code. here's the instructions a utexas player saw [june 3, 1980 v2.2 utexas](docs/DECWAR22.HLP). eighteen playable ships, this is also what players at the southwest texas state university computation center, san marcos texas, saw circa 1983 and 1984

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

[utexas center for american history](https://briscoecenter.org/) catalog item [v2.3](https://repositories.lib.utexas.edu/items/7e2ccf50-e814-4bce-91d2-a7f6440eabe4) has files ported by merlyn cousins from harris newman's decwar 2.3 source code to a simh pdp10. newman's 2.3 version reflected changes made to utexas decwar which were made so the game could be installed on a compuserve pdp10, circa 1981. here's the instructions a compuserve player saw [november 20, 1981 v2.3 compuserve](docs/DECWAR23CIS.HLP). compuserve decwar has ten playable ships

                 Federation ships               Empire ships
                 ----------------               ------------
                    Lexington                     Cobra
                    Nimitz                        Demon
                    Savannah                      Hawk
                    Vulcan                        Jackal
                    Yorktown                      Wolf

# going backwards

there's been a playable decwar, but it's a little different than the primordial utexas version. project utexas is about reconstruction of the original, converging nearer and nearer towards the primordial code and effectively going backwards in time. if a copy of the original code is discovered, it will hopefully match closely with the utexas reconstruction.

meanwhile, it's a living time capsule of fifty year old hardware and software, completely open for explorations and experiments. it's a big, many layered, complex system, but given time and user feedback can hopefully converge towards modern standards of friendliness and usability. and it's standing on the shoulders of giants. here's some discussion around those giants, and what they mean for day-to-day life with project utexas. the four 'steps' referred to here are the step1, step2, step3, step4 of the [how-to](#how-to) below.

step1 and step2. hardware. the hardware aspects are thanks to richard cornwell, and a useful entrypoint is rich's [pdp10 hardware repo](https://github.com/rcornwell/pidp10), and more broadly rich's [main hardware repo](https://github.com/rcornwell/sims). rich is a member of the [opensimh steering group](https://opensimh.org/about/). project utexas hardware can be a complex topic, as there were multiple generations of dec10 (ka, ki, kl, ks) and a zoo of attached devices. in a nutshell, it's useful to gradually become familiar with the hardware aspects of utexas. for digital systems, fifty years mean nothing, and at least in a digital sense the hardware is very 'real' and 'physical'.

step3 and step4. software. tops10, fortran iv, and other necessary low-level system code comes as binary tape images via rich's [personal website](https://sky-visions.com/dec/tops10.shtml). the way to learn about using these is by example and experimentation. getting familiar with the system tapes is a first step to being able to modify the creation and usage of the project utexas tape 'tapes/utexas.tap'. with that capability in hand, the next step is to be able to use the utexas tape to on-the-fly compile, link, and install decwar itself. improving that know-how is reflected in improvements to the simh script [utexas.do](https://github.com/drforbin/decwar/blob/master/utexas/simh/utexas.do). 

to have on the radar. project utexas relates with the higher-level [pidp-10 project](https://obsolescence.dev/pdp10). utexas was directly triggered and inspired by the release of the pidp-10 in the summer of 2024. all of the work and good spirit of oscar, lars, and rich are further inspiration. ideally utexas can be fully integrated within the pidp-10 'ecosystem'. there are good questions to tackle here, especially around interactions between ka and kl simh exes, and also the [pdpcontrol](https://github.com/rcornwell/pidp10/blob/master/bin/pdpcontrol.sh) bash script associated with the pidp-10 package. these are simply question marks to keep on the radar and learn about along the way. one thing to keep in mind is that decwar requires fortran iv, an earlier fortran than the fortran-10 commonly encountered these days. it's possible that fortran iv integration will play a major role in the future of utexas within the pidp-10 context.
 
# how-to

baseline situation is to be on a raspberry pi that is/can be used for the pidp-10 stuff. pidp-10 is not necessary, but simply assuming most decwar will be associated with pidp-10 raspi. have a local clone of the decwar repo and be in the utexas folder, everything happens 'inside the utexas folder'. git tracking does not include some relatively large and static binary files that you need to bring in manually, these are downloaded as an archive and taken care of in step1.

## step1 have the contents of the downloadable archive in your utexas folder

the script msc/create-archive-project-utexas was used to create project-utexas-archive-20250506.tar.gz. download the archive by hitting this [archive link](https://drive.google.com/file/d/1aLbaDcyIBG6pUwKbhw9UbuXFTfXkR1Cd/view?usp=sharing) and dearchive the contents and have them placed in your utexas folder
- dec10blinken simh exe that will drive console panel if you have one
- dec10 simh exe that is plain vanilla and does not drive console panel
- dec10test simh exe that is just for testing console front panel
- back10 exe that handles writing and listing tapes
- tapes folder with tape images
- bts folder with kl-10 boot loader exe needed by the simh scripts
    
## step2 prep tops10 boot disk

    ./dec10blinken simh/create-boot-disk-from-tape.ini
    
this is no big deal, can do it repeatedly and often, can treat the disk as replaceable/expendable. the simh ini script is a good resource for learning about tops10. the disk will appear as folder dsk. the script should leave you at tops10 monitor prompt. do kjob to log out, ctrl-e to get simh prompt, quit to leave simh.

## step3 prep utexas23 reconstruction tape file

    msc/create-tape-utexas23-reconstruction

this bash script will copy the decwar source code into tape file tapes/utexas23-reconstruction.tap and do a listing of the tape, showing the contents as confirmation.

## step4 boot tops10 from disk with auto install of utexas from tape

    ./dec10blinken simh/boot-from-disk.ini

have the line 'do utexas.do' uncommented in the ini file to install/reinstall utexas. simh 'expect' usage is not yet top-notch and there are some hacky workarounds. it should finish by setting permissions on decwar exe so its playable by all and assigning the gam: device. telnet in and run decwar

    $ telnet localhost 2030
    Trying ::1...
    Connected to localhost.
    Escape character is '^]'.
    Connected to the KL-10 simulator TTY device, line 0
    KL703 11:01:21 TTY4 system 1025
    Connected to Node KL10(1) Line # 4
    Please LOGIN
    .login decwar
    Job 3  KL703  TTY4
    11:01   19-Mar-86   Wednesday
    .r gam:decwar
    DECWAR, Edit    16
    [DECWAR Version 2.3, 20-Nov-81]

you can use the above to telnet in from multiple terminals and start the game as several players on both sides, then try the radio, phasers, torpedoes, shields, etc.

# robot players

with project utexas 'booted from disk' and running in a terminal, open another terminal and in the utexas folder do

    robots/run robot1

if python complains about 'pexpect', then do a quick 'pip install pexpect'. open more terminals and run more robots using other names (robot2, robot3, etc). the name 'nomad' is special. nomad acquires super powers and repeatedly lists all the other ships, including the romulan, so it's usually a good idea to have it in the game.

for testing, there's usually been two situations - three robots, or six robots

- three robots - this is fine! they will carry on indefinitely, no problem. twelve straight hours is normal. rarely now and then one will get knocked out to the shell. can simply restart it and away it goes.
- six robots - this will be ok for an hour or two, then utexas will need to be 'rebooted from disk', after making sure all robots are closed out to the shell. this is where any and all help is wanted! utexas running with six robots indefinitely will be a milestone. yes it's actually happened a few times, have seen them go for twelve hours, but seems always under odd circumstances. it's nowhere near robust and reliable!

what we'd like to see is eighteen robots playing indefinitely. first step on that path is the jump from three to six. note that even going from three to four triggers instability. for some reason, the number three is special. three robots or fewer is fine. any more is trouble... now, here comes a bizzare clue... when there is trouble, it very often happens at 'one hour and ten minutes' or 'two hours and twenty minutes' - have not been able to make any sense of this at all, but it's real... have noted from the tops-10 monitor calls manual that the kl and ks processors have an 'apr clock' that's 'based on the frequency of the system power source (either 50 or 60 hz).' could there be a system clock roll-over / overflow / etc? shouldn't it effect three robots as well as six robots?

# folder structure

- docs, various howto and note related docs accumulating around the project
  - [utexas notes](docs/readme.md/#project-utexas-notes)
  - [utexas log](docs/project-utexas-log.md/#project-utexas-log)
  - [utexas tops10 users guide](docs/readme.md/#utexas-tops10-users-guide)
  - [utexas v2.2 player guide](docs/DECWAR22.HLP)
  - [compuserve v2.3 player guide](docs/DECWAR23CIS.HLP)
- msc, miscellaneous shell scripts and related code
  - [create tape utexas23 reconstruction](msc/create-tape-utexas23-reconstruction)
  - [create archive project utexas](msc/create-archive-project-utexas)
- robots, automatic players/agents to drive the action
  - [readme](robots/readme.md)
- simh, simh scripts
  - [utexas do](simh/utexas.do)
  - [boot from disk](simh/boot-from-disk.ini)
  - [create boot disk from tape](simh/create-boot-disk-from-tape.ini)
- utexas23-reconstruction, [primordial utexas tape reconstruction](docs/sec9-utexas-primordial-tape.md)
  - hlp folder, [hlp.com](utexas23-reconstruction/hlp/HLP.COM) comment file. note [decwar.imp](utexas23-reconstruction/hlp/DECWAR.IMP) important file, and the 1982 letter from utexas to compuserve, included on the primordial decwar tape as [decwar.ltr](utexas23-reconstruction/hlp/DECWAR.LTR)
  - msc folder, [msc.com](utexas23-reconstruction/msc/MSC.COM) comment file.
  - tec folder, for [teco scripts](docs/sec9-utexas-primordial-tape.md/#teco-scripts) to autogen fortran include files