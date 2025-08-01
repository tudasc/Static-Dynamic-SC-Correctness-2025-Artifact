apptainer run --cleanenv /work/home/yo30qaqy/data-race-detection-benchmark-suite/util/apptainer/must.sif mpicc -fsanitize=thread -g -fopenmp results-20250730-140308/MUST/static/004-MPI-static-get-load-aliasing-local-yes.c -o results-20250730-140308/MUST/static/004-MPI-static-get-load-aliasing-local-yes.c.exe-must
apptainer run --cleanenv /work/home/yo30qaqy/data-race-detection-benchmark-suite/util/apptainer/must.sif mktemp -d
apptainer run --cleanenv /work/home/yo30qaqy/data-race-detection-benchmark-suite/util/apptainer/must.sif /opt/must/bin/mustrun -np 2 --must:temp /tmp/tmp.jrD2zTWjkg
 --must:clean --must:output stdout --must:distributed --must:nodl --must:tsan --must:rma-race results-20250730-140308/MUST/static/004-MPI-static-get-load-aliasing-local-yes.c.exe-must
