module constants
	real(8) pi
end module constants

module functions
	contains
		function func(x, y)
			implicit none
			real(8) x, y, func
			func = (x + y**2.0d0) * dexp((x**2.0d0 + 2.0d0 * y))
		end function func
end module functions

program integration_n_dim
use constants
use functions
implicit none

integer(4) nx, ny, i, j
real(8) x1, x2, y1, y2
real(8) int_midpoint
real(8) deltax, deltay
real(8), allocatable, dimension(:) :: xs, ys
x1 = 0.0d0
x2 = 1.0d0
y1 = 0.0d0
y2 = 1.0d0

int_midpoint = (func(x1,y1)+func(x2,y1)+func(x1,y2)+func(x2,y2)) &
	* (x2 - x1) * (y2 - y1) / 4.0d0

write(*,*) "Midpoint rule value of integral = ", int_midpoint

write(*,*) "Input dimensions:"
read(*,*) nx,ny

allocate(xs(nx))
allocate(ys(2))
deltax = (x2 - x1) / (nx - 1)
deltay = (y2 - y1) / (ny - 1)

xs(1) = x1
do i=2,nx
	xs(i) = xs(i-1) + deltax
end do

ys(1) = y1
do i=2,ny
	ys(i) = ys(i-1) + deltay
end do

int_midpoint = 0.0d0
do i = 1, nx
	do j = 1, ny
		write(*,*) j
		write(*,*) i
		int_midpoint = int_midpoint + &
			(func(xs(i),ys(j))) &
			* (xs(i+1) - xs(i)) * (ys(j+1) - ys(j)) / 4.0d0
	end do
end do

write(*,*) "Composite midpoint rule value of integral = ", int_midpoint


end program integration_n_dim