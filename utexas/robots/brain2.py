import random
import time
from definitions import robots, commands

class Brain2:
    
    def __init__(self, name, braincnt, tc):
        self.name = name
        self.tc = tc
        self.braincnt = braincnt
        self.shipcnt, self.shipchg = 1, 0
        self.cmdcnt = 0
        
    def nextstep(self):
        try:
            time.sleep(3)
            targets = self.command_and_response('targets')
            time.sleep(3)
            status = self.command_and_response('status')
            time.sleep(3)
            self.move()
        except:
            for _ in range(2): self.tc.sendline(); self.tc.expect('>', timeout=10) # keep in game after destroyed

    def command_and_response(self, command):
        """send a command and get the response"""
        
        def getline():
            line = self.tc.readline().decode('utf-8').strip().lower()
            line = line.replace('\x07', '') # \x07 is \xhh hex for \a escape seq for ascii bell in emergency prompt
            return line
        
        def checkline(line):
            if not line: return
            if 'move' in line: return 
            if ' unit p ' in line or ' unit t ' in line: return
            if 'message' in line: return
            if 'navigation officer' in line: return
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
        res = [x.split() for x in res]
        if checkres(res, cmd):
            self.cmdcnt += 1
            outstr = f'{self.shipcnt}|{self.cmdcnt - self.shipchg}|{res}'
            print(outstr[:115])
        return res
    
    def move(self):
        v, h = 0, 0
        while v == 0 and h == 0: v, h = random.randint(-1, 1), random.randint(-1, 1)
        res = self.command_and_response(f'move relative {v} {h}')
    