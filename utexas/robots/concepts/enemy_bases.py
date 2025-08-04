import math

class EnemyBases:
    """defeating these are the way to win the game."""
    
    def __init__(self):
        pass
    
    def update(self, raw):
        if not raw: return 
        vh = []
        for rec in raw:
            if 'bases' in rec: continue
            tmp = rec.split('@')
            tmp1, tmp2 = tmp[1][:5], tmp[1][5:]
            tmp3 = tmp2.split(',')
            v = int(tmp3[0].strip())
            tmp4 = tmp3[1].split()
            h = int(tmp4[0].strip())
            vh.append([v, h])
        vhd = [[x[0], x[1], int(math.sqrt(x[0]**2 + x[1]**2))] for x in vh]
        vhd = sorted(vhd, key=lambda x: x[2])
        # for rec in vhd: print(rec)
        if not vhd: return 
        print(vhd[0])
        return vhd[0]
        