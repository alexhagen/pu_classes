PROGRAM start
IMPLICIT NONE

REAL(8) a,b,x

!READ(*,*) a,b
OPEN(10,File="input.dat")
READ(10,*) a,b

IF(a<0.0d0 .or. a>0.0d0) THEN
	x = -b / a
	WRITE(*,*) x
ELSE
	WRITE(*,*) "We don't have a solution!"
END IF

END PROGRAM start