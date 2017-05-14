PROGRAM quadratic
IMPLICIT NONE

!---------------- quadratic --------------------
! this program will factor a quadratic equation
! given a, b, and c from an input file, given
! the form a*x^2 + b*x + c = 0

REAL(8) a,b,c,x
OPEN(10,File="input.dat")

READ(10,*) a,b,c

x = (b + SQRT(b * b - 4.0d0 * a * c)) / (2.0d0 * a)
WRITE(*,*) x
x = (b - SQRT(b * b - 4.0d0 * a * c)) / (2.0d0 * a)
WRITE(*,*) x

END PROGRAM quadratic