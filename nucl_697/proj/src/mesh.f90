module mesh
use variables
implicit none

contains

    subroutine uniformmesh(x1, x2, delta_x, n_x, x)
      !! creates a uniform mesh with size delta_x
      ! Arguments
      real(8), intent(in)                 ::  x1
        !! the left size of the mesh boundary
      real(8), intent(in)                 ::  x2
        !! the right side of the mesh boundary
      real(8), intent(in)                 ::  delta_x
        !! the largest element size
      real(8), dimension(:), allocatable  ::  x
        !! the mesh midpoints
      integer(4), intent(out)             ::  n_x
        !! the number of mesh elements
      integer(4)                          ::  i, j
        ! counters

      ! determine the number of mesh elements
      n_x = (x2 - x1) / delta_x

      ! allocate and create the uniform z mesh
      allocate(x(0:n_x+1))

      x(0) = x1 - delta_x
      x(1) = x1
      X(2) = x1 + delta_x
      do j = 3, n_x + 1
          x(j) = x(j - 1) + delta_x
      end do
      ! now calculate the midpoints
      do j=0, n_x
          x(j) = (x(j) + x(j + 1)) / 2.0d0
      end do
    end subroutine

  subroutine nonuniformmesh(x1, x2, delta_x, delta_x_min, n_x, x)
    !! creates a nonuniform mesh with size varying from delta_x_min on the left
    !! edge of the boundary to delta_x on the right edge of the boundary.  The
    !! element sizes vary as \(\log\left(\frac{a}{a^{n}}\right)\)
    ! Arguments
    real(8), intent(in)                 ::  x1
      !! the left size of the mesh boundary
    real(8), intent(in)                 ::  x2
      !! the right side of the mesh boundary
    real(8), intent(in)                 ::  delta_x
      !! the largest element size
    real(8), intent(in)                 ::  delta_x_min
      !! the smallest element size
    real(8), dimension(:), allocatable  ::  x
      !! the mesh midpoints
    integer(4), intent(out)             ::  n_x
      !! the number of mesh elements
    real(8)                             ::  mesh_s, kappa, alpha
      ! some meshing variables
    integer(4)                          ::  i, j
      ! counters

    ! determine the number of mesh elements
    n_x = (x2 - x1) / delta_x

    ! allocate and create the uniform z mesh
    allocate(x(0:n_x+1))

    x(0) = x1 - delta_x_min
    x(1) = x1
    X(2) = x1 + delta_x_min
    do j = 3, n_x + 1
        x(j) = x(j - 1) + delta_x
    end do
    ! now calculate the non-uniform mesh parameters
    mesh_s = x2 - x1
    alpha = dlog10(delta_x_min/mesh_s) / dlog10(delta_x/mesh_s)
    kappa = mesh_s**(1.0d0 - alpha)
    ! now apply that to move all of the left points
    do j=3, n_x + 1
        x(j) = ((x(j) - x(j - 1))**alpha) * kappa
    end do
    ! now calculate the midpoints
    do j=0, n_x
    	x(j) = (x(j) + x(j + 1)) / 2.0d0
    end do
  end subroutine

end module mesh
