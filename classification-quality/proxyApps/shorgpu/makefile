CXX = ${SPMDIR_BUILD}/bin/clang++
CLINKER = ${CXX}
SPMDVERIFY = ${SPMDIR_BUILD}/bin/spmd-verify

SPMDFLAGS = check-dataRace emitSPMDIR time
COMPILE_FLAGS=-O1 -flto -fno-exceptions -g
LINKFLAGS=-fuse-ld=lld -Wl,--lto-emit-llvm

MPIINC = -I${SPMDIR_BUILD}/includesProgramModels/mpi/include
NCCLINC = -I${SPMDIR_BUILD}/includesProgramModels/nccl/include
ACCINC = 
INCS = ${MPIINC} ${NCCLINC}

# NVCCFLAGS ?= -g -lineinfo
# NVHPCFLAGS ?= -std=c++17 -acc -fast -gopt -gpu=lineinfo -Minfo=accel -cuda -Mint128
# NVHPCDEFS ?= -DEMULATE_INT128
# NVHPCINCS ?=
# NVHPCLIBS ?=
EXE ?= shorgpu

# if NCCL is not found, set NCCL_HOME to point to your NCCL installation
# (can usually be found within you NVHPC installation directory)
# ifneq ($(NCCL_HOME), "")
# NVHPCINCS += -I$(NCCL_HOME)/include/
# NVHPCLIBS += -L$(NCCL_HOME)/lib
# endif
# NVHPCLIBS += -lnccl

all: $(EXE:%=build/%)

build/%: obj/%.o
	$(CLINKER) -o $(EXE).bc $(LINKFLAGS) $(COMPILE_FLAGS) $^ 
	$(SPMDVERIFY) $(SPMDFLAGS) $(EXE).bc

obj/%.o: src/%.cpp
	$(CXX) $(COMPILE_FLAGS) $(INCS)  -c $< -o $@

clean:
	$(RM) $(EXE:%=build/%) $(EXE:%=obj/%.o) $(EXE:%=obj/%.bc) $(EXE:%=obj/%.mlir)

rebuild:
	$(MAKE) clean
	$(MAKE)

.PHONY: clean rebuild
.PRECIOUS: $(wildcard src/*)
.SECONDARY:





