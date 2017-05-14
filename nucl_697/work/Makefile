# Linux Intel Compiler
OBJ    = .o
EXE    =
COMPILE = -c
REEXE  = -o
DELETE = rm -f
COPY   = cp
FFLAGS = -O3
INCLUDE = -I. -I..
FF      = ifort
DELEXT  = *.d *.il

TARGET          = Test_L
ROOTSRC         = ./

ROOTOBJS = hello_world$(OBJ)

OBJS =  $(ROOTSRC)*$(OBJ)

all: Linux

%.o : %.f90
	$(FF) $(FFLAGS) $(COMPILE) $(INCLUDE) $<

%.o : %.F90
	$(FF) $(FFLAGS) $(COMPILE) $(INCLUDE) $<	

.f.mod:
	$(FF) $(FFLAGS) $(COMPILE) $<

CompileRoot: $(ROOTOBJS)

LinkAll: $(OBJS)
	$(FF) $(FFLAGS) $(REEXE)$(TARGET)$(EXE) $(OBJS)

Linux:
	( $(MAKE) OS='Linux' CompileRoot \
	)
	$(MAKE) OS='Linux' LinkAll \

clean:
	$(DELETE) $(OBJS) *.mod core  *~ $(DELEXT) *.d $(TARGET)$(EXE)





