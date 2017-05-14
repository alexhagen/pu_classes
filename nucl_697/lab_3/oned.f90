program interpolation
implicit none

integer(4) ntemp,i,j,iin,iout
character(80) text
real(8) tempfix, thfix, thfix_high
real(8),allocatable,dimension(:) :: temp, thcond, weights

open(10,file="Prop_C_solid.dat")
read(10,'(A)') text
read(10,'(I3)') ntemp

allocate(temp(ntemp),thcond(ntemp),weights(ntemp))

do i=1,ntemp
	read(10,'(2E11.3)') temp(i),thcond(i)
end do

tempfix=dlog10(800.0d0)
do i=1,ntemp
	if(tempfix<temp(i)) exit
end do
iin=i-1
iout = i

if(i==1) then
	iin=1
	iout=2
end if

if(i>ntemp) then
	iin = ntemp-1
	iout = ntemp
end if

! thfix = (tempfix-temp(i))/(temp(i-1)-temp(i))*thcond(i-1) &
! 	+ (tempfix-temp(i-1))/(temp(i)-temp(i-1))*thcond(i)

thfix = (tempfix-temp(iout))/(temp(iin)-temp(iout))*thcond(iin) &
	+ (tempfix-temp(iin))/(temp(iout)-temp(iin))*thcond(iout)

write(*,*) 'Thermal conductivity for Temperature', &
	10.0d0**tempfix,' = ',10.0d0**thfix

weights = 1.0d0

do i=10,30
	do j=10,30
		if (j/=i) then
			weights(i) = weights(i) * &
				(tempfix-temp(j))/(temp(i)-temp(j))
		end if
	end do
end do

thfix_high=0.0d0
do i=10,30
	thfix_high = thfix_high+weights(i)*thcond(i)
end do

write(*,*) 'Thermal conductivity for Temperature', &
	10.0d0**tempfix,' = ',10.0d0**thfix_high

end program