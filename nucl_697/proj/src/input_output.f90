module input_output
use variables
implicit none

contains

    subroutine init(Phi, t_final, t_save, t_step, D, k_r, x_total, delta_x, delta_x_min, n_x)
    !! sets up parameters as defined by the problem statement
    real(8), intent(out)                    ::      Phi
        !! the flux \(\Phi\)
    real(8), intent(out)                    ::      D
        !! the diffusion coefficient \(D\) in \(\mathrm{\frac{x}{x}}\)
    real(8), intent(out)                    ::      x_total
    real(8), intent(out)                    ::      delta_x
    real(8), intent(out)                    ::      delta_x_min
    integer(4), intent(out)                 ::      n_x
    real(8), intent(out)                    ::      k_r
    real(8), intent(out)                    ::      t_final
    real(8), intent(out)                    ::      t_save
    real(8), intent(out)                    ::      t_step
        ! Define the fluence in atoms/cm^2 of deuterium incident on the surface
        Phi = 1.0d17
        ! Define the total time we are watching this as 1 microsecond
        t_final = 1.0d-3
        t_save = t_final / 25.0d0
        t_step = t_save
        ! set the diffusion coefficient
        D = 5.0d-8                                 ! in cm^2 / s
        ! set the removal coefficient
        k_r = 7.0d-22                              ! in cm^4 / s
        x_total = 1.0d-5                           ! in cm
        delta_x = 1.0d-7                           ! in cm
        delta_x_min = 1.0d-9                       ! in cm
        n_x = x_total / delta_x

    end subroutine

    subroutine print_output(n, x, y, t)
    !! prints out the output of file \(n\) including the mesh points \(\vec{x}\)
    !! and their values \(\vec{y}\)
      integer(4), intent(in)              ::  n
        !! the file number
      real(8), dimension(:), intent(in)   ::  x
        !! the mesh grid \(\vec{x}\)
      real(8), dimension(:), intent(in)   ::  y
        !! the values \(\vec{y}\) on the mesh grid \(\vec{x}\)
      real(8), intent(in)                 ::  t
        !! the time at which this mesh was taken
      character(6)                        ::  files
        ! a string container for the filename
      integer(4)                          ::  i
        ! a counter
      integer(4)                          ::  fh
        ! the filehandler

      ! initialize the filehandler
      fh = 100 + n
      ! make a file name with the time step number
      write(files, '(I6)') n
      do i = 1, 6
          if (files(i:i) == ' ') files(i:i) = '0'
      end do
      open(fh, file='./sim/'//files//'.dat')
      write(fh, "(A,E20.5E4)") "# t = ", t
      do i = 1, size(y)
          write(fh,"(2E20.5E4)") x(i + 1), y(i)
      end do
      close(fh)
    end subroutine

    subroutine workspace_setup()
    !! This subroutine will setup a workspace for us to generate and save our
    !! simulation files in

        ! set up a folder to hold our output files
        call system('mkdir -p sim')

        return
    end subroutine

    subroutine read_srim(filename, x, s)
    !! This subroutine opens a SRIM output file and reads the distribution of
    !! ions in the sample, outputting those to x and s

        ! Arguments
        character(len=*), intent(in)           ::      filename
            !! the name of the SRIM output file - usually RANGE.txt
        real(8), allocatable, dimension(:), intent(out) ::  x
            !! the right hand x coordinate of the depth bin
        real(8), allocatable, dimension(:), intent(out) ::  s
            !! the amount of ions deposited in the bin
        character(100)                      ::      buffer
        integer(4)                          ::      n, j, i, eof=0
        real(8)                             ::      dummy

        ! open the file
        open(10, file=filename)
        ! initialize our line counter to zero
        n = 0
        j = 0
        do
            ! run through lines until we find one with data
            read(10, "(A)", iostat=eof) buffer
            if (eof < 0) exit
            if (buffer(:1) .ne. '#') then
                n = n + 1
            else
                j = j + 1
            end if
        end do
        ! rewind to the start
        rewind(10)
        ! read through all headers
        do i=1,j
            read(10, "(A)") buffer
        end do
        ! allocate our array
        allocate(x(n), s(n))
        ! read through every data points
        do i=1,n
            read(10, "(3E12.0E2)") x(i), s(i), dummy
        end do
        close(10)
    end subroutine

end module input_output
