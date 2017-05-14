explicit: explicit.f90
	gfortran -o explicit.o variables.f90 input_output.f90 mesh.f90 linear_algebra.f90 explicit.f90

implicit: implicit.f90
	gfortran -o implicit.o variables.f90 input_output.f90 mesh.f90 linear_algebra.f90 implicit.f90

all: explicit implicit

test: implicit explicit
	@make clean
	@echo "Testing Finite Element Method"
	@time ./implicit.o
	@mkdir fem_sol
	@find sim -name '*.dat' -exec mv {} fem_sol/ \;
	@echo "Testing Finite Difference Method"
	@time ./explicit.o
	@mkdir fdm_sol
	@find sim -name '*.dat' -exec mv {} fdm_sol/ \;
	@python diffusion.py

stability: implicit explicit
	@make clean
	@echo "Testing unstable Finite Element Method"
	@time ./implicit.o 1.0d-6
	@mkdir -p fem_unstable
	@find sim -name '*.dat' -exec mv {} fem_unstable/ \;
	@echo "Testing unstable Finite Difference Method"
	@time ./explicit.o 1.0d-5
	@mkdir -p fdm_unstable
	@find sim -name '*.dat' -exec mv {} fdm_unstable/ \;
	@python unstable.py

clean:
	@echo "Cleaning directory of generated files"
	@rm -f *.mod
	@rm -rf sim/ fem_sol/ fdm_sol/ fem_unstable/ fdm_unstable/
