import random
import time
from definitions import robots

class Brain:
    superbot = 'nomad'
    
    def __init__(self, name, tc):
        self.name = name
        self.tc = tc
        if name == self.superbot: self.superpower()
        
    def nextstep(self):
        self.speak_randomly()
        self.move()
        if self.name == self.superbot: res = self.list('ships')
        time.sleep(10)

    def speak_randomly(self):
        if True:
            if self.name not in robots: return
            if random.uniform(0, 1) > .05: return
        msg = random.choice(robots[self.name])
        self.tc.sendline(f'tell all; {msg}')
        self.tc.expect('>', timeout=10)

    def move(self):
        v, h = 0, 0
        while v == 0 and h == 0:
            v, h = random.randint(-1, 1), random.randint(-1, 1)
        self.tc.sendline(f'move relative {v} {h} / targets 10 / time')
        res = [self.tc.readline().decode('utf-8')]
        while 'time of day' not in res[-1]: res.append(self.tc.readline().decode('utf-8'))
        self.tc.expect('>', timeout=10)
        return res

    def list(self, *args):
        if 'ships' in args:
            self.tc.sendline('list ships / time')
        else:
            return
        res = [self.tc.readline().decode('utf-8')]
        while 'time of day' not in res[-1]: res.append(self.tc.readline().decode('utf-8'))
        self.tc.expect('>', timeout=10)
        return res

    def shields(self, *args):
        if 'down' in args:
            self.tc.sendline('shields down')
        else:
            self.tc.sendline('shields up')
        self.tc.expect('>', timeout=10)
        
    def superpower(self):
        self.tc.sendline('*password *mink')
        self.tc.expect('>', timeout=10)
        