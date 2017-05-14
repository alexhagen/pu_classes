diffusion: diffusion.f90
	gfortran -o diffusion diffusion.f90

all: diffusion

test: diffusion
	@make clean
	#@echo "testing problem statement"
	#@echo "testing the uniform mesh case and plotting"
	@./diffusion 0
	#@python diffusion.py 0
	#@make clean
	@echo "testing the nonuniform mesh case and plotting"
	@./diffusion 1
	#@python diffusion.py 1

clean:
	@echo "Cleaning directory of generated files"
	@rm -f *.mod
	@rm -f sim/*
