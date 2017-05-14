program implicit_diffusion
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
real(8), allocatable, dimension(:,:)    ::      K, M, Mkm1, A
real(8), allocatable, dimension(:)      ::      Ckm1, l, S, b, Mkm1Ckm1
real(8), allocatable, dimension(:)      ::      C
real(8)                                 ::      delta_xj, delta_xjm1
real(8)                                 ::      k_r
logical                                 ::      debug=.FALSE.
real(8)                                 ::      t_save, t_step
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


!! Lets actually create a stiffness matrix, dissipation matrix, source term,
!! history term, and forcing term
if (debug) write(*,*) "---- Allocating matrices..."
allocate(K(n_x, n_x), M(n_x, n_x), Mkm1(n_x, n_x), A(n_x, n_x))
allocate(C(n_x), Ckm1(n_x), l(n_x), b(n_x), S(n_x))
!! The source term never changes, so we can calculate this only once
if (debug) write(*,*) "---- Populating integral source vector..."
do j = 1, n_x
    S(j) = interp(x_source, s_source, x(j)) * delta_t
end do
if (debug) write(*,*) "---- Initializing matrices..."
M = 0.0d0
Mkm1 = 0.0d0
Ckm1 = 0.0d0
do j=1, n_x
  C(j) = S(j)
end do
n_file = 0
call print_output(n_file, x, C, 0.0d0)
n_file = n_file + 1
!! The dissipation matrix and history dissipation matrix never change, so we can
!! calculate this only once
if (debug) write(*,*) "---- Populating dissipation matrix..."
do j = 1, n_x
    if (j - 1 > 0) M(j, j - 1) = delta_x / (6.0d0 * D * delta_t)
    M(j, j) = 4.0d0 * delta_x / (6.0d0 * delta_t * D)
    if (j < n_x) M(j, j + 1) = delta_x / (6.0d0 * D * delta_t)
    ! if (j - 1 > 0) Mkm1(j, j - 1) = delta_x / (6.0d0 * D * delta_t)
    Mkm1(j, j) = delta_x / (delta_t * D)
    ! if (j < n_x) Mkm1(j, j + 1) = delta_x / (6.0d0 * D * delta_t)
end do
M(1,1) = 2.0d0 * M(1,1)
Mkm1(1,1) = Mkm1(1,1) / 2.0d0
!! now we can go through the time steps
if (debug) write(*,*) "---- Starting time analysis..."
t = 0.0d0
do i = 1, n_t
    if (debug) write(*,*) "---- Initializing mutable matrices..."
    !! initialize all of the matices and vectors to zero
    do j=1, n_x
      do n=1, n_x
        K(j, n) = 0.0d0
        A(j, n) = 0.0d0
      end do
      l(j) = 0.0d0
      C(j) = 0.0d0
      b(j) = 0.0d0
    end do
    if (debug) write(*,*) "---- Populating forcing element..."
    !! construct the first term of the forcing element
    l(1) = - k_r * Ckm1(1)**2.0d0 / D
    if (debug) write(*,*) "---- Populating stiffness matrix..."
    !! Loop through the mesh elements and construct the terms
    do j = 1, n_x
        !! find the mesh spacing
        delta_xjm1 = x(j) - x(j - 1)
        delta_xj = x(j+1) - x(j)
        !! now we can create the stiffness matrix
        if (j - 1 > 0) K(j, j - 1) = - 1.0d0 / (delta_xjm1)
        K(j, j) = 1.0d0 / (delta_xjm1) + 1.0d0 / (delta_xj)
        if (j < n_x) K(j, j + 1) = - 1.0d0 / (delta_xj)
    end do
    if (debug) write(*,*) "---- Combining matrices to form A..."
    do j=1,n_x
      do n=1, n_x
        A(j, n) = K(j, n) + M(j,n)
      end do
    end do
    !! Then, solve the matrix and print the solution
    if (debug) write(*,*) "---- Multiplying history dissipation term with history vector..."
    call matvecmult(Mkm1, Ckm1, Mkm1Ckm1)
    if (debug) write(*,*) "---- Combining vectors to form b..."
    do j=1, n_x
      b(j) = l(j) + Mkm1Ckm1(j)
    end do
    do j = 1, n_x
        A(n_x, j) = 0.0d0
        A(j, n_x) = 0.0d0
    end do
    A(n_x, n_x) = 1.0d0
    b(n_x) = 0.0d0
    if (debug) write(*,*) "---- Solving system of equations..."
    call solve(A, C, b)
    if (debug) write(*,*) "---- Adding source to the equations..."
    do j=1, n_x
      C(j) = C(j) + S(j)
    end do
    if (debug) write(*,*) "---- Outputting..."
    if (dabs(t - t_save) < 1.0d-15) then
        call print_output(n_file, x, C, t)
        n_file = n_file + 1
        t_save = t_save + t_step
    end if
    if (debug) write(*,*) "---- Incrementing time..."
    do j=1, n_x
      Ckm1(j) = C(j)
    end do
    t = t + delta_t
    if (debug) write(*,*) "---- Next time step..."
end do

deallocate(K, M, Mkm1, A)
deallocate(C, Ckm1, l, b, S)
end program
