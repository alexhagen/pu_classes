module functions
use variables
implicit none

contains

    function z_i(x, y, z, x_i, y_i, order)
        ! input order of the lagrange interpolation
        integer(4)              ::  order
        ! input points taht we're looking for
        real(wp)                :: x_i, y_i
        ! input vectors for the x and y directions
        real(wp)                ::  x(:), y(:)
        ! input tensor for the z values
        real(wp)                ::  z(:,:)
        ! counter integers
        integer(4)              ::  i, j
        ! dimension integers
        integer(4)              ::  nx, ny
        ! index integers surrounding the data points
        integer(4)              :: iin, iout, jin, jout
        ! allocatable arrays for the weights in the x and y directions
        real(wp), allocatable   ::  wx(:), wy(:)
        ! the output value of the interpolation
        real(wp)                ::  z_i

        ! find the sizes of the vectors in the x and y directions
        nx = size(x)
        ny = size(y)
        ! size the weights vectors
        allocate(wx(nx), wy(ny))
        ! now to do the heavy lifting of the lagrange interpolation
        ! first we will find where our list falls in the data
        do i=1, nx
            if (x_i < x(i)) exit
        end do
        iin = i - (1 + (order - 1))
        iout = i + (order - 1)
        do j=1, ny
            if (y_i < y(j)) exit
        end do
        jin = j - (1 + (order - 1))
        jout = j + (order - 1)
        ! first we will create two arrays with the weights in each direction
        ! initialize temperature weights to 1 for multipliciative
        wx = 1.0_wp
        ! go through and create the lagrange interpolation for the temperature direction
        do i=iin, iout
            do j=iin, iout
                if (j /= i) then
                    wx(i) = wx(i) * (x_i - x(j)) / (x(i) - x(j))
                end if
            end do
        end do
        ! initialize density weights to 1 for multipliciative
        wy = 1.0_wp
        ! go through and create the lagrange interpolation for the density direction
        do i=jin, jout
            do j=jin, jout
                if (j /= i) then
                    wy(i) = wy(i) * (y_i - y(j)) / (y(i) - y(j))
                end if
            end do
        end do

        ! now find the point specified
        z_i = 0.0_wp
        do i = iin, iout
            do j = jin, jout
                z_i = z_i + wx(i) * wy(j) * z(i,j)
            end do
        end do

    end function z_i

end module functions
