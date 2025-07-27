import random
import time
from definitions import robots

class Brain2:
    
    def __init__(self, name, braincnt, tc):
        self.name = name
        self.tc = tc
        self.braincnt = braincnt
        self.cmdcnt = 0
        
    def nextstep(self):
        time.sleep(3)
        targets = self.command_and_response('targets')
        time.sleep(3)
        status = self.command_and_response('status')
        time.sleep(3)
        self.move()

    def command_and_response(self, cmd):
        """read till eor end of response"""
        self.tc.sendline(cmd)
        if 'move' in cmd: return
        line = self.tc.readline().decode('utf-8').strip().lower()
        while 'move' in line or line == '' or line == '>': line = self.tc.readline().decode('utf-8').strip().lower()
        res = [line]
        while True:
            line = self.tc.readline().decode('utf-8').strip().lower()
            if not line: break
            if ' unit p ' in line or ' unit t ' in line: continue
            res.append(line)
        if 'message' in res[0]: return
        if ' unit p ' in res[0] or ' unit t ' in res[0]: return
        if 'navigation officer' in res[0]: return
        if not res: return
        self.cmdcnt += 1
        res = [x.split() for x in res[1:]]
        print(f'{self.cmdcnt}|{res}')
        return res

    def speak(self):
        if True:
            if self.name not in robots: return
            if random.uniform(0, 1) > .1: return
        msg = random.choice(robots[self.name])
        res = self.command_and_response(f'tell all; {msg}')
    
    def move(self):
        v, h = 0, 0
        while v == 0 and h == 0: v, h = random.randint(-1, 1), random.randint(-1, 1)
        res = self.command_and_response(f'move relative {v} {h}')
    
    def targets(self):
        res = self.command_and_response('targets')

    def time(self):
        res = self.command_and_response('time')
    
    def list(self, *args):
        res = self.command_and_response('list ships')
    