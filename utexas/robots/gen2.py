from sshkeyboard import listen_keyboard, stop_listening
import cli
import threading
from robot2 import Robot2

args, kwargs = cli.main()
ro = Robot2(*args, **kwargs)
rothread = threading.Thread(target=ro.main)
rothread.start()

def main():
    ro.set_mode('2')
    listen_keyboard(on_press=press)

def press(key):
    print(f"'{key}' pressed")
    ro.set_mode(key)
    if key == '0': stop_listening()

if __name__ == "__main__":
    main()
