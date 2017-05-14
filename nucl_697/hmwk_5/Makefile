mc: mc.f90
	gfortran -o mc.out mc.f90

all: mc

test: mc
	@make clean
	@echo "testing problem statement"
	@./mc.out 4 > mc_results_4.dat
	@./mc.out 6 > mc_results_6.dat
	@./mc.out 8 > mc_results_8.dat
	@python mc.py

clean:
	@echo "Cleaning directory of generated files"
	@rm -f *.mod
