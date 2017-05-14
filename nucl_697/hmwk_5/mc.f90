program mc
implicit none

real(8)                               ::    maxf, tot, sigma
real(8), allocatable, dimension(:)    ::    integral
real(8)                               ::    ksi, chi, eta, x_r, f, f_r
integer(4)                            ::    i, j, k, n
real(8)                               ::    deltauni, s
integer(4)                            ::    dim
real(8), allocatable, dimension(:)    ::    mesh
character(80)                         ::    text

! definition of some parameters
s = 1.0d-1                ! 0.1 in cm
dim = 200                ! number of cells

! create the uniform mesh
allocate(mesh(dim+1))
allocate(integral(dim))
deltauni = s / dble(dim)
mesh(1) = 0.0d0
do i=2, dim+1
    mesh(i) = mesh(i - 1) + deltauni
end do

! read in the number of desired particles
call getarg(1, text)
read(text,'(I10)') n
n= 10**n

! pass in the maximum value of the function
maxf = 1.0d0
! initialize the sum
tot = dble(n)
integral = 0.0d0
! initialize the standard deviation parameter
sigma = 1.0d-2 / 2.0d0 ! 1/2 of FWHM in cm

! cycle through number
do i=1, n
    ! find a mesh interval for the x cordinate that's randomly chosen
    ksi = rand()
    x_r = mesh(1) + (mesh(dim+1) - mesh(1)) * ksi

    ! determine the gaussian value in that mesh interval
    f = dexp(- x_r * x_r / sigma / sigma )

    ! create another random number which is the chosen random value
    chi = rand()
    f_r = maxf * chi

    ! now, if the value is less than the gaussian and another random number is
    ! less than the reflection coefficient, it deposits energy
    if (f_r <= f) then
        do k=1, dim+1
            if (x_r >= mesh(k) .and. x_r < mesh(k+1)) then
                eta = rand()
                if (eta < 0.70d0) then
                    integral(k) = integral(k) + 1.0d0
                end if
            end if
        end do
    end if
end do

! finally, we have an integral based on a 1x1 interval, so convert this to the
! realistic value (I_real = I_1 * 1x10^10 W/cm^2 * 10 ns / n_photon)
integral = integral * 1.0d10 * 10.0d-9 / dble(n)

! output this to stdout based on the mesh interval
do k=1, dim+1
    write(*,*) mesh(k),integral(k)
end do
end program
