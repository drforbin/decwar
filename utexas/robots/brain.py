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
        a, b = 5, 10
        time.sleep(random.uniform(a, b))
        self.move()
        time.sleep(random.uniform(a, b))
        self.speak()
        if self.name == self.superbot:
            time.sleep(random.uniform(a, b))
            self.time()
            time.sleep(random.uniform(a, b))
            self.list()
        time.sleep(random.uniform(a, b))

    def response(self, eor):
        """read till eor end of response"""
        res = [self.tc.readline().decode('utf-8')]
        while eor not in res[-1]: res.append(self.tc.readline().decode('utf-8'))
        return res
        
    def speak(self):
        if True:
            if self.name not in robots: return
            # if random.uniform(0, 1) > .05: return
        msg = random.choice(robots[self.name])
        self.tc.sendline(f'tell all; {msg}')
        res = self.response('>')
        # self.tc.expect('>', timeout=10)

    def move(self):
        v, h = 0, 0
        while v == 0 and h == 0:
            v, h = random.randint(-1, 1), random.randint(-1, 1)
        self.tc.sendline(f'move relative {v} {h}')
        res = self.response('>')
        # self.tc.expect('>', timeout=10)

    def targets(self):
        self.tc.sendline(f'targets')
        self.tc.expect('>', timeout=10)
        return

    def time(self):
        self.tc.sendline(f'time')
        res = [self.tc.readline().decode('utf-8')]
        while 'time of day' not in res[-1]: res.append(self.tc.readline().decode('utf-8'))
        self.tc.expect('>', timeout=10)
        return
    
    def list(self, *args):
        self.tc.sendline('list ships')
        self.tc.expect('>', timeout=10)
        return

    def shields(self, *args):
        if 'down' in args: self.tc.sendline('shields down')
        else: self.tc.sendline('shields up')
        self.tc.expect('>', timeout=10)
        
    def superpower(self):
        self.tc.sendline('*password *mink')
        self.tc.expect('>', timeout=10)
        