import time
import pexpect
from definitions import ships
from brain2 import Brain2

class Robot2:

    def __init__(self, *args, **kwargs):
        self.args, self.kwargs = args, kwargs
        self.name = kwargs['name']
        self.mode = '1'
        self.braincnt = 0
        self.brain = None

    def main(self):
        while self.mode: # main loop
            if self.mode == '1': time.sleep(1) # standby mode
            elif self.mode == '2': self.brain.nextstep()
        self.decwar_exit()
        self.tops10_exit()
        self.telnet_exit()

    def set_mode(self, key):
        if key == '0': 
            key = 0 # set to false, causes main loop to exit
        elif self.mode == '1' and key == '2':
            self.telnet_entry()
            self.tops10_entry()
            self.decwar_entry()
            self.braincnt += 1
            self.brain = Brain2(self.name, self.braincnt, self.tc)
        elif self.mode == '2' and key == '1':
            pass
        else:
            return # ignore other keys
        self.mode = key

    def telnet_entry(self):
        print('telnet entry')
        try:
            self.tc = pexpect.spawn(f"telnet {self.kwargs['ip']} {self.kwargs['port']}", timeout=10, echo=False)
            time.sleep(1)
            self.tc.expect('.', timeout=10)
            self.tc.sendline('')
            time.sleep(1)
            self.tc.expect('.', timeout=10)
        except: pass

    def tops10_entry(self):
        print('tops10 entry')
        try:
            self.tc.sendline('')
            time.sleep(1)
            self.tc.expect('.', timeout=10)
            self.tc.sendline(f"login {self.kwargs['ppn']}")
            time.sleep(1)
            self.tc.expect('.', timeout=10)
            self.tc.sendline('')
            time.sleep(1)
            self.tc.expect('.', timeout=10)
        except: pass
        
    def decwar_entry(self):
        """from tops10, run game and get to command prompt"""
        print('decwar entry')
        try:
            self.tc.sendline('r gam:decwar')
            self.tc.expect('Your name please: ', timeout=10)
            self.tc.sendline(f'{self.name}')
            self.tc.expect('line: ', timeout=10)
            self.tc.sendline('')
            ndx1 = self.tc.expect(['DECWAR', 'Regular or Tournament', 'Federation or Empire', 'You will join', 'choose another ship?'], timeout=10)
            if ndx1 > 0:
                if ndx1 == 1: self.tc.sendline(); self.tc.sendline(); self.tc.sendline()
                if ndx1 < 3: self.tc.sendline()  # join default side
                if ndx1 == 4: self.tc.sendline('yes')
                for ship in ships:
                    ndx2 = self.tc.expect(['DECWAR', 'Which vessel'], timeout=10)
                    if ndx2 == 0: break
                    else: self.tc.sendline(ship)
            self.tc.expect('Commands From TTY', timeout=10)
            self.tc.sendline('')
            self.tc.expect('>', timeout=10)
        except: pass

    def decwar_exit(self):
        print('decwar exit')
        try:
            self.tc.sendline()
            self.tc.expect('>', timeout=10)
            self.tc.sendline('quit')
            self.tc.expect('Do you really want to quit?', timeout=10)
            self.tc.sendline('yes')
        except: pass

    def tops10_exit(self):
        print('tops10 exit')
        try:
            self.tc.sendline('')
            time.sleep(1)
            self.tc.expect('.', timeout=10)
            self.tc.sendline('kjob')
            time.sleep(1)
            self.tc.expect('.', timeout=10)
        except: pass

    def telnet_exit(self):
        print('telnet exit')
        try:
            self.tc.sendline('')
            time.sleep(1)
            self.tc.expect('.', timeout=10)
            self.tc.sendcontrol(']')
            time.sleep(1)
            self.tc.sendline('close')
            time.sleep(1)
            self.tc.terminate(force=True)
        except: pass
            