c imaginary powers of 10, starting with 10**(i/1024), and squaring successively ten times. 
c this matches with feynman's table 22-3. 
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
  