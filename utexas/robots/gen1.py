import cli
import time
import pexpect
from definitions import ships
from brain1 import Brain1

class Robot:

    def __init__(self, *args, **kwargs):
        self.args, self.kwargs = args, kwargs
        self.name = kwargs['name']
        self.loopcnt = 0

    def main(self):
        """try to stay in game between ships"""
        try:
            self.telnet_entry()
            self.tops10_entry()
            self.decwar_entry()
            self.loop()
        except:
            print(f'robot {self.name} shutdown')
            try:
                self.decwar_exit()
                self.tops10_exit()
                self.telnet_exit()
            except:
                pass

    def loop(self):
        """it's recursive so needs its own call."""
        self.loopcnt += 1
        try:
            brain = Brain1(self.name, self.loopcnt, self.tc)
            while True: brain.nextstep() # main loop
        except:
            for _ in range(6): # try to stay in game
                time.sleep(5)
                try:
                    for _ in range(3): time.sleep(1); self.tc.sendline(''); self.tc.expect('>', timeout=10)
                    self.loop()  # recursive reenter loop
                except: pass
            print('except out of loop')
            raise

    def telnet_entry(self):
        # self.tc = pexpect.spawn(f"telnet {self.kwargs['ip']} {self.kwargs['port']}", timeout=10, logfile=sys.stdout.buffer, echo=False)
        self.tc = pexpect.spawn(f"telnet {self.kwargs['ip']} {self.kwargs['port']}", timeout=10, echo=False)
        time.sleep(1)
        self.tc.expect('.', timeout=10)
        self.tc.sendline('')
        time.sleep(1)
        self.tc.expect('.', timeout=10)

    def tops10_entry(self):
        self.tc.sendline('')
        time.sleep(1)
        self.tc.expect('.', timeout=10)
        self.tc.sendline(f"login {self.kwargs['ppn']}")
        time.sleep(1)
        self.tc.expect('.', timeout=10)
        self.tc.sendline('')
        time.sleep(1)
        self.tc.expect('.', timeout=10)

    def decwar_entry(self):
        """from tops10, run game and get to command prompt"""
        self.tc.sendline('r gam:decwar')
        self.tc.expect('Your name please: ', timeout=10)
        self.tc.sendline(f'{self.name}')
        self.tc.expect('line: ', timeout=10)
        self.tc.sendline('')
        ndx1 = self.tc.expect(
            ['DECWAR', 'Regular or Tournament', 'Federation or Empire', 'You will join', 'choose another ship?'],
            timeout=10)
        if ndx1 > 0:
            if ndx1 == 1: self.tc.sendline(); self.tc.sendline(); self.tc.sendline()
            if ndx1 < 3: self.tc.sendline()  # join default side
            if ndx1 == 4: self.tc.sendline('yes')
            for ship in ships:
                ndx2 = self.tc.expect(['DECWAR', 'Which vessel'], timeout=10)
                if ndx2 == 0:
                    break
                else:
                    self.tc.sendline(ship)
        self.tc.expect('Commands From TTY', timeout=10)
        self.tc.sendline('')
        self.tc.expect('>', timeout=10)

    def decwar_exit(self):
        try:
            self.tc.sendcontrol('c')
            time.sleep(1)
            self.tc.sendcontrol('c')
            time.sleep(1)
            ndx2 = self.tc.expect(['Do you really want', 'Use QUIT', '.'], timeout=10)
            time.sleep(1)
            if ndx2 == 0:
                self.tc.sendline('yes')
            elif ndx2 == 1:
                self.tc.sendline('quit')
                time.sleep(1)
                self.tc.sendline('yes')
            else:
                pass
            time.sleep(1)
        except:
            print('exception in stop game')
            raise

    def tops10_exit(self):
        try:
            self.tc.sendline('')
            time.sleep(1)
            self.tc.expect('.', timeout=10)
            self.tc.sendline('kjob')
            time.sleep(1)
            self.tc.expect('.', timeout=10)
        except:
            print('exception in logout')
            raise

    def telnet_exit(self):
        try:
            self.tc.sendline('')
            time.sleep(1)
            self.tc.expect('.', timeout=10)
            self.tc.sendcontrol(']')
            time.sleep(1)
            self.tc.sendline('close')
            time.sleep(1)
            self.tc.terminate(force=True)
        except:
            print('exception in disconnect')
            raise
        
if __name__ == "__main__":
    args, kwargs = cli.main()
    ro = Robot(*args, **kwargs)
    ro.main()
