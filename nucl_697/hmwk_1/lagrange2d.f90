!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!                                     lagrange2d
!                   A two dimensional lagrange interpolation calculator
!                                      Alex Hagen
!
!     Input     - if no input, output the result of a calculation using
!                   Prop_C.dat at rho = 1E-5 and T = 2.5E4
!               - if input is an integer, use more than one point off of the
!                   desired point to calculate the lagrange poly (higher order)
!               - if input is two integers, create a grid of interpolated points
!                   and output to file, which will be plotted
!               - if three integers, use more higher order lagrange and output
!                   the grid of interpolated points
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
program lagrange2d
! use a variables module which provides global constants and also working
! precision (set to double)
use variables
! use a subroutines modules which has the actual lagrange interpolation coded
! within it
use subroutines

! define everything else explicitly
implicit none
! allocatable arrays for the temperature, density, and thermal conductivity
real(wp), allocatable, dimension(:)     ::  T, rho
real(wp), allocatable, dimension(:,:)   ::  k
! counters
integer(4)                              ::  i, j
! the size of the arrays
integer(4)                              ::  nT, nrho
! a throwaway string
character(80)                           ::  text
! create the values for the point we want to find and the output
real(wp)                                ::  T_i, rho_i, k_i
! an integer for the order of the lagrange interpolation
integer(4)                              ::  order
! an integer for the size of the grid
integer(4)                              ::  numTpts, numrhopts
! allocatable arrays for the grid
real(wp), allocatable, dimension(:)     ::  T_grid, rho_grid
real(wp), allocatable, dimension(:,:)   ::  k_grid
! an integer for the number of full input options
integer(4)                              ::  numopts
! some values to help us with grid creation
real(wp)                                ::  maxT, minT, dT, maxrho, minrho, drho

! set the problem definition
T_i = dlog10(25000.0_wp)
rho_i = dlog10(1.0_wp * 10.0_wp ** (-5.0_wp))
order = 1

! process the input options
! first count the arguments
numopts = iargc()
! if there is one argument, that is the order
if (numopts == 1) then
    call getarg(1, text)
    read(text,'(I2)') order
end if
! if there are two arguments, then they are the grid size
if (numopts == 2) then
    call getarg(1, text)
    read(text,'(I3)') numTpts
    call getarg(2, text)
    read(text,'(I3)') numrhopts
end if
! if there are three arguments, combine the above
if (numopts == 3) then
    call getarg(1, text)
    read(text,'(I3)') numTpts
    call getarg(2, text)
    read(text,'(I3)') numrhopts
    call getarg(3, text)
    read(text,'(I2)') order
end if

! open the file with the points to interpolate
open(10,file="Prop_C.dat")
! read the first line, which is a header
read(10,'(A)') text
! read the second line, which tells how many points we have in each direction
read(10,'(2I3)') nrho, nT
! allocate our arrays of the temperatures, densities, and thermal conductivities
allocate(T(nT),rho(nrho))
allocate(k(nT, nrho))
! now read through the list of temperatures, densities, and thermal
! conductivities
do j=1,nrho
    do i=1, nT
	       read(10,'(3E11.3)') rho(j), T(i), k(i, j)
    end do
end do

! process depending on input
! if we are returning one value - either with default order or with
if (numopts < 2) then
    ! return the value from the function written
    k_i = z_i(T, rho, k, T_i, rho_i, order)
    ! print this in an output statement
    write(*,'(A,F6.0,A,E10.3,A,F9.2)') &
        'Thermal conductivity for temperature ', 10.0_wp ** T_i, &
        ' K and density ', 10.0_wp ** rho_i, ' g/cm^3 = ', 10.0_wp ** k_i
else
    ! allocate the grid for the array
    allocate(T_grid(numTpts), rho_grid(numrhopts), k_grid(numTpts, numrhopts))
    ! create the grid
    minT = minval(T)
    maxT = maxval(T)
    dT = maxT - minT
    minrho = minval(rho)
    maxrho = maxval(rho)
    drho = maxrho - minrho
    do i=1, numTpts
        T_grid(i) = minT + real(i) * (dT / real(nT))
    end do
    do i=1, numrhopts
        rho_grid(i) = minrho + real(i) * (drho / real(nrho))
    end do
    ! calculate the thermal conductivities at each grid point
    do i=1, numTpts
        do j=1, numrhopts
            k_grid(i,j) = z_i(T, rho, k, T_grid(i), rho_grid(i), order)
        end do
    end do
    ! write the thermal conductivities to an output file
    write(text,'(A,I0.3,A,I0.3,A)') 'output_grid_', numTpts, '_x_', numrhopts, &
        '.dat'
    open(20, file=text)
    do i=1, numTpts
        do j=1, numrhopts
            write(20,'(3E11.3)') T_grid(i), rho_grid(j), k_grid(i,j)
        end do
    end do
end if

end program lagrange2d
