# algebra (python, fortran10, macro10)

target is, using all three languages in parallel to reproduce [feynman's table 22-3](https://www.feynmanlectures.caltech.edu/I_22.html). for python things are [straightforward](ipwr.py)

    y = .00225
    x = round(sqrt(1. - y**2), 7)
    for _ in range(11):
        print('%10.5f %10.5f' % (x, y))
        x2 = round(x**2 - y**2, 7)
        y2 = round(2 * x * y, 7)
        x, y = x2, y2    

with fortran10, the basic workflow for iterating between raspi and tops10 [is there now](../sec5-minimalist-walkthrough.md). what would be nice is to be able to at the least do 'initial work' on fortran10's old school fortran iv/66 source code in a raspi ide debugger. clearly nothing like this will be possible for macro10, but for fortran10 it's worthwhile.

onboard the raspi, insure that 'sudo apt install gcc' and 'sudo apt install gdb' are go. these cover the gfortran compiler, which does seem able to handle the source code. vscode and its ['modern fortran' extension](https://fortran-lang.org/) also work alright. for vscode run configurations, see [tasks.json](../../.vscode/tasks.json) and [launch.json](../../.vscode/launch.json).

here's the [fortran10](ipwr.for). note in the write (6, 10) the '6' is a 'unit designation' and the '10' is a format statement line number. currently unit designation for terminal is 6 on raspi but 5 on tops10. would like to make this portable, no differences between raspi and tops10. 

        integer i
        real x, y, x2, y2
    10    format (2f10.5)
        y = .00225
        x = sqrt(1. - y**2)
        do 20 i=1,11
            write (6, 10) x, y
            x2 = x**2 - y**2
            y2 = 2 * x * y
            x = x2
            y = y2
    20    continue
        end
