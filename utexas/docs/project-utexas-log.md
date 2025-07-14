# project utexas log

## 20250713 'nice enough' workflow1

workflow1 has evolved enough to make public. nutshell -

- step1 and step2, hardware - once tops10 boot disk is created, it's stable and doesn't need recreation. possible gotcha is discussed below as raspi pidp-10 'temporary brain damage', but seems that simh, mongen, tops10, etc doesn't have any influence.
- step3 and step3, software - there's now a simh script boot-from-disk-fast.ini which goes directly to the tops10 prompt, without building decwar from tape, and can then run previous decwar build. the old boot-from-disk.ini is for initial decwar build or following builds.
- robot hordes - start-some-robots.sh is for quickly bringing up a game with many robots. the way to shut them all down at once is 'pkill -f python'. to watch the log of a robot use 'tail -f logxyz'. have a terminal running 'tail -f log1' to watch the output from 'superbot nomad' and see all the ships, including the romulan '??' when he's alive.

time to try moving onward to new topics, while continuing to improve the following old topics

- locking unlocking using tops10 enq deq uuo - for now, this's been simplified 'as much as possible'. it uses integer 'user codes'. user code 1 for calls from fortran. user code 2 for calls from macro. each decwar job has one lock at a time, and can call unlock anytime anywhere to insure it's released!
- tell command - there's work to do. if tell is bypassed, ten robots go indefinitely. with tell, they're usually fine for between one and three hours before eventually there's some trouble. currently some robots will get knocked out and can be restarted, the overall game goes on. there's not a total hard crash, more of a degradation. the problem has definitely been traced down below the fortran and into the msg que macro. the suspect code paths, with lower level funcs in parenthesis, are makmsg -> (rsrv, remv, updt) and getmsg -> (srch, remv).
- raspi pidp-10 'temporary brain damage' - what we're seeing is the raspi pidp-10 combo occasionally misbehaving, blinking oddly, etc, including failing to build tops10 or decwar. using dec10test to 'clear the blinkers' or 'pulling the plug' is needed whenever things get sideways. after 'sufficient reset' things are fine again. basically the raspi pidp-10 has some kind of 'memory' or 'state' around what's happened to it recently, and it gets sideways over time. fine. nuke it from orbit.

## 20250511 first public mention of project utexas

first mention in github/drforbin/decwar discussions, 'project utexas - !call for testers!' - https://github.com/drforbin/decwar/discussions/27
