# bash robots/start-some-robots.sh &
# tail -f log1
# pkill -f python

rm log*
#./msc/create-tape-utexas23-reconstruction
#./dec10blinken simh/boot-from-disk.ini > log0 &
#sleep 30

# ?not needed after all? for grabbing the 'magical' first three telnet connections
#python -u robots/run tmpa > logtmpa &
#sleep 2
#python -u robots/run tmpb > logtmpb &
#sleep 2
#python -u robots/run tmpc > logtmpc &
#sleep 2

python -u robots/run nomad > log1 &
sleep 2
python -u robots/run robot2 > log2 &
sleep 5
python -u robots/run robot3 > log3 &
sleep 5
python -u robots/run robot4 > log4 &
sleep 5
python -u robots/run robot5 > log5 &
sleep 5
python -u robots/run robot6 > log6 &
sleep 5
python -u robots/run robot7 > log7 &
sleep 5
python -u robots/run robot8 > log8 &
sleep 5
python -u robots/run robot9 > log9 &
sleep 5
python -u robots/run robot10 > log10 &
sleep 5
#python -u robots/run robot11 > log11 &
#sleep 5
#python -u robots/run robot12 > log12 &
