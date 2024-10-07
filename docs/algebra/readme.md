target is using python, fortran10, macro10 in parallel to reproduce [feynman's table 22-3](https://www.feynmanlectures.caltech.edu/I_22.html)

# skip to the punchline

## python

    from math import sqrt
    y = .00225
    x = sqrt(1. - y**2)
    for _ in range(11):
        print('%10.5f %10.5f' % (x, y))
        x2 = x**2 - y**2
        y2 = 2 * x * y
        x, y = x2, y2

## fortran10

        integer i
        real x, y, x2, y2
    10  format (2f10.5)
        y = .00225
        x = sqrt(1. - y**2)
        do 20 i=1,11
            write (6, 10) x, y
            x2 = x**2 - y**2
            y2 = 2 * x * y
            x = x2
            y = y2
    20  continue
        end

## macro10

    a=1
    b=2
    c=3
    digit=4
    tmp=5
    sqr=6
    x=10
    y=11
    x2=12
    y2=13
    newlin: asciz   /
    /
    start:  reset
            movei   y,^d225
            fltr    y,y
            fmpr    y,[0.00001]
            move    a,y
            fmp     a,a
            movei   x,^d1
            fltr    x,x
            fsb     x,a
            movei   sqr,1
    sqrloop:jsr     nxtsqr
            addi    sqr,1
            caig    sqr,13
            jrst    sqrloop
            exit
    nxtsqr: 0 ;next iteration on x and y
            move    a,x
            jsr     prflt
            movei   tmp," "
            outchr  tmp
            move    a,y
            jsr     prflt
            outstr  newlin
            move    x2,x
            fmp     x2,x2
            move    tmp,y
            fmp     tmp,tmp
            fsb     x2,tmp
            move    y2,y
            fmp     y2,x2
            fmp     y2,[2.0]
            move    x,x2
            move    y,y2
            jrstf   @nxtsqr
    prflt:  0 ;print float less than one in accum a
            fix     b,a
            fltr    c,b
            fsbr    a,c
            jumpge  b,point
            movei   tmp,"-"
            outchr  tmp
    point:  movei   tmp,"."
            outchr  tmp
            movei   digit,1
    digloop:fmpr    a,[10.0]
            fix     tmp,a
            fltr    c,tmp
            fsbr    a,c
            addi    tmp,"0"
            outchr  tmp
            addi    digit,1
            caig    digit,5
            jrst    digloop
            jrstf   @prflt
    end start

# stage1

with fortran10, the basic workflow for iterating between raspi and tops10 [is there now](../sec5-minimalist-walkthrough.md). what would be nice is to be able to at the least do 'initial work' on fortran10's old school fortran iv/66 source code in a raspi ide debugger. clearly nothing like this will be possible for macro10, but for fortran10 it's worthwhile.

onboard the raspi, insure that 'sudo apt install gcc' and 'sudo apt install gdb' are go. these cover the gfortran compiler, which does seem able to handle the source code. vscode and its ['modern fortran' extension](https://fortran-lang.org/) also work alright. for vscode run configurations, see [tasks.json](../../.vscode/tasks.json) and [launch.json](../../.vscode/launch.json).

here's the [fortran10](ipwr.for). note in the write (6, 10) the '6' is a 'unit designation' and the '10' is a format statement line number. currently unit designation for terminal is 6 on raspi but 5 on tops10. would like to make this portable, no differences between raspi and tops10.

with macro10, the 'print' of python and 'write' of fortran are the first topic. taking an accumulator containing a floating point number and printing it on the terminal in something like f10.5 format. the pdp10 has sixteen accumulators, and the numerical value contained in one of those is to be printed in 'human readable decimal form' on the terminal. 

before that, first step is to do the same but for an accumulator containing a fixed point twos complement binary number. the historical 'decimal output / decout' problem, as discussed in the 'early sixties' section of the levy book, and a kind of historical landmark, along with the contemporary topics of recursion, stack processing, algol, and the beginnings of academic computer science.

    a=1
    b=2
    p=17
    pdlen==40
    pdlist: block   pdlen
    opdef   call    [pushj p,]
    opdef   ret     [popj p,]
    crlf:   byte    (7)15,12
    start:  reset
            move    p,[iowd pdlen,pdlist]
            movei   a,3
            call    decout
            hrroi   a,crlf
            outstr  (a)
            exit
    decout: jumpge  a,decot1
            push    p,a
            movei   a,"-"
            outchr  a
            pop     p,a
            movn    a,a
    decot1: idivi   a,^d10
            push    p,b
            skipe   a
            call    decot1
            pop     p,a
            addi    a,"0"
            outchr  a
            ret
    end start

# stage2

printing floating point is a modification of the above, bringing in the pdp10 floating point instructions. there's a numerical value to be printed out to the terminal, and that's done one character at a time using the 'outchr' tops10 muuo. this is a request to tops10 to print a character on the terminal, and it's used repeatedly to print each character of the numerical value, including negative sign and decimal point.

as part of understanding all of this, it became apparent that a stack isn't needed. the code above is from the gorin book and it's oriented towards academic computer science. here's a minimalist numerical computing approach. for feynman's table 22-3, the need is to print five digits after the decimal point. that's all this code does. at the start, accumulator 'a' contains a float that is less than one. it's 'after the decimal point'. the machinery repeats five times, cranking five digits out 'in front of the decimal point', one by one, to print them with 'outchr'.

            movei   tmp,"."
            outchr  tmp   
            movei   itr,1
    loop:   fmpr    a,[10.0]
            fix     tmp,a
            fltr    c,tmp
            fsbr    a,c
            addi    tmp,"0"
            outchr  tmp
            addi    itr,1
            caig    itr,5
            jrst    loop
            ...

the code below works. it reproduces feynman's table 22-3 and the results of the python and fortran10 code. something interesting happens though, from about the sixth or seventh of the eleven iterations. this is actually an opportunity to learn more about the early days of floating point and its practical use, so will be tackled deliberately going forward. the code below is using standard single precision pdp10 floating point, so 27 bits of precision. the first diagnosis has to be that using double precision would cure the problem. if this turns out to be true, it will be an excellent example of real-world effects of floating point precision, and will mean that feynman's table 22-3 is an excellent detector of poor numerical precision. 

    a=1
    b=2
    c=3
    digit=4
    tmp=5
    sqr=6
    x=10
    y=11
    x2=12
    y2=13
    newlin: asciz   /
    /
    start:  reset
            movei   y,^d225
            fltr    y,y
            fmpr    y,[0.00001]
            move    a,y
            fmp     a,a
            movei   x,^d1
            fltr    x,x
            fsb     x,a
            movei   sqr,1
    sqrloop:jsr     nxtsqr
            addi    sqr,1
            caig    sqr,13
            jrst    sqrloop
            exit
    nxtsqr: 0 ;next iteration on x and y
            move    a,x
            jsr     prflt
            movei   tmp," "
            outchr  tmp
            move    a,y
            jsr     prflt
            outstr  newlin
            move    x2,x
            fmp     x2,x2
            move    tmp,y
            fmp     tmp,tmp
            fsb     x2,tmp
            move    y2,y
            fmp     y2,x2
            fmp     y2,[2.0]
            move    x,x2
            move    y,y2
            jrstf   @nxtsqr
    prflt:  0 ;print float less than one in accum a
            fix     b,a
            fltr    c,b
            fsbr    a,c
            jumpge  b,point
            movei   tmp,"-"
            outchr  tmp
    point:  movei   tmp,"."
            outchr  tmp
            movei   digit,1
    digloop:fmpr    a,[10.0]
            fix     tmp,a
            fltr    c,tmp
            fsbr    a,c
            addi    tmp,"0"
            outchr  tmp
            addi    digit,1
            caig    digit,5
            jrst    digloop
            jrstf   @prflt
    end start
