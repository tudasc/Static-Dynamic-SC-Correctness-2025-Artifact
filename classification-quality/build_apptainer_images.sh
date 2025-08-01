#!/usr/bin/env bash


(cd util/apptainer && git clone --branch spmd-ir-paper-eurompi-2025 git@git-ce.rwth-aachen.de:spmd-ir/spmd.git spmdir)
(cd util/apptainer && apptainer build spmdir.sif Apptainer.spmdir.def)
(cd util/apptainer && apptainer build cover.sif Apptainer.cover.def)
(cd util/apptainer && apptainer build rmasanitizer.sif Apptainer.rmasanitizer.def)
(cd util/apptainer && apptainer build must.sif Apptainer.must.def)
(cd util/apptainer && apptainer build parcoach.sif Apptainer.parcoach.def)
