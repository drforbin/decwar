import random
import time
from definitions import robots

class Brain1:
    superbot = 'nomad'
    
    def __init__(self, name, braincnt, tc):
        self.name = name
        self.tc = tc
        self.braincnt = braincnt
        self.loopcnt = 0
        self.cmdcnt = 0
        if name == self.superbot: self.superpower()
        
    def nextstep(self):
        a, b = 2, 4
        time.sleep(1)
        targets = self.targets()
        time.sleep(1)
        # ships = self.list()
        status = self.command_and_response('status')
        time.sleep(random.uniform(a, b))
        self.move()
        time.sleep(random.uniform(a, b))
        self.speak()
        if self.name == self.superbot:
            time.sleep(random.uniform(a, b))
            self.list()
        time.sleep(random.uniform(a, b))

    def command_and_response(self, cmd):
        """read till eor end of response"""
        self.cmdcnt += 1
        self.tc.sendline()
        self.tc.expect('>', timeout=10)
        self.tc.sendline(cmd)
        res = [self.tc.readline().decode('utf-8').strip()]
        self.tc.sendline()
        # self.tc.expect('>', timeout=10)
        self.tc.sendline('time')
        # while cmd not in res[-1]: res.append(self.tc.readline().decode('utf-8').strip())
        while 'time of day' not in res[-1]: res.append(self.tc.readline().decode('utf-8').strip())
        res = self.cleaned(res)
        for rec in res: print(f'{str(self.braincnt)}|{str(self.loopcnt)}|{str(self.cmdcnt)}|{rec[0]}|{rec[2]}')
        self.tc.sendline()
        self.tc.expect('>', timeout=10)
        return res
    
    def cleaned(self, res):
        res2, res3 = [], []
        for rec in res:
            rec = str(rec).strip()
            rec = rec.replace('\n', '')
            rec = rec.replace('\r', '')
            if not rec or rec.isspace(): continue
            if rec == '>': continue
            if rec in ['> t', '> ime', '> ti', '> me', '> tim', '> e']: continue
            if 'time' in rec and 'elapsed time' not in rec: continue
            res2.append(rec)
        t1 = res2[-2].split('  ')[1]
        t2 = res2[-1].split('  ')[1]
        for rec in res2[:-2]:
            res3.append([t1, t2, rec])
        return res3

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
    
    def superpower(self):
        res = self.command_and_response('*password *mink')
        