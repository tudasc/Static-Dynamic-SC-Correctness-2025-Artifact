CXX = $(SPMDIR_BUILD)/bin/clang++
#spmdir addings
CLINKER = $(CXX)
SPMDVERIFY = $(SPMDIR_BUILD)/bin/spmd-verify

MPIINC = -I$(SPMDIR_BUILD)/includesProgramModels/mpi/include
SPMDFLAGS = check-dataRace emitSPMDIR time
COMPILE_FLAGS=-O0 -flto -fno-exceptions -g $(MPIINC)
LINKFLAGS=-fuse-ld=lld -Wl,--lto-emit-llvm


# USE_TAUPROF=0
# ifeq ($(USE_TAUPROF),1)
# TAU=/soft/perftools/tau/tau-2.29/craycnl/lib
# CXX = tau_cxx.sh -tau_makefile=$(TAU)/Makefile.tau-intel-papi-mpi-pdt 
# endif
# use -xmic-avx512 instead of -xHost for Intel Xeon Phi platforms
OPTFLAGS =  -DPRINT_DIST_STATS -DDISABLE_THREAD_MULTIPLE_CHECK # -fopenmp -O3 #-DPRINT_EXTRA_NEDGES #-DUSE_MPI_RMA -DUSE_MPI_ACCUMULATE #-DUSE_32_BIT_GRAPH #-DDEBUG_PRINTF #-DUSE_MPI_RMA #-DPRINT_LCG_DOUBLE_LOHI_RANDOM_NUMBERS#-DUSE_MPI_RMA #-DPRINT_LCG_DOUBLE_RANDOM_NUMBERS #-DPRINT_RANDOM_XY_COORD
#-DUSE_MPI_SENDRECV
#-DUSE_MPI_COLLECTIVES
# use export ASAN_OPTIONS=verbosity=1 to check ASAN output
CXXFLAGS = $(OPTFLAGS) $(COMPILE_FLAGS) #-g -std=c++11 

OBJ = main.o
TARGET = miniVite

all: $(TARGET)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -o $@ $^ -c

$(TARGET):  $(OBJ)
	$(CLINKER) $^ $(CXXFLAGS) $(LINKFLAGS) -o $(TARGET).bc
	$(SPMDVERIFY) $(SPMDFLAGS) $(TARGET).bc

.PHONY: clean

clean:
	rm -rf *~ $(OBJ) $(TARGET).bc $(TARGET).mlir
