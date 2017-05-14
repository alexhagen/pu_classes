PROGRAM evens
IMPLICIT NONE

INTEGER(4) I,N,sum

READ(*,*) N

sum = 0

DO I=1,N
	IF((DBLE(I)/2.0d0 - I/2) > 0.0d0) CYCLE
	sum = sum + I
END DO

WRITE(*,*) sum

CALL System("mkdir output")
OPEN(10,File="./output/out.dat")
WRITE(10,*) sum
CLOSE(10)

END PROGRAM evens