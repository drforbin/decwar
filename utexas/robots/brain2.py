import random
import time
from definitions import robots #, commands
from concepts.enemy_bases import EnemyBases

class Brain2:
    superbot = 'nomad'

    def __init__(self, name, braincnt, tc):
        self.name = name
        self.tc = tc
        self.braincnt = braincnt
        self.shipcnt, self.shipchg = 1, 0
        self.cmdcnt = 0
        self.enemybases = EnemyBases()
        
    def nextstep(self):
        try:
            self.speak()
            if self.name == self.superbot:
                res = self.command_and_response('time')
                res = self.command_and_response('po a')
                res = self.command_and_response('list ships')
            res = self.command_and_response('targets')
            res = self.command_and_response('bases enemy')
            vhd = self.enemybases.update(res)
            if not vhd[2]:
                dv, dh = random.randint(-3, 3), random.randint(-3, 3)
                res = self.command_and_response(f'm r {dv} {dh}')
                res = self.command_and_response(f'sc')
            else:
                dv = 0 if vhd[0] == 0 else int(3 * vhd[0] / abs(vhd[0]))
                dh = 0 if vhd[1] == 0 else int(3 * vhd[1] / abs(vhd[1]))
                if vhd[2] > 6:
                    tmp = random.uniform(0, 1)
                    if tmp < .05: dv = 0; dh *= -1 # in case stuck
                    elif tmp > .95: dh = 0; dv *= -1
                    res = self.command_and_response(f'm r {dv} {dh}')
                    res = self.command_and_response(f'sc')
                else:
                    res = self.command_and_response(f'ph r {vhd[0]} {vhd[1]}')
                    if random.uniform(0, 1) > .5: res = self.command_and_response(f'to r 1 {vhd[0]} {vhd[1]}')
        except:
            try:
                for _ in range(2): self.tc.sendline(); self.tc.expect('>', timeout=10) # keep in game after destroyed
            except: raise

    def command_and_response(self, command):
        """send a command and get the response"""
        
        def checkline(line):
            if self.cmdcnt - self.shipchg > 100 and ('set prompt' in line or 'set ocdef' in line or 'set output' in line or 'reading commands' in line or 'runs out' in line): self.shipcnt += 1; self.shipchg = self.cmdcnt
            return True
        
        def listen(secs):
            res, tmp = [], ''
            tf = time.time() + secs
            while time.time() < tf:
                try: tmp += self.tc.read_nonblocking(3000, timeout=.2).decode('utf-8')
                except: pass
            tmp = tmp.replace('\x07', '')  # \x07 is \xhh hex for \a escape seq for ascii bell
            tmp = tmp.strip().lower().splitlines()
            for line in tmp:
                if not checkline(line): continue
                res.append(line)
            return res
            
        try:
            cmd = command.split()[0]
            for _ in range(2): self.tc.sendline(); self.tc.expect('>', timeout=10)
            self.tc.sendline(command)
            res = listen(4)
            self.cmdcnt += 1
            for rec in res:
                if not rec: continue
                print(f'{self.shipcnt}|{self.cmdcnt - self.shipchg}|{rec}')
            return res
        except: print(f"cmd exception '{command}'")
    
    def speak(self):
        if True:
            if self.name not in robots: return
            if random.uniform(0, 1) > .1: return
        msg = random.choice(robots[self.name])
        res = self.command_and_response(f'tell all; {msg}')
        