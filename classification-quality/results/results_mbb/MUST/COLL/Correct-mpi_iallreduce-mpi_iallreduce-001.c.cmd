apptainer run --cleanenv /work/home/yo30qaqy/data-race-detection-benchmark-suite/util/apptainer/must.sif mpicc -fsanitize=thread -g -fopenmp results-20250730-145557/MUST/COLL/Correct-mpi_iallreduce-mpi_iallreduce-001.c -o results-20250730-145557/MUST/COLL/Correct-mpi_iallreduce-mpi_iallreduce-001.c.exe-must
apptainer run --cleanenv /work/home/yo30qaqy/data-race-detection-benchmark-suite/util/apptainer/must.sif mktemp -d
apptainer run --cleanenv /work/home/yo30qaqy/data-race-detection-benchmark-suite/util/apptainer/must.sif /opt/must/bin/mustrun -np 2 --must:temp /tmp/tmp.ptOXPW65gn
 --must:clean --must:output stdout --must:distributed --must:nodl --must:tsan --must:rma-race results-20250730-145557/MUST/COLL/Correct-mpi_iallreduce-mpi_iallreduce-001.c.exe-must
