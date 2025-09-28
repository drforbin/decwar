# ------ help / usages infos -------------------------------------
# bash robots/start-some-robots.sh &
# tail -f log1
# pkill -[signal # or name] -f python
# 2  SIGINT  ctrlc   
# 20 SIGTSTP ctrlz
# -----------------------------------------------------------------

rm log*
python -u robots/main.py nomad > log1 &
sleep 2
python -u robots/main.py robot2 > log2 &
sleep 5
python -u robots/main.py robot3 > log3 &
sleep 5
python -u robots/main.py robot4 > log4 &
sleep 5
python -u robots/main.py robot5 > log5 &
sleep 5
python -u robots/main.py robot6 > log6 &
sleep 5
python -u robots/main.py robot7 > log7 &
sleep 5
python -u robots/main.py robot8 > log8 &
sleep 5
python -u robots/main.py robot9 > log9 &
sleep 5
python -u robots/main.py robot10 > log10 &
sleep 5
