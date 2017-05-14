program pendulum
use functions
implicit none
real(8) h, d2ydt2, dydt, y, y0, dydt0, t, y_pred, dydt_pred
real(8) k1, k2
real(8) epsilon, y_old
character(80) fname



! set the initial conditions
! initial position
y0 = 0.5
! initial velocity in the y direction
dydt0 = 0.0
! initial convergence criteria can be anything as long as it's big, it'll get
! updated on the first run
epsilon = 1.0d0
y_old = 0.0d0

h = 0.5d0
! open a file to put the results and plot convergence
open(20, file='convergence.dat')
! loop until the convergence criteria returns false (epsilon drops below 1E-5)
do while (epsilon > 1.0d-5)
    ! create a string with our write file name
    ! print our time step to the file
    write(fname,'(A,f8.6,A)') "pendulum_",h,".dat"
    ! open that file
    open(10, file=fname)
    ! initialize these to the running variables
    y = y0
    dydt = dydt0
    d2ydt2 = d2ydt2_f(y, dydt)
    ! loop through all the time steps
    t = 0.0d0
    do while (t < 2.5)
        ! using explicit (euler) method, predict the position and velocity
        y_pred = y + h * dydt
        dydt_pred = dydt + h * d2ydt2_f(y, dydt)

        ! using rk2 and the predicted position and velocities, find a more
        ! accurate solution for the position, velocity, and acceleration
        k1 = dydt
        k2 = dydt_pred
        y = y + 0.5d0 * h * (k1 + k2)
        k1 = d2ydt2_f(y, dydt)
        k2 = d2ydt2_f(y_pred, dydt_pred)
        dydt = dydt + 0.5d0 * h * (k1 + k2)
        d2ydt2 = d2ydt2_f(y, dydt)

        ! write to an output file
        write(10,'(4E15.5)') t, y, dydt, d2ydt2
        !increment the time step
        t=t+h
    end do
    close(10)
    ! write the final result to the convergence file
    ! check our convergence criteria
    epsilon = dabs( y - y_old )
    write(20, '(2E15.5)') h, epsilon
    ! save the value we calculated
    y_old = y
    ! half the step size
    h = h / 2.0d0
end do
close(20)

end program
