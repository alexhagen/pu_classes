maxwellian: maxwellian.f90 variables.f90
	gfortran -o maxwellian variables.f90 functions.f90 maxwellian.f90

all: maxwellian

test: maxwellian
	@echo "testing problem statement"

clean:
	@echo "Cleaning directory of generated files"
	rm *.mod
