lagrange2d: lagrange2d.f90 variables.f90
	gfortran -o lagrange2d variables.f90 functions.f90 subroutines.f90 lagrange2d.f90

all: lagrange2d

test: lagrange2d Prop_C.dat
	@echo "testing problem statement"

clean:
	@echo "Cleaning directory of generated files"
	rm *.mod
