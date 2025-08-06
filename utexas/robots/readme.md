# utexas robots

in your utexas folder, have a venv python virtual environment. can create that with

    python -m venv venv

have your bash shell set to use your venv

    source venv/bin/activate

your bash prompt should now begin with (venv) showing it's active. within your venv, have pip installed pexpect and sshkeyboard

    pip install pexpect
    pip install sshkeyboard

with project utexas 'booted from disk' and running in a terminal, open other terminals and use the commands

    python robots/gen2.py [captain's name]
    bash robots/start-some-robots.sh

# gen2

adds sophistication to be more practical for development, debugging, testing, etc. once started, pressing the '0' key will exit gracefully from decwar, tops10, and telnet, leaving you at the bash cli. it's using 'sshkeyboard' library to listen to the keyboard, and trying to be robust about quitting. meanwhile, in game, it's trying to be smarter in its command loop. for commands where it makes sense, the in game response should be auto parsed to python primitives.

