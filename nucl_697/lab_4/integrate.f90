! int (sin(x) - 0.5(x) dx) from 0 pi/2
! - cos(x)|_0 ^ pi/2 - 0.5 x^2 / 2 |_0 ^ pi/2
! =


program integration
implicit none

integer(4) nx, i
real(8), allocatable, dimension(:) :: xs
real(8) func
real(8) int_midpoint, x1, x2, pi, midpoint
real(8) int_analytical, int_simpson, int_trap
real(8) delta
pi = 3.14159265358979d0
x1 = 0.0d0
x2 = pi / 2.0d0
midpoint = (x2-x1)/2.0d0

int_analytical = (- dcos(x2) - 0.25d0 * (x2)**2.0d0) &
	- (- dcos(x1) - 0.25d0 * (x1)**2.0d0)
int_midpoint = func(midpoint) * (x2 - x1)
int_trap = (func(x1) + func(x2))/2.0d0 * (x2 - x1)
int_simpson = (func(x1) + 4.0d0 * func(midpoint) + func(x2)) &
	* (x2 - x1) / 6.0d0

write(*,*) "Midpoint rule value of integral = ", int_midpoint
write(*,*) "Trapezoidal rule value of integral = ", int_trap
write(*,*) "Simpson rule value of integral = ", int_simpson
write(*,*) "Analytical value of integral = ", int_analytical

write(*,*) "How many intervals?"
read(*,*) nx

allocate(xs(nx))
delta = (x2 - x1) / (nx - 1.0d0)
xs(1) = x1
do i=2,nx
	xs(i) = xs(i-1) + delta
end do

int_midpoint = 0.0d0
do i=1,nx-1
	midpoint = (xs(i+1) + xs(i))/2.0d0
	int_midpoint = int_midpoint + func(midpoint) * (xs(i+1) - xs(i))
end do

int_simpson = 0.0d0
do i=1,nx-1
	midpoint = (xs(i+1) + xs(i))/2.0d0
	int_simpson = int_simpson + &
		(func(xs(i)) + 4.0d0 * func(midpoint) + func(xs(i+1))) &
		* (xs(i+1) - xs(i)) / 6.0d0
end do

write(*,*) "Composite Midpoint rule value of integral = ", int_midpoint
write(*,*) "Composite Simpson rule value of integral = ", int_simpson
end program integration

function func(y)
	implicit none
	real(8) y, func
	func = dsin(y) - 0.5d0 * y
end function