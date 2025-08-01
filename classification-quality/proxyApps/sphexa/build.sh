#!/usr/bin/env bash


# module load cmake
APPNAME=sphexa
CLANGXX=${SPMDIR_BUILD}/bin/clang++
MPIINC=-I${SPMDIR_BUILD}/includesProgramModels/mpi/include

SPMDIR_COMPILEFLAGS="-O1 -flto -fno-exceptions -g -c"
SPMDIR_LINKFLAGS="-fuse-ld=lld -Wl,--lto-emit-llvm -flto"

SPMDVERIFY=${SPMDIR_BUILD}/bin/spmd-verify
SPMDFLAGS="check-dataRace emitSPMDIR"

CXX_EXTRA_FLAGS=${SPMDIR_COMPILEFLAGS}
# configure the build, build type defaults to Release
# The -DMODEL flag is required
cmake -Bbuild -H. \
    -DCMAKE_CXX_COMPILER="${CLANGXX}" \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_CXX_FLAGS="${SPMDIR_COMPILEFLAGS} ${MPIINC}" \
    -DCMAKE_CXX_LINK_FLAGS="${SPMDIR_LINKFLAGS}" \
    -DCMAKE_LINKER="${SPMDIR_BUILD}/bin/lld" 
    # -DALTERNATIVE_BIN_NAME="${APPNAME}.bc" #\
    # -DMPI_HOME="${SPMDIR_BUILD}/includesProgramModels/mpi/"

cmake --build build
cd build
${SPMDVERIFY} ${SPMDFLAGS} ${APPNAME}.bc 
cd ..

    # -DCXXFLAGS="${SPMDIR_COMPILEFLAGS}  ${MPIINC}" \
    # -DLDFLAGS="${SPMDIR_LINKFLAGS}" #<model specific flags prefixed with -D...>