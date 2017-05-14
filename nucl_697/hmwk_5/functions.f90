module functions
use variables
implicit none

contains

    function d2ydt2_f(y, dydt)
    implicit none

    real(8) y, dydt, d2ydt2_f

    ! calculating the second derivative from the problem statement
    d2ydt2_f = - 0.5d0 * dydt - 10.0d0 * dsin(y)

    end function


end module functions
