!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!                                     maxwellian
!                   A two dimensional lagrange interpolation calculator
!                                      Alex Hagen
!
!     Input
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
program maxwellian
! use a variables module which provides global constants and also working
! precision (set to double)
use variables
use functions

! define everything else explicitly
implicit none
! allocate floats for the the high and low energy states and temperature
real(wp)                                ::  T, E_avg, E_high, E_low
! allocate a float for the integral
real(wp)                                ::  integral
! allocatable arrays for the energy to integrate over
real(wp), allocatable, dimension(:)     ::  E
! the number of subintervals and a counter
integer(4)                              ::  num, i
! a throwaway text variables
character(80)                           ::  text

T = 1000.0_wp
E_avg = 3.0_wp * k * T / 2.0_wp
E_low = 0.1_wp * E_avg
E_high = 2.0_wp * E_avg

! read in the number of desired subintervals
call getarg(1, text)
read(text,'(I10)') num

! allocate our energy array
allocate(E(num))
! put the values into the energy array
E(1) = E_low
do i=2,num
    E(i) = E(i-1) + (E_high - E_low) / num
end do

! do the midpoint rule and write this to a file for later plotting
integral = 0.0_wp
do i=2,num
    integral = integral + &
        N((E(i) + E(i-1))/2.0_wp, T) * (E(i) - E(i-1))
end do
write(*,'(E12.5)') integral

! do the trapezoidal rule and write this to a file for later plotting
integral = 0.0_wp
do i=2,num
    integral = integral + &
        (N(E(i),T) + N(E(i-1),T))/2.0_wp * (E(i) - E(i-1))
end do
write(*,'(E12.5)') integral

! do the simpson rule and write this to a file for later plotting
integral = 0.0_wp
do i=2,num
    integral = integral + &
        (&
        N(E(i),T) + 4.0_wp*N((E(i)+E(i - 1))/2.0_wp, T) + &
        N(E(i - 1),T)&
        )/6.0_wp * (E(i) - E(i-1))
end do
write(*,'(E12.5)') integral
end program maxwellian
