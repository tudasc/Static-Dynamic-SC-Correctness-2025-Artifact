# Correctness Infrastructure and Results

Our evaluation results can be found in the `results/` folder.
It contains the raw data for the MPI-BugBench and RMARaceBench test runs,
as well as the parsed data used in the paper.

## Reproduction

All tests are run inside apptainer containers, which can be built using the configuration scripts in `util/apptainer` or
using the convenience script `build_apptainer_images.sh`.

The tests can then be run using the following commands:
- `python util/run_test.py --tools CoVer,SPMDIR,MUST,CoVer-MUST,SPMDIR-MUST MBB` (for the MPI-BugBench tests)
- `python util/run_test.py --tools CoVer,SPMDIR,MUST,CoVer-MUST,SPMDIR-MUST RRB` (for the RMARaceBench tests)
