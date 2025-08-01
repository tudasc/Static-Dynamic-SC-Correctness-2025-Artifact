#!/usr/bin/env sh
set -e

RESULTS_DIR=$PWD/cq-results-$(date +"%Y%m%d-%H%M%S")
echo "Results will be stored in ${RESULTS_DIR}."

mkdir -p ${RESULTS_DIR}/RRB

# RRB

## MPI RMA
python util/run_test.py --tools SPMDIR,PARCOACH-static,PARCOACH-dynamic,RMASanitizer-NoOpt,CoVer,CoVer-MUST -o ${RESULTS_DIR}/RRB/MPIRMA -j 16 RRB --rma-model MPIRMA --disciplines conflict,sync,static,dynamic,rma+nonrma

## SHMEM
python util/run_test.py --tools SPMDIR,RMASanitizer-NoOpt -o ${RESULTS_DIR}/RRB/SHMEM -j 16 RRB --rma-model SHMEM --disciplines conflict,sync,static,dynamic,rma+nonrma

# NVSHMEM
for model in NVSHMEM-hostInitiated NVSHMEM-gpuInitiated NVSHMEM-hybridInitiated; do
    python util/run_test.py --tools SPMDIR -o ${RESULTS_DIR}/RRB/$model -j 16 RRB --rma-model $model --disciplines conflict,sync,static,dynamic,rma+nonrma
done

# MIXED
python util/run_test.py --tools SPMDIR,RMASanitizer-NoOpt -o ${RESULTS_DIR}/RRB/MIXED -j 16 RRB --rma-model MIXED --disciplines sync

## MBB
python util/run_test.py --tools SPMDIR,PARCOACH-static,PARCOACH-dynamic,RMASanitizer-NoOpt,MUST-TSan,CoVer,CoVer-MUST -o ${RESULTS_DIR}/MBB -j 16 MBB --disciplines RMA,P2P,COLL --level 32

sh parse_results.sh ${RESULTS_DIR}