import argparse

def main():
    cli = argparse.ArgumentParser(description='robot')
    cli.add_argument('name', type=str)
    cli.add_argument('-i', '--ip', default='192.168.178.21', type=str)
    cli.add_argument('-p', '--port', default=2030, type=int)
    cli.add_argument('-u', '--ppn', default='decwar', type=str)
    cli2 = cli.parse_args()
    args = set()
    args = tuple(args)
    kwargs = {}
    kwargs['name'] = cli2.name
    kwargs['ip'] = cli2.ip
    kwargs['port'] = cli2.port
    kwargs['ppn'] = cli2.ppn
    return args, kwargs
    
if __name__ == "__main__":
    main()
    