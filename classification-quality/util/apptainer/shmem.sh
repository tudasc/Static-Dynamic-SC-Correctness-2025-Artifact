#!/usr/bin/env bash
set -e

# Install OpenMPI
export OMPI_DIR=/opt/ompi

# Set env variables so we can compile our application
export PATH=$OMPI_DIR/bin:$PATH
export LD_LIBRARY_PATH=$OMPI_DIR/lib:$LD_LIBRARY_PATH


# Install OpenSHMEM
wget https://github.com/Sandia-OpenSHMEM/SOS/archive/refs/tags/v1.5.2.tar.gz -O SOS-1.5.2.tar.gz && \
        tar -xf SOS-1.5.2.tar.gz && \
        cd SOS-1.5.2 && \
        ./autogen.sh && \
        CC=mpicc CXX=mpicxx ./configure --prefix=/usr --with-ofi=/usr --enable-pmi-mpi --disable-cxx --disable-fortran --enable-error-checking --enable-profiling=yes && \
        make -j$(nproc) install