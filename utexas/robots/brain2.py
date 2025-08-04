import random
import time
from definitions import robots, commands
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
            if self.name == self.superbot:
                res = self.command_and_response('time')
                res = self.command_and_response('po a')
                res = self.command_and_response('list ships')
            res = self.command_and_response('targets')
            res = self.command_and_response('bases enemy')
            if 'game' in str(res):
                dv = 3 * random.randint(-1, 1)
                dh = 3 * random.randint(-1, 1)
                self.command_and_response(f'm r {dv} {dh}')
                self.command_and_response(f'sc')
                return
            vhd = self.enemybases.update(res)
            time.sleep(1)
            dv = 0 if vhd[0] == 0 else int(3 * vhd[0] / abs(vhd[0]))
            dh = 0 if vhd[1] == 0 else int(3 * vhd[1] / abs(vhd[1]))
            if vhd[2] > 6:
                tmp = random.uniform(0, 1)
                if tmp < .2: dv = 0; dh *= -1
                elif tmp > .8: dh = 0; dv *= -1
                self.command_and_response(f'm r {dv} {dh}')
                self.command_and_response(f'sc')
            else: 
                self.command_and_response(f'ph r {vhd[0]} {vhd[1]}')
                time.sleep(1)
                if random.uniform(0, 1) > .5: self.command_and_response(f'to r 1 {vhd[0]} {vhd[1]}')
        except:
            try:
                for _ in range(2): self.tc.sendline(); self.tc.expect('>', timeout=10) # keep in game after destroyed
            except: raise

    def command_and_response(self, command):
        """send a command and get the response"""
        
        def getline():
            line = self.tc.readline().decode('utf-8').strip().lower()
            line = line.replace('\x07', '') # \x07 is \xhh hex for \a escape seq for ascii bell in emergency prompt
            return line
        
        def checkline(line):
            if not line: return
            # if 'move' in line: return 
            if ' unit p ' in line or ' unit t ' in line: return
            if 'message' in line: return
            # if 'navigation officer' in line: return
            if line == '>': return
            if self.cmdcnt - self.shipchg > 100 and ('set prompt' in line or 'set ocdef' in line or 'set output' in line or 'reading commands' in line or 'runs out' in line): self.shipcnt += 1; self.shipchg = self.cmdcnt
            return True
        
        def checkres(res, cmd):
            if cmd not in commands: return
            if len(res[0]) < 2: return
            if res[0][0][-1] != '>': return # can be emergency condition letters before prompt 
            if res[0][1] != cmd: return
            return True

        cmd = command.split()[0]
        if cmd not in commands: return
        for _ in range(2): self.tc.sendline(); self.tc.expect('>', timeout=10)
        self.tc.sendline(command)
        line = getline()
        while not checkline(line): line = getline()
        res = [line]
        while True:
            line = getline()
            if not line: break # blank line signals end of response to cmd
            if not checkline(line): continue
            res.append(line)
        res2 = [x.split() for x in res]
        if checkres(res2, cmd): self.cmdcnt += 1
        else: return
        for rec in res: print(f'{self.shipcnt}|{self.cmdcnt - self.shipchg}|{rec}')
        return res
    
    def move(self):
        v, h = 0, 0
        while v == 0 and h == 0: v, h = random.randint(-3, 3), random.randint(-3, 3)
        res = self.command_and_response(f'm r {v} {h}')
    