PROGRAM variables
USE varmod
IMPLICIT NONE

OPEN(10,File="input.dat")
READ(10,*) N
allocate(Inarr(N),Outarr(N))
READ(10,*,END=5) (Inarr(I),I=1,N)
5 CLOSE(10)

K = 1

do I=1,N
	if(Inarr(I) == 0) then
		K = K + 1
	else
		Outarr(K) = Inarr(I)*Inarr(I)
		K = K + 1
	end if
end do

write(*,*) (Outarr(I),I=1,N)

END PROGRAM variables