apptainer run --cleanenv /work/home/yo30qaqy/data-race-detection-benchmark-suite/util/apptainer/must.sif mpicc -fsanitize=thread -g -fopenmp results-20250730-140308/MUST/static/029-MPI-static-flush-multiple-wins-local-yes.c -o results-20250730-140308/MUST/static/029-MPI-static-flush-multiple-wins-local-yes.c.exe-must
apptainer run --cleanenv /work/home/yo30qaqy/data-race-detection-benchmark-suite/util/apptainer/must.sif mktemp -d
apptainer run --cleanenv /work/home/yo30qaqy/data-race-detection-benchmark-suite/util/apptainer/must.sif /opt/must/bin/mustrun -np 3 --must:temp /tmp/tmp.vKkFpfQQKo
 --must:clean --must:output stdout --must:distributed --must:nodl --must:tsan --must:rma-race results-20250730-140308/MUST/static/029-MPI-static-flush-multiple-wins-local-yes.c.exe-must
