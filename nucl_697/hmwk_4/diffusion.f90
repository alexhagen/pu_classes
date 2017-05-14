program diffusion
implicit none
real(8)                            ::    th, deltaz, deltat, t, t_final
real(8)                            ::    k_r, t_save, deltazi
integer(4)                         ::    num_th_cell, num_t_cell, nfile
real(8), allocatable, dimension(:) ::    center_z
! counters
integer(4)                         ::    i, k, nonuniform
! the concentrations
real(8)                            ::    C_const_o, sigma, z_o, J
real(8), allocatable, dimension(:) ::    C_o, C
! non uniform mesh parameters
real(8)                            ::    alpha, kappa, s, deltamin
! diffusion coefficients
real(8)                            ::    D
! a string for the filename
character(5)                       ::    files
! a string for input
character(80)                      ::    text


!------------------------------ Constants and Setup ----------------------------
! set up a folder to hold our output files
call system('mkdir sim')
! initialize our file number to zero
nfile = 0

! set the diffusion coefficient
D = 5.0d-8                                 ! in cm^2 / s
! set the removal coefficient
k_r = 7.0d-22                              ! in cm^4 / s


!---------------------------------- Meshing ------------------------------------
! find the z mesh parameters
th = 1.0d-4                                ! in cm
deltaz = 1.0d-6                            ! in cm
deltamin = 1.0d-8                          ! in cm
num_th_cell = th / deltaz

! allocate and create the uniform z mesh
allocate(center_z(0:num_th_cell+1))

! read in the whether to make this uniform or non uniform
call getarg(1, text)
read(text,'(I10)') nonuniform

if (nonuniform .eq. 1) then
    ! first, mesh the domain on left points
    center_z(0) = - deltamin
    center_z(1) = 0.0d0
    do i = 2, num_th_cell+1
        center_z(i) = center_z(i - 1) + deltaz
    end do
    ! now calculate the non-uniform mesh parameters
    s = th
    alpha = dlog10(deltamin/s) / dlog10(deltaz/s)
    kappa = s**(1.0d0 - alpha)
    ! now apply that to move all of the left points
    do i=1, num_th_cell + 1
        center_z(i) = ((center_z(i) - center_z(i - 1))**alpha) * kappa
    end do
	! now calculate the midpoints
	do i=1, num_th_cell
		center_z(i) = (center_z(i) + center_z(i + 1)) / 2.0d0
	end do
    ! now calculate our t step for stability
    deltat = deltamin**2.0d0 / (2.0d0 * D)
else
    ! set the initial midpoint of the left cell
    center_z(1) = 0.5d0 * deltaz
    ! iterate through the rest of the array and add on the cell size
    do i = 2, num_th_cell
        center_z(i) = center_z(i - 1) + deltaz
    end do
    ! determine a stable time step size
    deltat = deltaz**2.0d0 / (2.0d0 * D)
end if
! determine how many time cells there are
num_t_cell = t_final / deltat

! assign initial conditions, using a gaussian distribution
C_const_o = 5.0d21                        ! 1/cm^3
z_o = 2.5d-6                              ! in cm
sigma = 1.0d-6                            ! in cm
allocate(C_o(1:num_th_cell), C(1:num_th_cell))
C_o = 0.0d0
C = 0.0d0
do i = 1, num_th_cell
    ! assign the gaussian implantation to the surface
    C_o(i) = C_const_o * &
        dexp(-0.5d0*(center_z(i) - z_o)**2.0d0 / sigma**2.0d0)
end do

! write the initial distribution to a file
write(files, '(I1,I4)') nonuniform, nfile
do k = 1,5
    if (files(k:k) == ' ') files(k:k) = '0'
end do
write(*,*) files
open(10, file='./sim/'//files//'.dat')
do i = 1, num_th_cell
    write(10,"(2E20.5E4)") center_z(i), C_o(i)
end do
close(10)
nfile = nfile + 1

! Initialize time variables
t = 0.0d0
t_save = 1.0d-6                    ! start saving at 1 us
t_final = 101.0d-3                ! 100 ms

! solve the diffusion equation now over each time step
do while (t <= t_final)
    ! iterate through the grid
    do i = 1, num_th_cell
        deltaz = ((center_z(i) - center_z(i - 1)) + &
			(center_z(i + 1) - center_z(i)))/2.0d0
		deltazi = (center_z(i) - center_z(i - 1))
        ! perform the predictor step (euler)
        if ((i .eq. 1) .or. (i .eq. num_th_cell)) then
            J = - k_r * C_o(i) * C_o(i)
        else
            J = D * (C_o(i + 1) - 2.0d0 * C_o(i) + C_o(i - 1)) / &
                (deltaz)/deltazi
        end if
		C(i) = C_o(i) + J * deltat + C_const_o * &
			dexp(-0.5d0*(center_z(i) - z_o)**2.0d0 / sigma**2.0d0) * deltat
    end do
    ! save our updated array to the "last step" array and the ghost cells
    C_o = C

    if (t >= t_save) then
        ! save the information
        write(files, '(I1,I4)') nonuniform, nfile
		do k = 1,5
			if (files(k:k) == ' ') files(k:k) = '0'
		end do
		write(*,*) files
		open(10, file='./sim/'//files//'.dat')
        do i = 1, num_th_cell
            write(10,"(2E20.5E4)") center_z(i), C_o(i)
        end do
        close(10)
        nfile = nfile + 1
        t_save = 10.0 * t_save
    end if

    ! increment our time variable
    t = t + deltat
end do

end program
