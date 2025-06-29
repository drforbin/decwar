# utexas robots

with project utexas 'booted from disk' and running in a terminal, open another terminal and in the utexas folder do

    robots/run robot1

if python complains about 'pexpect', then do a quick 'pip install pexpect'. open more terminals and run more robots using other names (robot2, robot3, etc). the name 'nomad' is special. nomad acquires super powers and repeatedly lists all the other ships, including the romulan, so it's usually a good idea to have it in the game.

for testing, there's usually been two situations - three robots, or six robots

- three robots - this is fine! they will carry on indefinitely, no problem. twelve straight hours is normal. rarely now and then one will get knocked out to the shell. can simply restart it and away it goes.
- six robots - this will be ok for an hour or two, then utexas will need to be 'rebooted from disk', after making sure all robots are closed out to the shell. this is where any and all help is wanted! utexas running with six robots indefinitely will be a milestone. yes it's actually happened a few times, have seen them go for twelve hours, but seems always under odd circumstances. it's nowhere near robust and reliable!

what we'd like to see is eighteen robots playing indefinitely. first step on that path is the jump from three to six. note that even going from three to four triggers instability. for some reason, the number three is special. three robots or fewer is fine. any more is trouble... now, here comes a bizzare clue... when there is trouble, it very often happens at 'one hour and ten minutes' or 'two hours and twenty minutes' - have not been able to make any sense of this at all, but it's real... have noted from the tops-10 monitor calls manual that the kl and ks processors have an 'apr clock' that's 'based on the frequency of the system power source (either 50 or 60 hz).' could there be a system clock roll-over / overflow / etc? shouldn't it effect three robots as well as six robots?
