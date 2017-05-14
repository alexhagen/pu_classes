module functions
use variables
implicit none

contains

    function N(E, T)
        real(wp)            ::  E, T, N
        N = 2.0_wp * pi * dsqrt(E) * &
        dexp(- E / (k * T)) / dsqrt((pi * k * T)**3.0_wp)
    end function

end module functions
