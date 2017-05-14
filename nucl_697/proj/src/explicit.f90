program explicit_diffusion
use input_output
use linear_algebra
use mesh
implicit none

real(8), allocatable, dimension(:)      ::      x_source, s_source
real(8), allocatable, dimension(:)      ::      x
real(8)                                 ::      Phi, D
real(8)                                 ::      x_total, delta_x, delta_x_min
integer(4)                              ::      n_x
real(8)                                 ::      t_final, delta_t, t
integer(4)                              ::      n_t
integer(4)                              ::      i, j, n
real(8), allocatable, dimension(:)      ::      Ckm1, S
real(8), allocatable, dimension(:)      ::      C
real(8)                                 ::      delta_xj, delta_xjm1, flux
real(8)                                 ::      k_r
logical                                 ::      debug=.FALSE.
real(8)                                 ::      t_save
real(8)                                 ::      t_step
integer(4)                              ::      n_file
character(len=80)                       ::      arg
integer(4)                              ::      status
integer(4)                              ::      arglen

! setting up the parameters
call init(Phi, t_final, t_save, t_step, D, k_r, x_total, delta_x, delta_x_min, n_x)

! Setting up the workspace
call workspace_setup()

!! Read in the inital distribution from a SRIM file
if (debug) write(*,*) "---- Reading the source input file..."
call read_srim("RANGE.txt", x_source, s_source)
!! convert the depth coordinates in x from angstroms to cm
x_source = x_source * 1.0d-8
!! convert the ion deposition source from atoms/cm^3 / atoms/cm^2 to just
!! atoms/cm^3 by multiplying by the fluence
s_source = s_source * Phi

!! Create a mesh
if (debug) write(*,*) "---- Creating a mesh..."
call uniformmesh(0.0d0, x_total, delta_x, n_x, x)
! check if there is an argument to the program.  If not, then define a (stable)
! default time step.  If so, then define that time step. If there are two
! arguments, then the first is a dummy argument and the second is the time
! domain
if (iargc() == 1) then
    call getarg(1, arg)
    read(arg,*) delta_t
end if
if (iargc() == 2) then
    call getarg(1, arg)
    read(arg,*) delta_t
    call getarg(2, arg)
    read(arg,*) t_final
    t_save = t_final / 25.0d0
    t_step = t_save
end if
if (iargc() == 0) then
    ! now calculate our t step for stability
    delta_t = t_final / 10000.0d0
end if
n_t = t_final / delta_t

if (debug) write(*,*) "---- Allocating matrices..."
allocate(C(n_x), Ckm1(n_x), S(n_x))
!! The source term never changes, so we can calculate this only once
if (debug) write(*,*) "---- Populating integral source vector..."
do j = 1, n_x
    S(j) = interp(x_source, s_source, x(j)) * delta_t
end do
Ckm1 = 0.0d0
do j=1, n_x
  C(j) = S(j)
end do
n_file = 0
call print_output(n_file, x, C, 0.0d0)
n_file = n_file + 1
!! now we can go through the time steps
if (debug) write(*,*) "---- Starting time analysis..."
t = 0.0d0
do i = 1, n_t
  ! iterate through the grid
  do j = 1, n_x
      delta_xj = ((x(j) - x(j - 1)) + &
		     (x(j + 1) - x(j)))/2.0d0
	    delta_xjm1 = (x(j) - x(j - 1))
      ! perform the predictor step (euler)
      if (j .eq. 1) then
          flux = - k_r * Ckm1(j)**2.0d0 / D + D * (Ckm1(j + 1) - 2.0d0 * &
            Ckm1(j) + Ckm1(j - 1)) / (delta_xj)/delta_xj
      else
          flux = D * (Ckm1(j + 1) - 2.0d0 * Ckm1(j) + Ckm1(j - 1)) / &
              (delta_xj)/delta_xj
      end if
	C(j) = Ckm1(j) + flux * delta_t + S(j)
  end do
  C(n_x) = 0.0d0
  ! save our updated array to the "last step" array and the ghost cells
  Ckm1 = C
  if (dabs(t - t_save) < 1.0d-15) then
      call print_output(n_file, x, C, t)
      n_file = n_file + 1
      t_save = t_save + t_step
  end if
  t = t + delta_t
  if (debug) write(*,*) "---- Next time step..."
end do

deallocate(C, Ckm1, S)
end program
