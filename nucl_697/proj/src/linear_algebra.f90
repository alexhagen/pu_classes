module linear_algebra
use variables
implicit none

contains

    function interp(x, f, x_i)
    !! find a linearly interpolated value of a function \(f\left(x\right)\) at
    !! point \(x_{i}\) given values of the function in \(\vec{f}\) at points
    !! \(\vec{x}\)
        ! Arguments
        real(8), dimension(:)   ::   f
            !! the function points
        real(8), dimension(:)   ::  x
            !! the mesh on which the function points are provided
        real(8)                 ::  x_i
            !! the point at which the function value is desired
        real(8)                ::  interp
            !! the value at point x_i
        integer(4)                          ::  i, j
        if (x_i < x(1)) then
          interp = f(1)
          return
        end if
        if (x_i > x(size(x))) then
          interp = f(size(x))
          return
        end if
        ! First, find the inteval in x where x_i resides
        do i=2, size(x)
            if (x(i) >= x_i .and. x(i-1) <= x_i) exit
        end do
        ! now, linearly interpolate the value and return it
        interp = (x_i - x(i - 1))/(x(i) - x(i - 1)) * (f(i) - f(i - 1)) &
            + f(i - 1)
        return
    end function

    subroutine matvecmult(M, v, outv)
    !! multiply a matrix \(\mathbb{M}\) and a vector \(\vec{v}\) and get result
    !! \(\vec{outv}\)
        ! Arguments
        real(8), dimension(:,:), intent(in)         ::  M
            !! The matrix
        real(8), dimension(:), intent(in)           ::  v
            !! The vector
        real(8), dimension(:), allocatable, intent(out)          ::  outv
            !! The result
        integer(4)                                  ::  i, j

        ! allocate the output vector
        allocate(outv(size(v)))
        ! initialize the result to zero
        outv = 0.0d0
        do i=1,size(v)
            do j=1,size(v)
                outv(i) = outv(i) + M(i, j) * v(j)
            end do
        end do
    end subroutine

    subroutine solve(A, x, b)
    !! solve the equation \(\mathbb{A}\vec{x} = \vec{b}\) for \(\vec{x}\) using
    !! Gauss-Seidel method
        ! Arguments
        real(8), dimension(:,:), intent(in)         ::  A
            !! The matrix \(\mathbb{A}\) to be inverted
        real(8), dimension(:), intent(in)           ::  b
            !! The vector \(\vec{b}\) with the boundary conditions
        real(8), dimension(:), intent(out)          ::  x
            !! The vector solution \(\vec{x}\)
        integer(4)                                  ::  i, j
            ! some counters
        real(8)                                     ::  sum1, sum2, oldx
            ! some holder variables
        real(8)                                     ::  epsilon
            ! convergence criteria

        ! initialize to ones (guesses)
        x = 1.0d0
        epsilon = 1.0d0
        do while (epsilon > 1.0d-4)
            epsilon = 0.0d0
            do i = 1, size(x)
                oldx = x(i)
                sum1 = 0.0d0
                sum2 = 0.0d0
                do j = 1, i-1
                    sum1 = sum1 + A(i, j) * x(j)
                end do
                do j = i + 1, size(x)
                    sum2 = sum2 + A(i, j) * x(j)
                end do
                x(i) = (1.0d0/A(i,i)) * (b(i) - sum1 - sum2)
                if (dabs(x(i) - oldx) > epsilon) epsilon = dabs(x(i) - oldx)
            end do
        end do
    end subroutine

end module linear_algebra
