pendulum: pendulum.f90 variables.f90 functions.f90
	gfortran -o pendulum variables.f90 functions.f90 pendulum.f90

all: pendulum

test: pendulum
	@echo "testing problem statement"
	./pendulum
	python pendulum.py

clean:
	@echo "Cleaning directory of generated files"
	rm *.mod
